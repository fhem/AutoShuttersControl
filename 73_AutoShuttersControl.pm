###############################################################################
#
# Developed with Kate
#
#  (c) 2018 Copyright: Marko Oldenburg (leongaultier at gmail dot com)
#  All rights reserved
#
#   Special thanks goes to:
#       - Bernd (Cluni) this module is based on the logic of his script "Rollladensteuerung für HM/ROLLO inkl. Abschattung und Komfortfunktionen in Perl" (https://forum.fhem.de/index.php/topic,73964.0.html)
#       - Beta-User for many tests and ideas
#
#
#  This script is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License,or
#  any later version.
#
#  The GNU General Public License can be found at
#  http://www.gnu.org/copyleft/gpl.html.
#  A copy is found in the textfile GPL.txt and important notices to the license
#  from the author is found in LICENSE.txt distributed with these scripts.
#
#  This script is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#
# $Id$
#
###############################################################################

### Notizen
# - Feststellen ob ein Rolladen fährt oder nicht

package main;

use strict;
use warnings;

my $version = "0.1.80.25";

sub AutoShuttersControl_Initialize($) {
    my ($hash) = @_;

## Da ich mit package arbeite müssen in die Initialize für die jeweiligen hash Fn Funktionen der Funktionsname
    #  und davor mit :: getrennt der eigentliche package Name des Modules
    $hash->{SetFn}    = "AutoShuttersControl::Set";
    $hash->{GetFn}    = "AutoShuttersControl::Get";
    $hash->{DefFn}    = "AutoShuttersControl::Define";
    $hash->{NotifyFn} = "AutoShuttersControl::Notify";
    $hash->{UndefFn}  = "AutoShuttersControl::Undef";
    $hash->{AttrFn}   = "AutoShuttersControl::Attr";
    $hash->{AttrList} =
        "disable:0,1 "
      . "disabledForIntervals "
      . "ASC_guestPresence:on,off "
      . "ASC_temperatureSensor "
      . "ASC_temperatureReading "
      . "ASC_brightnessMinVal "
      . "ASC_brightnessMaxVal "
      . "ASC_autoShuttersControlMorning:on,off "
      . "ASC_autoShuttersControlEvening:on,off "
      . "ASC_autoShuttersControl_Shading:on,off "
      . "ASC_autoShuttersControlComfort:on,off "
      . "ASC_sunPosDevice "
      . "ASC_sunPosReading "
      . "ASC_sunElevationDevice "
      . "ASC_sunElevationReading "
      . "ASC_residentsDevice "
      . "ASC_residentsDeviceReading "
      . "ASC_autoAstroModeMorning:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON "
      . "ASC_autoAstroModeMorningHorizon:-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9 "
      . "ASC_autoAstroModeEvening:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON "
      . "ASC_autoAstroModeEveningHorizon:-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9 "
      . "ASC_antifreezeTemp:-5,-4,-3,-2,-1,0,1,2,3,4,5 "
      . "ASC_timeUpHolidayDevice "
      . $readingFnAttributes;

## Ist nur damit sich bei einem reload auch die Versionsnummer erneuert.
    foreach my $d ( sort keys %{ $modules{AutoShuttersControl}{defptr} } ) {
        my $hash = $modules{AutoShuttersControl}{defptr}{$d};
        $hash->{VERSION} = $version;
    }
}

## unserer packagename
package AutoShuttersControl;

use strict;
use warnings;
use POSIX;

use GPUtils qw(:all)
  ;    # wird für den Import der FHEM Funktionen aus der fhem.pl benötigt
use Data::Dumper;    #only for Debugging
use Date::Parse;

my $missingModul = "";
eval "use JSON qw(decode_json encode_json);1" or $missingModul .= "JSON ";

## Import der FHEM Funktionen
BEGIN {
    GP_Import(
        qw(devspec2array
          readingsSingleUpdate
          readingsBulkUpdate
          readingsBulkUpdateIfChanged
          readingsBeginUpdate
          readingsEndUpdate
          defs
          modules
          Log3
          CommandAttr
          attr
          CommandDeleteAttr
          CommandDeleteReading
          CommandSet
          AttrVal
          ReadingsVal
          Value
          IsDisabled
          deviceEvents
          init_done
          addToDevAttrList
          addToAttrList
          delFromDevAttrList
          delFromAttrList
          gettimeofday
          sunset_abs
          sunrise_abs
          InternalTimer
          RemoveInternalTimer
          computeAlignTime
          ReplaceEventMap)
    );
}

## Die Attributsliste welche an die Rolläden verteilt wird. Zusammen mit Default Werten
my %userAttrList = (
    'ASC_Mode_Up:absent,always,off'                                 => 'always',
    'ASC_Mode_Down:absent,always,off'                               => 'always',
    'ASC_Up:time,astro,brightness'                                  => 'astro',
    'ASC_Down:time,astro,brightness'                                => 'astro',
    'ASC_AutoAstroModeMorning:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON' => 'none',
'ASC_AutoAstroModeMorningHorizon:-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9'
      => 'none',
    'ASC_AutoAstroModeEvening:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON' => 'none',
'ASC_AutoAstroModeEveningHorizon:-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9'
      => 'none',
    'ASC_Open_Pos:0,10,20,30,40,50,60,70,80,90,100'   => [ '', 0,   100 ],
    'ASC_Closed_Pos:0,10,20,30,40,50,60,70,80,90,100' => [ '', 100, 0 ],
    'ASC_Pos_Cmd'                      => [ '', 'position', 'pct' ],
    'ASC_Direction'                    => 178,
    'ASC_Time_Up_Early'                => '04:30',
    'ASC_Time_Up_Late'                 => '09:00',
    'ASC_Time_Up_WE_Holiday'           => '08:30',
    'ASC_Time_Down_Early'              => '15:30',
    'ASC_Time_Down_Late'               => '22:30',
    'ASC_Rand_Minutes'                 => 20,
    'ASC_WindowRec'                    => 'none',
    'ASC_Ventilate_Window_Open:on,off' => 'on',
    'ASC_lock-out:soft,hard'           => 'soft',
    'ASC_lock-outCmd:inhibit,blocked'  => 'none',
    'ASC_Shading_Pos:10,20,30,40,50,60,70,80,90,100' => 30,
    'ASC_Shading:on,off,delayed,present,absent'      => 'off',
    'ASC_Shading_Pos_after_Shading:-1,0,10,20,30,40,50,60,70,80,90,100' => -1,
'ASC_Shading_Angle_Left:0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90'
      => 85,
'ASC_Shading_Angle_Right:0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90'
      => 85,
    'ASC_Shading_Brightness_Sensor'                    => 'none',
    'ASC_Shading_Brightness_Reading'                   => 'brightness',
    'ASC_Shading_StateChange_Sunny'                    => '6000',
    'ASC_Shading_StateChange_Cloudy'                   => '4000',
    'ASC_Shading_WaitingPeriod'                        => 20,
    'ASC_Shading_Min_Elevation'                        => 'none',
    'ASC_Shading_Min_OutsideTemperature'               => 18,
    'ASC_Shading_BlockingTime_After_Manual'            => 20,
    'ASC_Shading_BlockingTime_Twilight'                => 45,
    'ASC_Shading_Fast_Open:on,off'                     => 'none',
    'ASC_Shading_Fast_Close:on,off'                    => 'none',
    'ASC_Offset_Minutes_Morning'                       => 1,
    'ASC_Offset_Minutes_Evening'                       => 1,
    'ASC_WindowRec_subType:twostate,threestate'        => 'twostate',
    'ASC_Ventilate_Pos:10,20,30,40,50,60,70,80,90,100' => [ '', 70, 30 ],
    'ASC_Pos_after_ComfortOpen:0,10,20,30,40,50,60,70,80,90,100' =>
      [ '', 20, 80 ],
    'ASC_GuestRoom:on,off'            => 'none',
    'ASC_Antifreeze:off,on'           => 'off',
    'ASC_Partymode:on,off'            => 'off',
    'ASC_Roommate_Device'             => 'none',
    'ASC_Roommate_Reading'            => 'state',
    'ASC_Self_Defense_Exclude:on,off' => 'off',
    'ASC_BrightnessMinVal'            => -1,
    'ASC_BrightnessMaxVal'            => -1,
);

my $shutters = new ASC_Shutters();
my $ascDev   = new ASC_Dev();

sub Define($$) {
    my ( $hash, $def ) = @_;
    my @a = split( "[ \t][ \t]*", $def );

    return "only one AutoShuttersControl instance allowed"
      if ( devspec2array('TYPE=AutoShuttersControl') > 1 )
      ; # es wird geprüft ob bereits eine Instanz unseres Modules existiert,wenn ja wird abgebrochen
    return "too few parameters: define <name> ShuttersControl" if ( @a != 2 );
    return
"Cannot define ShuttersControl device. Perl modul ${missingModul}is missing."
      if ($missingModul)
      ; # Abbruch wenn benötigte Hilfsmodule nicht vorhanden sind / vorerst unwichtig

    my $name = $a[0];

    $hash->{VERSION} = $version;
    $hash->{MID}     = 'da39a3ee5e6b4b0d3255bfef95601890afd80709'
      ; # eine Ein Eindeutige ID für interne FHEM Belange / nicht weiter wichtig
    $hash->{NotifyOrderPrefix} = "51-";      # Order Nummer für NotifyFn
    $hash->{NOTIFYDEV}         = "global,"
      . $name;    # Liste aller Devices auf deren Events gehört werden sollen
    $ascDev->setName($name);

    readingsSingleUpdate(
        $hash,
        "state",
"please set attribut 'ACS' with value 1 or 2 to all your auto controlled shutters and then do 'set DEVICENAME scanForShutters",
        1
    );
    CommandAttr( undef, $name . ' room ASC' )
      if ( AttrVal( $name, 'room', 'none' ) eq 'none' );
    CommandAttr( undef, $name . ' icon fts_shutter_automatic' )
      if ( AttrVal( $name, 'icon', 'none' ) eq 'none' );
    CommandAttr( undef, $name . ' ASC_autoAstroModeEvening REAL' )
      if ( $ascDev->getAutoAstroModeEvening eq 'none' );
    CommandAttr( undef, $name . ' ASC_autoAstroModeMorning REAL' )
      if ( $ascDev->getAutoAstroModeMorning eq 'none' );
    CommandAttr( undef, $name . ' ASC_autoShuttersControlMorning on' )
      if ( $ascDev->getAutoShuttersControlMorning eq 'none' );
    CommandAttr( undef, $name . ' ASC_autoShuttersControlEvening on' )
      if ( $ascDev->getAutoShuttersControlEvening eq 'none' );
    CommandAttr( undef, $name . ' ASC_temperatureReading temperature' )
      if ( $ascDev->getTempReading eq 'none' );
    CommandAttr( undef, $name . ' ASC_antifreezeTemp 3' )
      if ( $ascDev->getAntifreezeTemp eq 'none' );

    addToAttrList('ASC:0,1,2');

    Log3( $name, 3, "AutoShuttersControl ($name) - defined" );

    $modules{AutoShuttersControl}{defptr}{ $hash->{MID} } = $hash;

    return undef;
}

sub Undef($$) {
    my ( $hash, $arg ) = @_;

    my $name = $hash->{NAME};

    UserAttributs_Readings_ForShutters( $hash, 'del' )
      ; # es sollen alle Attribute und Readings in den Rolläden Devices gelöscht werden welche vom Modul angelegt wurden
    delFromAttrList('ASC:0,1,2');

    delete( $modules{AutoShuttersControl}{defptr}{ $hash->{MID} } );

    Log3( $name, 3, "AutoShuttersControl ($name) - delete device $name" );
    return undef;
}

sub Attr(@) {
    my ( $cmd, $name, $attrName, $attrVal ) = @_;
    my $hash = $defs{$name};

    if ( $attrName eq "disable" ) {
        if ( $cmd eq "set" and $attrVal eq "1" ) {

            #RemoveInternalTimer($hash);

            #readingsSingleUpdate ($hash,"state","disabled",1);
            Log3( $name, 3, "AutoShuttersControl ($name) - disabled" );
        }
        elsif ( $cmd eq "del" ) {
            Log3( $name, 3, "AutoShuttersControl ($name) - enabled" );
        }
    }
    elsif ( $attrName eq "disabledForIntervals" ) {
        if ( $cmd eq "set" ) {
            return
"check disabledForIntervals Syntax HH:MM-HH:MM or 'HH:MM-HH:MM HH:MM-HH:MM ...'"
              unless ( $attrVal =~ /^((\d{2}:\d{2})-(\d{2}:\d{2})\s?)+$/ );
            Log3( $name, 3,
                "AutoShuttersControl ($name) - disabledForIntervals" );

            #readingsSingleUpdate ($hash,"state","disabled",1);
        }
        elsif ( $cmd eq "del" ) {
            Log3( $name, 3, "AutoShuttersControl ($name) - enabled" );

            #readingsSingleUpdate ($hash,"state","active",1);
        }
    }
    return undef;
}

sub Notify($$) {
    my ( $hash, $dev ) = @_;
    my $name = $hash->{NAME};
    $ascDev->setName($name);
    return if ( IsDisabled($name) );

    my $devname = $dev->{NAME};
    my $devtype = $dev->{TYPE};
    my $events  = deviceEvents( $dev, 1 );
    return if ( !$events );

    Log3( $name, 5,
            "AutoShuttersControl ($name) - Devname: "
          . $devname
          . " Name: "
          . $name
          . " Notify: "
          . Dumper $events);    # mit Dumper

    if (
        (
            grep /^DEFINED.$name$/,
            @{$events} and $devname eq 'global' and $init_done
        )
        or (
            grep /^INITIALIZED$/,
            @{$events} or grep /^REREADCFG$/,
            @{$events} or grep /^MODIFIED.$name$/,
            @{$events}
        )
        and $devname eq 'global'
      )
    {
        readingsSingleUpdate( $hash, 'partyMode', 'off', 0 )
          if ( $ascDev->getPartyModeStatus eq 'none' );
        readingsSingleUpdate( $hash, 'lockOut', 'off', 0 )
          if ( $ascDev->getLockOut eq 'none' );
        readingsSingleUpdate( $hash, 'sunriseTimeWeHoliday', 'off', 0 )
          if ( $ascDev->getSunriseTimeWeHoliday eq 'none' );
        readingsSingleUpdate( $hash, 'selfDefense', 'off', 0 )
          if ( $ascDev->getSelfDefense eq 'none' );
        CommandDeleteReading( undef, $name . ' selfDefence' )
          if ( ReadingsVal( $name, 'selfDefence', 'none' ) ne 'none' )
          ;    # temporär kann später entfernt werden.

# Ist der Event ein globaler und passt zum Rest der Abfrage oben wird nach neuen Rolläden Devices gescannt und eine Liste im Rolladenmodul sortiert nach Raum generiert
        ShuttersDeviceScan($hash)
          unless ( ReadingsVal( $name, 'userAttrList', 'none' ) eq 'none' );
    }
    return
      unless ( ref( $hash->{helper}{shuttersList} ) eq 'ARRAY'
        and scalar( @{ $hash->{helper}{shuttersList} } ) > 0 );

    if ( $devname eq $name ) {
        if ( grep /^userAttrList:.rolled.out$/, @{$events} ) {
            unless ( scalar( @{ $hash->{helper}{shuttersList} } ) == 0 ) {
                WriteReadingsShuttersList($hash);
                UserAttributs_Readings_ForShutters( $hash, 'add' );
                InternalTimer( gettimeofday() + 3,
                    'AutoShuttersControl::RenewSunRiseSetShuttersTimer',
                    $hash );
            }
        }
        elsif ( grep /^partyMode:.off$/, @{$events} ) {
            PartyModeEventProcessing($hash);
        }
        elsif ( grep /^sunriseTimeWeHoliday:.(on|off)$/, @{$events} ) {
            RenewSunRiseSetShuttersTimer($hash);
        }
    }
    elsif ( $devname eq "global" )
    { # Kommt ein globales Event und beinhaltet folgende Syntax wird die Funktion zur Verarbeitung aufgerufen
        if (
            grep
/^(ATTR|DELETEATTR)\s(.*ASC_Roommate_Device|.*ASC_WindowRec|.*ASC_residentsDevice|.*ASC_Shading_Brightness_Sensor)(\s.*|$)/,
            @{$events}
          )
        {
            GeneralEventProcessing( $hash, undef, join( ' ', @{$events} ) );
        }
        elsif ( grep /^(ATTR|DELETEATTR)\s(.*ASC_Time_Up_WE_Holiday)(\s.*|$)/,
            @{$events} )
        {
            RenewSunRiseSetShuttersTimer($hash)
              unless ( $ascDev->getSunriseTimeWeHoliday eq 'off' );
        }
    }
    else {
        GeneralEventProcessing( $hash, $devname, join( ' ', @{$events} ) )
          ; # bei allen anderen Events wird die entsprechende Funktion zur Verarbeitung aufgerufen
    }
    return;
}

sub GeneralEventProcessing($$$) {
    my ( $hash, $devname, $events ) = @_;
    my $name = $hash->{NAME};

    if ( defined($devname) and ($devname) )
    { # es wird lediglich der Devicename der Funktion mitgegeben wenn es sich nicht um global handelt daher hier die Unterschiedung
        while ( my ( $device, $deviceAttr ) =
            each %{ $hash->{monitoredDevs}{$devname} } )
        {
            WindowRecEventProcessing( $hash, $device, $events )
              if ( $deviceAttr eq 'ASC_WindowRec' )
              ;    # ist es ein Fensterdevice wird die Funktion gestartet
            RoommateEventProcessing( $hash, $device, $events )
              if ( $deviceAttr eq 'ASC_Roommate_Device' )
              ;    # ist es ein Bewohner Device wird diese Funktion gestartet
            ResidentsEventProcessing( $hash, $device, $events )
              if ( $deviceAttr eq 'ASC_residentsDevice' );

            $shutters->setShuttersDev($device)
              if ( $deviceAttr eq 'ASC_Shading_Brightness_Sensor' );
            BrightnessEventProcessing( $hash, $device, $events )
              if (
                $deviceAttr eq 'ASC_Shading_Brightness_Sensor'
                and (  $shutters->getDownMode eq 'brightness'
                    or $shutters->getUpMode eq 'brightness' )
              );
        }
    }
    else {    # alles was kein Devicenamen mit übergeben hat landet hier
        if ( $events =~
m#^ATTR\s(.*)\s(ASC_Roommate_Device|ASC_WindowRec|ASC_residentsDevice|ASC_Shading_Brightness_Sensor)\s(.*)$#
          )
        {     # wurde den Attributen unserer Rolläden ein Wert zugewiesen ?
            AddNotifyDev( $hash, $3, $1, $2 );
            Log3( $name, 4,
                "AutoShuttersControl ($name) - EventProcessing: ATTR" );
        }
        elsif ( $events =~
m#^DELETEATTR\s(.*)\s(ASC_Roommate_Device|ASC_WindowRec|ASC_residentsDevice)$#
          )
        {     # wurde das Attribut unserer Rolläden gelöscht ?
            Log3( $name, 4,
                "AutoShuttersControl ($name) - EventProcessing: DELETEATTR" );
            DeleteNotifyDev( $hash, $1, $2 );
        }
    }
}

sub Set($$@) {
    my ( $hash, $name, @aa ) = @_;
    my ( $cmd, @args ) = @aa;

    if ( lc $cmd eq 'renewsetsunrisesunsettimer' ) {
        return "usage: $cmd" if ( @args != 0 );
        RenewSunRiseSetShuttersTimer($hash);
    }
    elsif ( lc $cmd eq 'scanforshutters' ) {
        return "usage: $cmd" if ( @args != 0 );
        ShuttersDeviceScan($hash);
    }
    elsif ( lc $cmd eq 'createnewnotifydev' ) {
        return "usage: $cmd" if ( @args != 0 );
        CreateNewNotifyDev($hash);
    }
    elsif ( lc $cmd eq 'partymode' ) {
        return "usage: $cmd" if ( @args > 1 );
        readingsSingleUpdate( $hash, $cmd, join( ' ', @args ), 1 );
    }
    elsif ( lc $cmd eq 'lockout' ) {
        return "usage: $cmd" if ( @args > 1 );
        readingsSingleUpdate( $hash, $cmd, join( ' ', @args ), 1 );
        SetHardewareBlockForShutters( $hash, join( ' ', @args ) );
    }
    elsif ( lc $cmd eq 'sunrisetimeweholiday' ) {
        return "usage: $cmd" if ( @args > 1 );
        readingsSingleUpdate( $hash, $cmd, join( ' ', @args ), 1 );
    }
    elsif ( lc $cmd eq 'selfdefense' ) {
        return "usage: $cmd" if ( @args > 1 );
        readingsSingleUpdate( $hash, $cmd, join( ' ', @args ), 1 );
    }
    else {
        my $list = "scanForShutters:noArg";
        $list .=
" renewSetSunriseSunsetTimer:noArg partyMode:on,off lockOut:on,off sunriseTimeWeHoliday:on,off selfDefense:on,off createNewNotifyDev:noArg"
          if ( ReadingsVal( $name, 'userAttrList', 0 ) eq 'rolled out' );

        return "Unknown argument $cmd,choose one of $list";
    }
    return undef;
}

sub Get($$@) {
    my ( $hash, $name, @aa ) = @_;

    my ( $cmd, @args ) = @aa;

    if ( lc $cmd eq 'showshuttersinformations' ) {
        return "usage: $cmd" if ( @args != 0 );
        my $ret = GetShuttersInformation($hash);
        return $ret;
    }
    elsif ( lc $cmd eq 'shownotifydevsinformations' ) {
        return "usage: $cmd" if ( @args != 0 );
        my $ret = GetMonitoredDevs($hash);
        return $ret;
    }
    elsif ( lc $cmd eq 'test' ) {
        return "usage: $cmd" if ( @args != 0 );
        $shutters->setShuttersDev('RolloKinZimSteven_F1');
        my $ret =
          'LastPos: ' . $shutters->getLastPos
          . ' InTimerFuncHash: ' . $shutters->getInTimerFuncHash
          . ' Sunrise: ' . $shutters->getInTimerFuncHash->{sunrisetime}
          . ' LastPosTimestamp: ' . $shutters->getLastPosTimestamp;
        return $ret;
    }
    else {
        my $list = "";
        $list .=
" showShuttersInformations:noArg showNotifyDevsInformations:noArg test:noArg"
          if ( ReadingsVal( $name, 'userAttrList', 'none' ) eq 'rolled out' );
        return "Unknown argument $cmd,choose one of $list";
    }
}

sub ShuttersDeviceScan($) {
    my $hash = shift;
    my $name = $hash->{NAME};
    $ascDev->setName($name);

    delete $hash->{helper}{shuttersList};

    my @list;
    @list = devspec2array('ASC=[1-2]');

    CommandDeleteReading( undef, $name . ' .*_nextAstroTimeEvent' );
    CommandDeleteReading( undef, $name . ' .*_lastDelayPosValue' );
    CommandDeleteReading( undef, $name . ' .*_lastPosValue' );

    unless ( scalar(@list) > 0 ) {
        readingsBeginUpdate($hash);
        readingsBulkUpdate( $hash, 'userAttrList', 'none' );
        readingsBulkUpdate( $hash, 'state',        'no shutters found' );
        readingsEndUpdate( $hash, 1 );
        return;
    }
    foreach (@list) {
        push( @{ $hash->{helper}{shuttersList} }, $_ )
          ; ## einem Hash wird ein Array zugewiesen welches die Liste der erkannten Rollos beinhaltet
            #AddNotifyDev($hash,$_);        # Vorerst keine Shutters in NOTIFYDEV
        delFromDevAttrList( $_, 'ASC_Up:time,astro' )
          ;    # temporär muss später gelöscht werden ab Version 0.1.80
        delFromDevAttrList( $_, 'ASC_Down:time,astro' )
          ;    # temporär muss später gelöscht werden ab Version 0.1.80
        delFromDevAttrList( $_, 'ASC_Self_Defence_Exclude:on,off' )
          ;    # temporär muss später gelöscht werden ab Version 0.1.80
        CommandDeleteReading( undef,
            $_ . ' .AutoShuttersControl_InternalTimerFuncHash' )
          ;    # temporär muss später gelöscht werden ab Version 0.1.81
        CommandDeleteReading( undef,
            $_ . ' .AutoShuttersControl_LastPosition' )
          ;    # temporär muss später gelöscht werden ab Version 0.1.81
    }
    if ( $ascDev->getMonitoredDevs ne 'none' ) {
        $hash->{monitoredDevs} =
          eval { decode_json( $ascDev->getMonitoredDevs ) };
        my $notifyDevString = $hash->{NOTIFYDEV};
        while ( each %{ $hash->{monitoredDevs} } ) {
            $notifyDevString .= ',' . $_;
        }
        $hash->{NOTIFYDEV} = $notifyDevString;
    }
    readingsSingleUpdate( $hash, 'userAttrList', 'rolled out', 1 );
}

## Die Funktion schreibt in das Moduldevice Readings welche Rolläden in welchen Räumen erfasst wurden.
sub WriteReadingsShuttersList($) {
    my $hash = shift;
    my $name = $hash->{NAME};

    CommandDeleteReading( undef, $name . ' room_.*' );

    readingsBeginUpdate($hash);
    foreach ( @{ $hash->{helper}{shuttersList} } ) {
        readingsBulkUpdate(
            $hash,
            'room_' . makeReadingName( AttrVal( $_, 'room', 'unsorted' ) ),
            ReadingsVal(
                $name,
                'room_' . makeReadingName( AttrVal( $_, 'room', 'unsorted' ) ),
                ''
              )
              . ','
              . $_
          )
          if (
            ReadingsVal(
                $name,
                'room_' . makeReadingName( AttrVal( $_, 'room', 'unsorted' ) ),
                'none'
            ) ne 'none'
          );

        readingsBulkUpdate( $hash,
            'room_' . makeReadingName( AttrVal( $_, 'room', 'unsorted' ) ), $_ )
          if (
            ReadingsVal(
                $name,
                'room_' . makeReadingName( AttrVal( $_, 'room', 'unsorted' ) ),
                'none'
            ) eq 'none'
          );
    }
    readingsBulkUpdate( $hash, 'state', 'active' );
    readingsEndUpdate( $hash, 0 );
}

sub UserAttributs_Readings_ForShutters($$) {
    my ( $hash, $cmd ) = @_;
    my $name = $hash->{NAME};

    while ( my ( $attrib, $attribValue ) = each %{userAttrList} ) {
        foreach ( @{ $hash->{helper}{shuttersList} } ) {
            addToDevAttrList( $_, $attrib )
              ; ## fhem.pl bietet eine Funktion um ein userAttr Attribut zu befüllen. Wir schreiben also in den Attribut userAttr alle unsere Attribute rein. Pro Rolladen immer ein Attribut pro Durchlauf
            ## Danach werden die Attribute die im userAttr stehen gesetzt und mit default Werten befüllt
            if ( $cmd eq 'add' ) {
                if ( ref($attribValue) ne 'ARRAY' ) {
                    $attr{$_}{ ( split( ':', $attrib ) )[0] } = $attribValue
                      if (
                        not
                        defined( $attr{$_}{ ( split( ':', $attrib ) )[0] } ) );
                }
                else {
                    $attr{$_}{ ( split( ':', $attrib ) )[0] } =
                      $attribValue->[ AttrVal( $_, 'ASC', 2 ) ]
                      if (
                        not
                        defined( $attr{$_}{ ( split( ':', $attrib ) )[0] } ) );
                }
                ## Oder das Attribut wird wieder gelöscht.
            }
            elsif ( $cmd eq 'del' ) {
                $shutters->setShuttersDev($_);

                RemoveInternalTimer( $shutters->getInTimerFuncHash );
                CommandDeleteReading( undef,
                    $_ . ' .?(AutoShuttersControl|ASC)_.*' );
                CommandDeleteAttr( undef, $_ . ' ASC' );
                delFromDevAttrList( $_, $attrib );
            }
        }
    }
}

## Fügt dem NOTIFYDEV Hash weitere Devices hinzu
sub AddNotifyDev($@) {
    my ( $hash, $dev, $shuttersDev, $shuttersAttr ) = @_;
    my $name = $hash->{NAME};

    my $notifyDev = $hash->{NOTIFYDEV};
    $notifyDev = "" if ( !$notifyDev );
    my %hash;

    %hash = map { ( $_ => 1 ) }
      split( ",", "$notifyDev,$dev" );

    $hash->{NOTIFYDEV} = join( ",", sort keys %hash );

    my @devs = split( ',', $dev );
    foreach (@devs) {
        $hash->{monitoredDevs}{$_}{$shuttersDev} = $shuttersAttr;
    }

    readingsSingleUpdate( $hash, '.monitoredDevs',
        eval { encode_json( $hash->{monitoredDevs} ) }, 0 );
}

## entfernt aus dem NOTIFYDEV Hash Devices welche als Wert in Attributen steckten
sub DeleteNotifyDev($@) {
    my ( $hash, $shuttersDev, $shuttersAttr ) = @_;
    my $name = $hash->{NAME};

    my $notifyDevs =
      ExtractNotifyDevFromEvent( $hash, $shuttersDev, $shuttersAttr );

    foreach my $notifyDev ( keys( %{$notifyDevs} ) ) {
        Log3( $name, 4,
            "AutoShuttersControl ($name) - DeleteNotifyDev - NotifyDev: "
              . $_ );
        delete $hash->{monitoredDevs}{$notifyDev}{$shuttersDev};

        if ( !keys %{ $hash->{monitoredDevs}{$notifyDev} } ) {
            delete $hash->{monitoredDevs}{$notifyDev};
            my $notifyDevString = $hash->{NOTIFYDEV};
            $notifyDevString = "" if ( !$notifyDevString );
            my %hash;
            %hash = map { ( $_ => 1 ) }
              grep { " $notifyDev " !~ m/ $_ / }
              split( ",", "$notifyDevString,$notifyDev" );

            $hash->{NOTIFYDEV} = join( ",", sort keys %hash );
        }
    }
    readingsSingleUpdate( $hash, '.monitoredDevs',
        eval { encode_json( $hash->{monitoredDevs} ) }, 0 );
}

## Sub zum steuern der Rolläden bei einem Fenster Event
sub WindowRecEventProcessing($@) {
    my ( $hash, $shuttersDev, $events ) = @_;
    my $name = $hash->{NAME};
    $ascDev->setName($name);

    if ( $events =~ m#state:\s(open|closed|tilted)# ) {
        $shutters->setShuttersDev($shuttersDev);
        my $queryShuttersPosWinRecTilted = (
            ShuttersPosCmdValueNegieren($shuttersDev)
            ? $shutters->getStatus > $shutters->getVentilatePos
            : $shutters->getStatus < $shutters->getVentilatePos
        );

        if ( $shutters->getDelayCmd ne 'none' )
        { # Es wird geschaut ob wärend der Fenster offen Phase ein Fahrbefehl über das Modul kam,wenn ja wird dieser aus geführt
            if ( $1 eq 'closed' ) {
                ShuttersCommandSet( $hash, $shuttersDev,
                    $shutters->getClosedPos );
            }
            elsif (
                (
                    $1 eq 'tilted'
                    or ( $1 eq 'open' and $shutters->getSubTyp eq 'twostate' )
                )
                and $shutters->getVentilateOpen eq 'on'
                and $queryShuttersPosWinRecTilted
              )
            {
                ShuttersCommandSet( $hash, $shuttersDev,
                    $shutters->getVentilatePos );
            }
        }
        elsif ( $1 eq 'closed'
          ) # wenn nicht dann wird entsprechend dem Fensterkontakt Event der Rolladen geschlossen oder zum lüften geöffnet
        {
            ShuttersCommandSet( $hash, $shuttersDev, $shutters->getClosedPos )
              if ( $shutters->getStatus == $shutters->getVentilatePos
                or $shutters->getStatus == $shutters->getPosAfterComfortOpen );
        }
        elsif (
            (
                $1 eq 'tilted'
                or ( $1 eq 'open' and $shutters->getSubTyp eq 'twostate' )
            )
            and $shutters->getVentilateOpen eq 'on'
            and $queryShuttersPosWinRecTilted
          )
        {
            ShuttersCommandSet( $hash, $shuttersDev,
                $shutters->getVentilatePos );
        }
        elsif ( $1 eq 'open'
            and $shutters->getSubTyp eq 'threestate'
            and $ascDev->getAutoShuttersControlComfort eq 'on'
            and $queryShuttersPosWinRecTilted )
        {
            ShuttersCommandSet( $hash, $shuttersDev,
                $shutters->getPosAfterComfortOpen );
        }
    }
}

## Sub zum steuern der Rolladen bei einem Bewohner/Roommate Event
sub RoommateEventProcessing($@) {
    my ( $hash, $shuttersDev, $events ) = @_;
    my $name = $hash->{NAME};
    $ascDev->setName($name);
    $shutters->setShuttersDev($shuttersDev);
    my $reading = $shutters->getRoommatesReading;

    if ( $events =~ m#$reading:\s(gotosleep|asleep|awoken|home)# ) {
        Log3( $name, 4,
"AutoShuttersControl ($name) - RoommateEventProcessing: $shutters->getRoommatesReading"
        );
        Log3( $name, 4,
"AutoShuttersControl ($name) - RoommateEventProcessing: $shuttersDev und Events $events"
        );

        ShuttersCommandSet( $hash, $shuttersDev, $shutters->getOpenPos )
          if (
            ( $1 eq 'home' or $1 eq 'awoken' )
            and (  $shutters->getRoommatesLastStatus eq 'asleep'
                or $shutters->getRoommatesLastStatus eq 'awoken' )
            and (  $shutters->getRoommatesStatus eq 'home'
                or $shutters->getRoommatesStatus eq 'awoken' )
            and $ascDev->getAutoShuttersControlMorning eq 'on'
            and IsDay( $hash, $shuttersDev )
            and $shutters->getModeUp eq 'always'
          );

        if (    $shutters->getModeDown eq 'always'
            and ( $1 eq 'gotosleep' or $1 eq 'asleep' )
            and $ascDev->getAutoShuttersControlEvening eq 'on' )
        {
            my $position;
            if ( CheckIfShuttersWindowRecOpen($shuttersDev) == 0
                or $shutters->getVentilateOpen eq 'off' )
            {
                $position = $shutters->getClosedPos;
            }
            else { $position = $shutters->getVentilatePos; }

            ShuttersCommandSet( $hash, $shuttersDev, $position );
        }
    }
}

sub ResidentsEventProcessing($@) {
    my ( $hash, $device, $events ) = @_;

    my $name = $device;
    $ascDev->setName($name);
    my $reading = $ascDev->getResidentsReading;

    if ( $events =~ m#$reading:\s(absent)# and $ascDev->getSelfDefense eq 'on' )
    {
        foreach my $shuttersDev ( @{ $hash->{helper}{shuttersList} } ) {
            $shutters->setShuttersDev($shuttersDev);
            $shutters->setLastPos( $shutters->getStatus );

            $shutters->setDriveCmd( $shutters->getClosedPos )
              if ( CheckIfShuttersWindowRecOpen($shuttersDev) != 0
                and $shutters->getSelfDefenseExclude eq 'off' );
        }
    }
    elsif ( $events =~ m#$reading:\s(home)#
        and $ascDev->getSelfDefense eq 'on'
        and $ascDev->getResidentsLastStatus eq 'absent'
        or $ascDev->getResidentsLastStatus eq 'gone' )
    {
        foreach my $shuttersDev ( @{ $hash->{helper}{shuttersList} } ) {
            $shutters->setDriveCmd( $shutters->getLastPos )
              if ( CheckIfShuttersWindowRecOpen($shuttersDev) != 0
                and $shutters->getSelfDefenseExclude eq 'off' );
        }
    }
}

sub BrightnessEventProcessing($@) {
    my ( $hash, $shuttersDev, $events ) = @_;
    my $name = $hash->{NAME};
    $ascDev->setName($name);
    $shutters->setShuttersDev($shuttersDev);

    return
      unless (
        int( gettimeofday() / 86400 ) !=
        int( computeAlignTime( '24:00', $shutters->getTimeUpEarly ) / 86400 )
        and int( gettimeofday() / 86400 ) ==
        int( computeAlignTime( '24:00', $shutters->getTimeUpLate ) / 86400 )
        or int( gettimeofday() / 86400 ) !=
        int( computeAlignTime( '24:00', $shutters->getTimeDownEarly ) / 86400 )
        and int( gettimeofday() / 86400 ) ==
        int( computeAlignTime( '24:00', $shutters->getTimeDownLate ) / 86400 )
      );

    my $reading = $shutters->getShadingBrightnessReading;
    if ( $events =~ m#$reading:\s(\d+)# ) {
        my $brightnessMinVal;
        if ( $shutters->getBrightnessMinVal > -1 ) {
            $brightnessMinVal = $shutters->getBrightnessMinVal;
        }
        else {
            $brightnessMinVal = $ascDev->getBrightnessMinVal;
        }

        if (
            int( gettimeofday() / 86400 ) != int(
                computeAlignTime( '24:00', $shutters->getTimeUpEarly ) / 86400
            )
            and int( gettimeofday() / 86400 ) == int(
                computeAlignTime( '24:00', $shutters->getTimeUpLate ) / 86400
            )
            and $1 > $brightnessMinVal
          )
        {
            Log3( $name, 4,
"AutoShuttersControl ($shuttersDev) - BrightnessEventProcessing: Steuerung für Morgens"
            );
            ShuttersCommandSet( $hash, $shuttersDev, $shutters->getOpenPos );
        }
        elsif (
            int( gettimeofday() / 86400 ) != int(
                computeAlignTime( '24:00', $shutters->getTimeDownEarly ) / 86400
            )
            and int( gettimeofday() / 86400 ) == int(
                computeAlignTime( '24:00', $shutters->getTimeDownLate ) / 86400
            )
            and $1 < $brightnessMinVal
          )
        {
            Log3( $name, 4,
"AutoShuttersControl ($shuttersDev) - BrightnessEventProcessing: Steuerung für Abends"
            );
            ShuttersCommandSet( $hash, $shuttersDev, $shutters->getClosedPos );
        }
    }
}

sub PartyModeEventProcessing($) {
    my ($hash) = @_;
    my $name = $hash->{NAME};

    foreach my $shuttersDev ( @{ $hash->{helper}{shuttersList} } ) {
        $shutters->setShuttersDev($shuttersDev);
        if ( CheckIfShuttersWindowRecOpen($shuttersDev) == 2
            and $shutters->getSubTyp eq 'threestate' )
        {
            Log3( $name, 4,
"AutoShuttersControl ($name) - PartyModeEventProcessing Fenster offen"
            );
            $shutters->setDelayDriveCmd( $shutters->getClosedPos );
            Log3( $name, 4,
"AutoShuttersControl ($name) - PartyModeEventProcessing - Spring in ShuttersCommandDelaySet"
            );
        }
        else {
            Log3( $name, 4,
"AutoShuttersControl ($name) - PartyModeEventProcessing Fenster nicht offen"
            );
            ShuttersCommandSet(
                $hash,
                $shuttersDev,
                (
                    CheckIfShuttersWindowRecOpen($shuttersDev) == 0
                    ? $shutters->getClosedPos
                    : $shutters->getVentilatePos
                )
            );
        }
    }
}

# Sub für das Zusammensetzen der Rolläden Steuerbefehle
sub ShuttersCommandSet($$$) {
    my ( $hash, $shuttersDev, $posValue ) = @_;
    my $name = $hash->{NAME};
    $ascDev->setName($name);

    $shutters->setShuttersDev($shuttersDev);
    readingsBeginUpdate($hash);

    if (
        ( $shutters->getPartyMode eq 'on' and $ascDev->getPartyMode eq 'on' )
        or (    CheckIfShuttersWindowRecOpen($shuttersDev) == 2
            and $shutters->getSubTyp eq 'threestate'
            and $ascDev->getAutoShuttersControlComfort eq 'off'
            and $shutters->getVentilateOpen eq 'on' )
        or (
            CheckIfShuttersWindowRecOpen($shuttersDev) == 2
            and (  $shutters->getLockOut eq 'soft'
                or $shutters->getLockOut eq 'hard' )
            and $ascDev->getLockOut eq 'on'
        )
        or (    $shutters->getAntiFreeze eq 'on'
            and $ascDev->getOutTemp <= $ascDev->getAntifreezeTemp )
      )
    {
        $shutters->setDelayDriveCmd($posValue);
        readingsBulkUpdateIfChanged( $hash,
            $shuttersDev . '_lastDelayPosValue', $posValue );
    }
    else {
        $shutters->setDriveCmd($posValue);
        readingsSingleUpdate( $defs{$shuttersDev},
            '.AutoShuttersControl_DelayCmd',
            'none', 0 )
          if ( $shutters->getDelayCmd ne 'none' )
          ; # setzt den Wert des Readings auf none da der Rolladen nun gesteuert werden kann. Dieses Reading setzt die Delay Funktion ShuttersCommandDelaySet
        readingsBulkUpdateIfChanged( $hash, $shuttersDev . '_lastPosValue',
            $posValue );
    }
    readingsEndUpdate( $hash, 1 );
}

## Sub welche die InternalTimer nach entsprechenden Sunset oder Sunrise zusammen stellt
sub CreateSunRiseSetShuttersTimer($$) {
    my ( $hash, $shuttersDev ) = @_;
    my $name            = $hash->{NAME};
    my $shuttersDevHash = $defs{$shuttersDev};
    $shutters->setShuttersDev($shuttersDev);
    $ascDev->setName($name);
    return if ( IsDisabled($name) );

    my $shuttersSunriseUnixtime =
      ShuttersSunrise( $hash, $shuttersDev, 'unix' ) +
      int( rand( TimeMin2Sec( $shutters->getOffsetMorning ) ) );
    my $shuttersSunsetUnixtime = ShuttersSunset( $hash, $shuttersDev, 'unix' ) +
      int( rand( TimeMin2Sec( $shutters->getOffsetEvening ) ) );

    ## In jedem Rolladen werden die errechneten Zeiten hinterlegt,es sei denn das autoShuttersControlEvening/Morning auf off steht
    readingsBeginUpdate($shuttersDevHash);
    readingsBulkUpdate(
        $shuttersDevHash,
        'ASC_Time_DriveDown',
        (
            $ascDev->getAutoShuttersControlEvening eq 'on'
            ? strftime(
                "%e.%m.%Y - %H:%M", localtime($shuttersSunsetUnixtime)
              )
            : 'AutoShuttersControl off'
        ),
        1
    );
    readingsBulkUpdate(
        $shuttersDevHash,
        'ASC_Time_DriveUp',
        (
            $ascDev->getAutoShuttersControlMorning eq 'on'
            ? strftime( "%e.%m.%Y - %H:%M",
                localtime($shuttersSunriseUnixtime) )
            : 'AutoShuttersControl off'
        ),
        1
    );
    readingsEndUpdate( $shuttersDevHash, 0 );

    readingsBeginUpdate($hash);
    readingsBulkUpdateIfChanged(
        $hash,
        $shuttersDev . '_nextAstroTimeEvent',
        (
            $shuttersSunriseUnixtime < $shuttersSunsetUnixtime
            ? strftime( "%e.%m.%Y - %H:%M",
                localtime($shuttersSunriseUnixtime) )
            : strftime(
                "%e.%m.%Y - %H:%M", localtime($shuttersSunsetUnixtime)
            )
        )
    );
    readingsEndUpdate( $hash, 1 );

    CommandDeleteReading( undef,
        $name . ' ' . $shuttersDev . '_nextAstroEvent' )
      if ( ReadingsVal( $name, $shuttersDev . '_nextAstroEvent', 'none' ) ne
        'none' );    # temporär
    CommandDeleteReading( undef,
        $shuttersDev . ' AutoShuttersControl_Time_Sunrise' )
      if (
        ReadingsVal( $shuttersDev, 'AutoShuttersControl_Time_Sunrise', 'none' )
        ne 'none' );    # temporär
    CommandDeleteReading( undef,
        $shuttersDev . ' AutoShuttersControl_Time_Sunset' )
      if (
        ReadingsVal( $shuttersDev, 'AutoShuttersControl_Time_Sunset', 'none' )
        ne 'none' );    # temporär
    CommandDeleteReading( undef,
        $shuttersDev . ' AutoShuttersControl_Time_DriveDown' )
      if (
        ReadingsVal( $shuttersDev, 'AutoShuttersControl_Time_DriveDown',
            'none' ) ne 'none'
      );                # temporär
    CommandDeleteReading( undef,
        $shuttersDev . ' AutoShuttersControl_Time_DriveUp' )
      if (
        ReadingsVal( $shuttersDev, 'AutoShuttersControl_Time_DriveUp', 'none' )
        ne 'none' );    # temporär

    #     RemoveInternalTimer( $shutters->getInTimerFuncHash )
    #       unless ( $shutters->getInTimerFuncHash eq 'none' );

    RemoveInternalTimer( $shutters->getInTimerFuncHash )
      if ( defined( $shutters->getInTimerFuncHash ) );

    ## kleine Hilfe für InternalTimer damit ich alle benötigten Variablen an die Funktion übergeben kann welche von Internal Timer aufgerufen wird.
    my %funcHash = (
        hash           => $hash,
        shuttersdevice => $shuttersDev,
        sunsettime     => $shuttersSunsetUnixtime,
        sunrisetime    => $shuttersSunriseUnixtime
    );

    ## Ich brauche beim löschen des InternalTimer den Hash welchen ich mitgegeben habe,dieser muss gesichert werden
    $shutters->setInTimerFuncHash( \%funcHash );

    InternalTimer( $shuttersSunsetUnixtime,
        'AutoShuttersControl::SunSetShuttersAfterTimerFn', \%funcHash )
      if ( $ascDev->getAutoShuttersControlEvening eq 'on' );
    InternalTimer( $shuttersSunriseUnixtime,
        'AutoShuttersControl::SunRiseShuttersAfterTimerFn', \%funcHash )
      if ( $ascDev->getAutoShuttersControlMorning eq 'on' );
}

## Funktion zum neu setzen der Timer und der Readings für Sunset/Rise
sub RenewSunRiseSetShuttersTimer($) {
    my $hash = shift;

    foreach ( @{ $hash->{helper}{shuttersList} } ) {
        $shutters->setShuttersDev($_);

        RemoveInternalTimer( $shutters->getInTimerFuncHash );
        $shutters->setInTimerFuncHash(undef);
        CreateSunRiseSetShuttersTimer( $hash, $_ );
    }
}

## Funktion zum hardwareseitigen setzen des lock-out oder blocking beim Rolladen selbst
sub SetHardewareBlockForShutters($$) {
    my ( $hash, $cmd ) = @_;
    foreach ( @{ $hash->{helper}{shuttersList} } ) {
        if (    AttrVal( $_, 'ASC_lock-out', 'soft' ) eq 'hard'
            and AttrVal( $_, 'ASC_lock-outCmd', 'none' ) ne 'none' )
        {
            CommandSet( undef, $_ . ' inhibit ' . $cmd )
              if ( AttrVal( $_, 'ASC_lock-outCmd', 'none' ) eq 'inhibit' );
            CommandSet( undef,
                $_ . ' ' . ( $cmd eq 'on' ? 'blocked' : 'unblocked' ) )
              if ( AttrVal( $_, 'ASC_lock-outCmd', 'none' ) eq 'blocked' );
        }
    }
}

## Funktion welche beim Ablaufen des Timers für Sunset aufgerufen werden soll
sub SunSetShuttersAfterTimerFn($) {
    my $funcHash    = shift;
    my $hash        = $funcHash->{hash};
    my $shuttersDev = $funcHash->{shuttersdevice};
    $shutters->setShuttersDev($shuttersDev);

    my $posValue;
    if ( CheckIfShuttersWindowRecOpen($shuttersDev) == 0
        or $shutters->getVentilateOpen eq 'off' )
    {
        $posValue = $shutters->getClosedPos;
    }
    else { $posValue = $shutters->getVentilatePos; }
    ShuttersCommandSet( $hash, $shuttersDev, $posValue )
      if ( $shutters->getModeDown eq $shutters->getRoommatesStatus
        or $shutters->getModeDown eq 'always' );

    CreateSunRiseSetShuttersTimer( $hash, $shuttersDev );
}

## Funktion welche beim Ablaufen des Timers für Sunrise aufgerufen werden soll
sub SunRiseShuttersAfterTimerFn($) {
    my $funcHash    = shift;
    my $hash        = $funcHash->{hash};
    my $shuttersDev = $funcHash->{shuttersdevice};
    $shutters->setShuttersDev($shuttersDev);
    $ascDev->setName( $hash->{NAME} );

    if (   $shutters->getModeUp eq $shutters->getRoommatesStatus
        or $shutters->getModeUp eq 'always' )
    {
        ShuttersCommandSet( $hash, $shuttersDev, $shutters->getOpenPos )
          if (
            (
                   $shutters->getRoommatesStatus eq 'home'
                or $shutters->getRoommatesStatus eq 'awoken'
                or $shutters->getRoommatesStatus eq 'absent'
                or $shutters->getRoommatesStatus eq 'gone'
            )
            and $ascDev->getSelfDefense eq 'off'
            or ( $ascDev->getSelfDefense eq 'on'
                and CheckIfShuttersWindowRecOpen($shuttersDev) == 0 )
          );
    }
    CreateSunRiseSetShuttersTimer( $hash, $shuttersDev );
}

sub CreateNewNotifyDev($) {
    my $hash = shift;
    my $name = $hash->{NAME};

    $hash->{NOTIFYDEV} = "global," . $name;
    delete $hash->{monitoredDevs};

    CommandDeleteReading( undef, $name . ' .monitoredDevs' );
    foreach ( @{ $hash->{helper}{shuttersList} } ) {
        AddNotifyDev( $hash, AttrVal( $_, 'ASC_Roommate_Device', 'none' ),
            $_, 'ASC_Roommate_Device' )
          if ( AttrVal( $_, 'ASC_Roommate_Device', 'none' ) ne 'none' );
        AddNotifyDev( $hash, AttrVal( $_, 'ASC_WindowRec', 'none' ),
            $_, 'ASC_WindowRec' )
          if ( AttrVal( $_, 'ASC_WindowRec', 'none' ) ne 'none' );
        AddNotifyDev( $hash,
            AttrVal( $_, 'ASC_Shading_Brightness_Sensor', 'none' ),
            $_, 'ASC_Shading_Brightness_Sensor' )
          if (
            AttrVal( $_, 'ASC_Shading_Brightness_Sensor', 'none' ) ne 'none' );
    }
    AddNotifyDev( $hash, AttrVal( $name, 'ASC_residentsDevice', 'none' ),
        $name, 'ASC_residentsDevice' )
      if ( AttrVal( $name, 'ASC_residentsDevice', 'none' ) ne 'none' );
}

sub GetShuttersInformation($) {
    my $hash                 = shift;
    my $shuttersInformations = ShuttersInformation($hash);
    my $ret                  = '<html><table><tr><td>';
    $ret .= '<table class="block wide">';
    $ret .= '<tr class="even">';
    $ret .= "<td><b>Shutters</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>Next DriveUp</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>Next DriveDown</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>Partymode</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>Lock-Out</b></td>";
    $ret .= '</tr>';

    if ( ref($shuttersInformations) eq "HASH" ) {
        my $linecount = 1;
        foreach my $shutter ( sort keys( %{$shuttersInformations} ) ) {
            if   ( $linecount % 2 == 0 ) { $ret .= '<tr class="even">'; }
            else                         { $ret .= '<tr class="odd">'; }
            $ret .= "<td>$shutter</td>";
            $ret .= "<td> </td>";
            $ret .= "<td>$shuttersInformations->{$shutter}{Time_DriveUp}</td>";
            $ret .= "<td> </td>";
            $ret .=
              "<td>$shuttersInformations->{$shutter}{Time_DriveDown}</td>";
            $ret .= "<td> </td>";
            $ret .= "<td>$shuttersInformations->{$shutter}{Partymode}</td>";
            $ret .= "<td> </td>";
            $ret .= "<td>$shuttersInformations->{$shutter}{'Lock-Out'}</td>";
            $ret .= '</tr>';
            $linecount++;
        }
    }
    $ret .= '</table></td></tr>';
    $ret .= '</table></html>';
    return $ret;
}

sub ShuttersInformation($) {
    my $hash                 = shift;
    my %shuttersInformations = ();
    foreach ( @{ $hash->{helper}{shuttersList} } ) {
        $shuttersInformations{$_}{'Time_DriveUp'} =
          ReadingsVal( $_, 'ASC_Time_DriveUp', 'none' );
        $shuttersInformations{$_}{'Time_DriveDown'} =
          ReadingsVal( $_, 'ASC_Time_DriveDown', 'none' );
        $shuttersInformations{$_}{'Partymode'} =
          AttrVal( $_, 'ASC_Partymode', 'none' );
        $shuttersInformations{$_}{'Lock-Out'} =
          AttrVal( $_, 'ASC_lock-out', 'none' );
    }
    return \%shuttersInformations;
}

sub GetMonitoredDevs($) {
    my $hash       = shift;
    my $notifydevs = eval {
        decode_json( ReadingsVal( $hash->{NAME}, '.monitoredDevs', 'none' ) );
    };
    my $ret = '<html><table><tr><td>';
    $ret .= '<table class="block wide">';
    $ret .= '<tr class="even">';
    $ret .= "<td><b>Shutters/ASC-Device</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>NOTIFYDEV</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>Attribut</b></td>";
    $ret .= "<td> </td>";
    $ret .= '</tr>';

    if ( ref($notifydevs) eq "HASH" ) {
        my $linecount = 1;
        foreach my $notifydev ( sort keys( %{$notifydevs} ) ) {
            if ( ref( $notifydevs->{$notifydev} ) eq "HASH" ) {
                foreach
                  my $shutters ( sort keys( %{ $notifydevs->{$notifydev} } ) )
                {
                    if ( $linecount % 2 == 0 ) { $ret .= '<tr class="even">'; }
                    else                       { $ret .= '<tr class="odd">'; }
                    $ret .= "<td>$shutters</td>";
                    $ret .= "<td> </td>";
                    $ret .= "<td>$notifydev</td>";
                    $ret .= "<td> </td>";
                    $ret .= "<td>$notifydevs->{$notifydev}{$shutters}</td>";
                    $ret .= "<td> </td>";
                    $ret .= '</tr>';
                    $linecount++;
                }
            }
        }
    }

    ###### create Links
    my $aHref;

# create define Link
#     $aHref="<a href=\"".$::FW_httpheader->{host}."/fhem?cmd=set".$::FW_CSRF."\">Create new NOTIFYDEV structure</a>";
#     $aHref="<a href=\"/fhem?cmd=set+\">Create new NOTIFYDEV structure</a>";
#     $aHref="<a href=\"".$headerHost[0]."/fhem?cmd=define+".makeDeviceName($dataset->{station}{name})."+Aqicn+".$dataset->{uid}.$FW_CSRF."\">Create Station Device</a>";

    #     $ret .= '<tr class="odd"> </tr>';
    #     $ret .= '<tr class="even"> </tr>';
    #     $ret .= "<td> </td>";
    #     $ret .= "<td> </td>";
    #     $ret .= "<td> </td>";
    #     $ret .= "<td> </td>";
    #     $ret .= "<td>".$aHref."</td>";
    $ret .= '</table></td></tr>';
    $ret .= '</table></html>';

    return $ret;
}

#################################
## my little helper
#################################

# Hilfsfunktion welche meinen ReadingString zum finden der getriggerten Devices und der Zurdnung was das Device überhaupt ist und zu welchen Rolladen es gehört aus liest und das Device extraiert
sub ExtractNotifyDevFromEvent($$$) {
    my ( $hash, $shuttersDev, $shuttersAttr ) = @_;
    my %notifyDevs;
    while ( my $notifyDev = each %{ $hash->{monitoredDevs} } ) {
        Log3( $hash->{NAME}, 4,
"AutoShuttersControl ($hash->{NAME}) - ExtractNotifyDevFromEvent - NotifyDev: "
              . $notifyDev );
        Log3( $hash->{NAME}, 5,
"AutoShuttersControl ($hash->{NAME}) - ExtractNotifyDevFromEvent - ShuttersDev: "
              . $shuttersDev );

        if ( defined( $hash->{monitoredDevs}{$notifyDev}{$shuttersDev} )
            and $hash->{monitoredDevs}{$notifyDev}{$shuttersDev} eq
            $shuttersAttr )
        {
            Log3( $hash->{NAME}, 4,
"AutoShuttersControl ($hash->{NAME}) - ExtractNotifyDevFromEvent - ShuttersDevHash: "
                  . $hash->{monitoredDevs}{$notifyDev}{$shuttersDev} );
            Log3( $hash->{NAME}, 5,
"AutoShuttersControl ($hash->{NAME}) - ExtractNotifyDevFromEvent - return ShuttersDev: "
                  . $notifyDev );
            $notifyDevs{$notifyDev} = $shuttersDev;
        }
    }
    return \%notifyDevs;
}

## Ist Tag oder Nacht für den entsprechende Rolladen
sub IsDay($$) {
    my ( $hash, $shuttersDev ) = @_;
    my $name = $hash->{NAME};
    return ( ShuttersSunrise( $hash, $shuttersDev, 'unix' ) >
          ShuttersSunset( $hash, $shuttersDev, 'unix' ) ? 1 : 0 );
}

sub ShuttersSunrise($$$) {
    my ( $hash, $shuttersDev, $tm ) =
      @_;    # Tm steht für Timemode und bedeutet Realzeit oder Unixzeit
    my $name = $hash->{NAME};
    my $autoAstroMode;
    $shutters->setShuttersDev($shuttersDev);
    $ascDev->setName($name);

    if ( $shutters->getAutoAstroModeMorning ne 'none' ) {
        $autoAstroMode = $shutters->getAutoAstroModeMorning;
        $autoAstroMode =
          $autoAstroMode . '=' . $shutters->getAutoAstroModeMorningHorizon
          if ( $autoAstroMode eq 'HORIZON' );
    }
    else {
        $autoAstroMode = $ascDev->getAutoAstroModeMorning;
        $autoAstroMode =
          $autoAstroMode . '='
          . AttrVal( $name, 'ASC_autoAstroModeMorningHorizon', 0 )
          if ( $autoAstroMode eq 'HORIZON' );
    }
    my $oldFuncHash = $shutters->getInTimerFuncHash;
    my $shuttersSunriseUnixtime;

    if ( $tm eq 'unix' ) {
        if ( $shutters->getUpMode eq 'astro' ) {
            if ( ( IsWe() or IsWeTomorrow() )
                and $ascDev->getSunriseTimeWeHoliday($name) eq 'on' )
            {
                if ( not IsWeTomorrow() ) {
                    if (
                        int( gettimeofday() / 86400 ) == int(
                            (
                                computeAlignTime(
                                    '24:00',
                                    sunrise_abs(
                                        $autoAstroMode,
                                        0,
                                        $shutters->getTimeUpEarly,
                                        $shutters->getTimeUpLate
                                    )
                                ) + 1
                            ) / 86400
                        )
                      )
                    {
                        $shuttersSunriseUnixtime = (
                            computeAlignTime(
                                '24:00',
                                sunrise_abs(
                                    $autoAstroMode, 0,
                                    $shutters->getTimeUpWeHoliday
                                )
                            ) + 1
                        );
                    }
                    else {
                        $shuttersSunriseUnixtime = (
                            computeAlignTime(
                                '24:00',
                                sunrise_abs(
                                    $autoAstroMode,
                                    0,
                                    $shutters->getTimeUpEarly,
                                    $shutters->getTimeUpLate
                                )
                            ) + 1
                        );
                    }
                }
                else {
                    $shuttersSunriseUnixtime = (
                        computeAlignTime(
                            '24:00',
                            sunrise_abs(
                                $autoAstroMode, 0,
                                $shutters->getTimeUpWeHoliday
                            )
                        ) + 1
                    );
                }
            }
            else {
                $shuttersSunriseUnixtime = (
                    computeAlignTime(
                        '24:00',
                        sunrise_abs(
                            $autoAstroMode,
                            0,
                            $shutters->getTimeUpEarly,
                            $shutters->getTimeUpLate
                        )
                    ) + 1
                );
            }
            if (    defined($oldFuncHash)
                and ref($oldFuncHash) eq 'HASH'
                and ( IsWe() or IsWeTomorrow() )
                and $ascDev->getSunriseTimeWeHoliday($name) eq 'on' )
            {
                if ( not IsWeTomorrow() ) {
                    if (
                        int( gettimeofday() / 86400 ) == int(
                            (
                                computeAlignTime(
                                    '24:00',
                                    sunrise_abs(
                                        $autoAstroMode,
                                        0,
                                        $shutters->getTimeUpEarly,
                                        $shutters->getTimeUpLate
                                    )
                                ) + 1
                            ) / 86400
                        )
                      )
                    {
                        $shuttersSunriseUnixtime =
                          ( $shuttersSunriseUnixtime + 86400 )
                          if ( $shuttersSunriseUnixtime <
                            ( $oldFuncHash->{sunrisetime} + 180 )
                            and $oldFuncHash->{sunrisetime} < gettimeofday() );
                    }
                }
            }
            elsif ( defined($oldFuncHash) and ref($oldFuncHash) eq 'HASH' ) {
                $shuttersSunriseUnixtime = ( $shuttersSunriseUnixtime + 86400 )
                  if ( $shuttersSunriseUnixtime <
                    ( $oldFuncHash->{sunrisetime} + 180 )
                    and $oldFuncHash->{sunrisetime} < gettimeofday() );
            }
        }
        elsif ( $shutters->getUpMode eq 'time' ) {
            $shuttersSunriseUnixtime =
              computeAlignTime( '24:00', $shutters->getTimeUpEarly );
        }
        elsif ( $shutters->getUpMode eq 'brightness' ) {
            $shuttersSunriseUnixtime =
              computeAlignTime( '24:00', $shutters->getTimeUpLate );
        }
        return $shuttersSunriseUnixtime;
    }
    elsif ( $tm eq 'real' ) {
        return sunrise_abs( $autoAstroMode, 0, $shutters->getTimeUpEarly,
            $shutters->getTimeUpLate )
          if ( $shutters->getUpMode eq 'astro' );
        return $shutters->getTimeUpEarly if ( $shutters->getUpMode eq 'time' );
    }
}

sub ShuttersSunset($$$) {
    my ( $hash, $shuttersDev, $tm ) =
      @_;    # Tm steht für Timemode und bedeutet Realzeit oder Unixzeit
    my $name = $hash->{NAME};
    my $autoAstroMode;
    $shutters->setShuttersDev($shuttersDev);
    $ascDev->setName($name);

    if ( $shutters->getAutoAstroModeEvening ne 'none' ) {
        $autoAstroMode = $shutters->getAutoAstroModeEvening;
        $autoAstroMode =
          $autoAstroMode . '=' . $shutters->getAutoAstroModeEveningHorizon
          if ( $autoAstroMode eq 'HORIZON' );
    }
    else {
        $autoAstroMode = $ascDev->getAutoAstroModeEvening;
        $autoAstroMode =
          $autoAstroMode . '='
          . AttrVal( $name, 'ASC_autoAstroModeEveningHorizon', 0 )
          if ( $autoAstroMode eq 'HORIZON' );
    }
    my $oldFuncHash = $shutters->getInTimerFuncHash;
    my $shuttersSunsetUnixtime;

    if ( $tm eq 'unix' ) {
        if ( $shutters->getDownMode eq 'astro' ) {
            $shuttersSunsetUnixtime = (
                computeAlignTime(
                    '24:00',
                    sunset_abs(
                        $autoAstroMode,
                        0,
                        $shutters->getTimeDownEarly,
                        $shutters->getTimeDownLate
                    )
                ) + 1
            );
            if ( defined($oldFuncHash) and ref($oldFuncHash) eq 'HASH' ) {
                $shuttersSunsetUnixtime = ( $shuttersSunsetUnixtime + 86400 )
                  if ( $shuttersSunsetUnixtime <
                    ( $oldFuncHash->{sunsettime} + 180 )
                    and $oldFuncHash->{sunsettime} < gettimeofday() );
            }
        }
        elsif ( $shutters->getDownMode eq 'time' ) {
            $shuttersSunsetUnixtime =
              computeAlignTime( '24:00', $shutters->getTimeDownEarly );
        }
        elsif ( $shutters->getDownMode eq 'brightness' ) {
            $shuttersSunsetUnixtime =
              computeAlignTime( '24:00', $shutters->getTimeDownLate );
        }
        return $shuttersSunsetUnixtime;
    }
    elsif ( $tm eq 'real' ) {
        return sunset_abs(
            $autoAstroMode, 0,
            $shutters->getTimeDownEarly,
            $shutters->getTimeDownLate
        ) if ( $shutters->getDownMode eq 'astro' );
        return $shutters->getTimeDownEarly
          if ( $shutters->getDownMode eq 'time' );
    }
}

## Kontrolliert ob das Fenster von einem bestimmten Rolladen offen ist
sub CheckIfShuttersWindowRecOpen($) {
    my $shuttersDev = shift;
    $shutters->setShuttersDev($shuttersDev);

    if ( $shutters->getWinStatus eq 'open' ) { return 2; }
    elsif ( $shutters->getWinStatus eq 'tilted'
        and $shutters->getSubTyp eq 'threestate' )
    {
        return 1;
    }
    elsif ( $shutters->getWinStatus eq 'closed' ) { return 0; }
}

sub ShuttersPosCmdValueNegieren($) {
    my $shuttersDev = shift;
    $shutters->setShuttersDev($shuttersDev);
    return ( $shutters->getOpenPos < $shutters->getClosedPos ? 1 : 0 );
}

sub makeReadingName($) {
    my ($name) = @_;
    my %charHash = (
        "ä" => "ae",
        "Ä" => "Ae",
        "ü" => "ue",
        "Ü" => "Ue",
        "ö" => "oe",
        "Ö" => "Oe",
        "ß" => "ss"
    );
    my $charHashkeys = join( "|", keys(%charHash) );

    $name = "UNDEFINED" if ( !defined($name) );
    return $name if ( $name =~ m/^\./ );
    $name =~ s/($charHashkeys)/$charHash{$1}/gi;
    $name =~ s/[^a-z0-9._\-\/]/_/gi;
    return $name;
}

sub TimeMin2Sec($) {
    my $min = shift;
    my $sec;

    $sec = $min * 60;
    return $sec;
}

sub IsWe() {
    my ( undef, undef, undef, undef, undef, undef, $wday, undef, undef ) =
      localtime( gettimeofday() );
    my $we = ( ( $wday == 0 || $wday == 6 ) ? 1 : 0 );

    if ( !$we ) {
        foreach my $h2we ( split( ",", AttrVal( "global", "holiday2we", "" ) ) )
        {
            my ( $a, $b ) =
              ReplaceEventMap( $h2we, [ $h2we, Value($h2we) ], 0 );
            $we = 1 if ( $b && $b ne "none" );
        }
    }
    return $we;
}

sub IsWeTomorrow() {
    my ( undef, undef, undef, undef, undef, undef, $wday, undef, undef ) =
      localtime( gettimeofday() );
    my $we = (
        ( ( ( $wday + 1 == 7 ? 0 : $wday + 1 ) ) == 0 || ( $wday + 1 ) == 6 )
        ? 1
        : 0
    );

    if ( !$we ) {
        foreach my $h2we ( split( ",", AttrVal( "global", "holiday2we", "" ) ) )
        {
            my ( $a, $b ) = ReplaceEventMap( $h2we,
                [ $h2we, ReadingsVal( $h2we, "tomorrow", "none" ) ], 0 );
            $we = 1 if ( $b && $b ne "none" );
        }
    }
    return $we;
}

sub IsHoliday($) {
    my $hash = shift;
    my $name = $hash->{NAME};

    return (
        ReadingsVal( AttrVal( $name, 'ASC_timeUpHolidayDevice', 'none' ),
            'state', 0 ) == 1 ? 1 : 0
    );
}

########## Begin der Klassendeklarierungen für OOP (Objektorientiertes Programming) #########################
## Klasse Rolläden (Shutters) und die Subklassen Attr und Readings ##
## desweiteren wird noch die Klasse ASC_Roommate mit eingebunden
package ASC_Shutters;
our @ISA =
  qw(ASC_Shutters::Readings ASC_Shutters::Attr ASC_Roommate ASC_Window);

use strict;
use warnings;

use GPUtils qw(:all);

## Import der FHEM Funktionen
BEGIN {
    GP_Import(
        qw(
          defs
          ReadingsVal
          readingsSingleUpdate
          CommandSet
          gettimeofday)
    );
}

sub new {
    my $class = shift;
    my $self  = {
        shuttersDev => undef,
        defaultarg  => undef,
        roommate    => undef,
        lastPos     => undef,
    };

    bless $self, $class;
    return $self;
}

sub setShuttersDev {
    my ( $self, $shuttersDev ) = @_;

    $self->{shuttersDev} = $shuttersDev if ( defined($shuttersDev) );
    return $self->{shuttersDev};
}

sub setDriveCmd {
    my ( $self, $posValue ) = @_;
    my $shuttersDev = $self->{shuttersDev};

    $shutters->setLastPos( $shutters->getStatus );
    CommandSet( undef,
            $shuttersDev
          . ':FILTER='
          . $shutters->getPosCmd . '!='
          . $posValue . ' '
          . $shutters->getPosCmd . ' '
          . $posValue );
    return 0;
}

sub setDelayDriveCmd {
    my ( $self, $posValue ) = @_;
    my $shuttersDevHash = $defs{ $self->{shuttersDev} };
    readingsSingleUpdate( $shuttersDevHash, '.AutoShuttersControl_DelayCmd',
        $posValue, 0 );
    return 0;
}

sub setLastPos {
    my ( $self, $position ) = @_;

    $self->{ $self->{shuttersDev} }{lastPos}{VAL}   = $position
      if ( defined($position) );
    $self->{ $self->{shuttersDev} }{lastPos}{TIME}  = int(gettimeofday())
      if (  defined( $self->{ $self->{shuttersDev} }{lastPos} ) );
    return 0;
}

sub setDefault {
    my ( $self, $defaultarg ) = @_;

    $self->{defaultarg} = $defaultarg if ( defined($defaultarg) );
    return $self->{defaultarg};
}

sub setRoommate {
    my ( $self, $roommate ) = @_;

    $self->{roommate} = $roommate if ( defined($roommate) );
    return $self->{roommate};
}

sub setInTimerFuncHash {
    my ( $self, $inTimerFuncHash ) = @_;

    $self->{ $self->{shuttersDev} }{inTimerFuncHash} = $inTimerFuncHash
      if ( defined($inTimerFuncHash) );
    return 0;
}

sub getLastPos {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return $self->{ $self->{shuttersDev} }{lastPos}{VAL}
      if (  defined( $self->{ $self->{shuttersDev} }{lastPos} )
        and defined( $self->{ $self->{shuttersDev} }{lastPos}{VAL} ) );
}

sub getLastPosTimestamp {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return $self->{ $self->{shuttersDev} }{lastPos}{TIME}
      if (  defined( $self->{ $self->{shuttersDev} } )
        and defined( $self->{ $self->{shuttersDev} }{lastPos} )
        and defined( $self->{ $self->{shuttersDev} }{lastPos}{TIME} ) );
}

sub getInTimerFuncHash {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return $self->{ $self->{shuttersDev} }{inTimerFuncHash};
}

sub getRoommatesStatus {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $loop        = 0;
    my @roState;
    my %statePrio = (
        'asleep'    => 1,
        'gotosleep' => 2,
        'awoken'    => 3,
        'home'      => 4,
        'absent'    => 5,
        'gone'      => 6,
        'none'      => 7
    );
    my $minPrio = 10;

    foreach my $ro ( split( ",", $shutters->getRoommates ) ) {
        $shutters->setRoommate($ro);
        my $currentPrio = $statePrio{ $shutters->getRoommateStatus };
        $minPrio = $currentPrio if ( $minPrio > $currentPrio );
    }

    my %revStatePrio = reverse %statePrio;
    return $revStatePrio{$minPrio};
}

sub getRoommatesLastStatus {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $loop        = 0;
    my @roState;
    my %statePrio = (
        'asleep'    => 1,
        'gotosleep' => 2,
        'awoken'    => 3,
        'home'      => 4,
        'absent'    => 5,
        'gone'      => 6,
        'none'      => 7
    );
    my $minPrio = 10;

    foreach my $ro ( split( ",", $shutters->getRoommates ) ) {
        $shutters->setRoommate($ro);
        my $currentPrio = $statePrio{ $shutters->getRoommateLastStatus };
        $minPrio = $currentPrio if ( $minPrio > $currentPrio );
    }

    my %revStatePrio = reverse %statePrio;
    return $revStatePrio{$minPrio};
}

## Subklasse Attr von ASC_Shutters##
package ASC_Shutters::Attr;

use strict;
use warnings;

use GPUtils qw(:all);

## Import der FHEM Funktionen
BEGIN {
    GP_Import(
        qw(
          AttrVal)
    );
}

sub getSelfDefenseExclude {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Self_Defense_Exclude', 'off' );
}

sub getShadingBrightnessSensor {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $shuttersDev, 'ASC_Shading_Brightness_Sensor', $default );
}

sub getShadingBrightnessReading {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'brightness' if ( not defined($default) );
    return AttrVal( $shuttersDev, 'ASC_Shading_Brightness_Reading', $default );
}

sub getPosCmd {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Pos_Cmd', 'pct' );
}

sub getOpenPos {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Open_Pos', 0 );
}

sub getVentilatePos {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Ventilate_Pos', 80 );
}

sub getClosedPos {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Closed_Pos', 100 );
}

sub getVentilateOpen {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Ventilate_Window_Open', 'off' );
}

sub getPosAfterComfortOpen {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Pos_after_ComfortOpen', 50 );
}

sub getPartyMode {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Partymode', 'off' );
}

sub getRoommates {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $shuttersDev, 'ASC_Roommate_Device', $default );
}

sub getRoommatesReading {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'state' if ( not defined($default) );
    return AttrVal( $shuttersDev, 'ASC_Roommate_Reading', $default );
}

sub getModeUp {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Mode_Up', 'off' );
}

sub getModeDown {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Mode_Down', 'off' );
}

sub getLockOut {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_lock-out', 'soft' );
}

sub getAntiFreeze {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Antifreeze', 'off' );
}

sub getOffsetMorning {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Offset_Minutes_Morning', 0 );
}

sub getOffsetEvening {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Offset_Minutes_Evening', 0 );
}

sub getAutoAstroModeMorning {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $shuttersDev, 'ASC_AutoAstroModeMorning', $default );
}

sub getAutoAstroModeEvening {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $shuttersDev, 'ASC_AutoAstroModeEvening', $default );
}

sub getAutoAstroModeMorningHorizon {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_AutoAstroModeMorningHorizon', 0 );
}

sub getAutoAstroModeEveningHorizon {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_AutoAstroModeEveningHorizon', 0 );
}

sub getUpMode {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Up', 'astro' );
}

sub getDownMode {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Down', 'astro' );
}

sub getTimeUpEarly {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Time_Up_Early', '04:30:00' );
}

sub getTimeUpLate {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Time_Up_Late', '09:00:00' );
}

sub getTimeDownEarly {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Time_Down_Early', '15:30:00' );
}

sub getTimeDownLate {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Time_Down_Late', '22:00:00' );
}

sub getTimeUpWeHoliday {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_Time_Up_WE_Holiday', '04:00:00' );
}

sub getBrightnessMinVal {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_BrightnessMinVal', -1 );
}

sub getBrightnessMaxVal {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return AttrVal( $shuttersDev, 'ASC_BrightnessMaxVal', -1 );
}

## Subklasse Readings von ASC_Shutters ##
package ASC_Shutters::Readings;

use strict;
use warnings;

use GPUtils qw(:all);

## Import der FHEM Funktionen
BEGIN {
    GP_Import(
        qw(
          ReadingsVal)
    );
}

sub getBrightness {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return ReadingsVal( $shutters->getShadingBrightnessSensor,
        $shutters->getShadingBrightnessReading, 0 );
}

sub getStatus {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};

    return ReadingsVal( $shuttersDev, $shutters->getPosCmd, 0 );
}

sub getDelayCmd {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return ReadingsVal( $shuttersDev, '.ASC_DelayCmd', $default );
}


## Klasse Fenster (Window) und die Subklassen Attr und Readings ##
package ASC_Window;
our @ISA = qw(ASC_Window::Attr ASC_Window::Readings);

## Subklasse Attr von Klasse ASC_Window ##
package ASC_Window::Attr;

use strict;
use warnings;

use GPUtils qw(:all);

## Import der FHEM Funktionen
BEGIN {
    GP_Import(
        qw(
          AttrVal)
    );
}

sub getSubTyp {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'twostate' if ( not defined($default) );
    return AttrVal( $shuttersDev, 'ASC_WindowRec_subType', $default );
}

sub getWinDev {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $shuttersDev, 'ASC_WindowRec', $default );
}

## Subklasse Readings von Klasse ASC_Window ##
package ASC_Window::Readings;

use strict;
use warnings;

use GPUtils qw(:all);

## Import der FHEM Funktionen
BEGIN {
    GP_Import(
        qw(
          ReadingsVal)
    );
}

sub getWinStatus {
    my $self        = shift;
    my $shuttersDev = $self->{shuttersDev};
    my $default     = $self->{defaultarg};

    $default = 'closed' if ( not defined($default) );
    return ReadingsVal( $shutters->getWinDev, 'state', $default );
}

## Klasse ASC_Roommate ##
package ASC_Roommate;

use strict;
use warnings;

use GPUtils qw(:all);

## Import der FHEM Funktionen
BEGIN {
    GP_Import(
        qw(
          ReadingsVal)
    );
}

sub getRoommateStatus {
    my $self     = shift;
    my $roommate = $self->{roommate};
    my $default  = $self->{defaultarg};

    $default = 'home' if ( not defined($default) );
    return ReadingsVal( $roommate, $shutters->getRoommatesReading, $default );
}

sub getRoommateLastStatus {
    my $self     = shift;
    my $roommate = $self->{roommate};
    my $default  = $self->{defaultarg};

    $default = 'home' if ( not defined($default) );
    return ReadingsVal( $roommate, 'lastState', $default );
}

## Klasse ASC_Dev plus Subklassen ASC_Attr_Dev und ASC_Readings_Dev##
package ASC_Dev;
our @ISA = qw(ASC_Dev::Readings ASC_Dev::Attr);

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = { name => undef, };

    bless $self, $class;
    return $self;
}

sub setName {
    my ( $self, $name ) = @_;

    $self->{name} = $name if ( defined($name) );
    return $self->{name};
}

sub setDefault {
    my ( $self, $defaultarg ) = @_;

    $self->{defaultarg} = $defaultarg if ( defined($defaultarg) );
    return $self->{defaultarg};
}

## Subklasse Readings ##
package ASC_Dev::Readings;

use strict;
use warnings;

use GPUtils qw(:all);

## Import der FHEM Funktionen
BEGIN {
    GP_Import(
        qw(
          ReadingsVal)
    );
}

sub getPartyModeStatus {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return ReadingsVal( $name, 'partyMode', $default );
}

sub getLockOut {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return ReadingsVal( $name, 'lockOut', $default );
}

sub getSunriseTimeWeHoliday {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return ReadingsVal( $name, 'sunriseTimeWeHoliday', $default );
}

sub getMonitoredDevs {
    my $self = shift;
    my $name = $self->{name};

    $self->{monitoredDevs} = ReadingsVal( $name, '.monitoredDevs', 'none' );
    return $self->{monitoredDevs};
}

sub getOutTemp {
    my $self = shift;
    my $name = $self->{name};

    return ReadingsVal( $ascDev->getTempSensor, $ascDev->getTempReading, 100 );
}

sub getResidentsStatus {
    my $self = shift;
    my $name = $self->{name};

    return ReadingsVal( $ascDev->getResidentsDev, $ascDev->getResidentsReading,
        'home' );
}

sub getResidentsLastStatus {
    my $self = shift;
    my $name = $self->{name};

    return ReadingsVal( $ascDev->getResidentsDev, 'lastState', 'absent' );
}

sub getSelfDefense {
    my $self = shift;
    my $name = $self->{name};

    return ReadingsVal( $name, 'selfDefense', 'none' );
}

## Subklasse Attr ##
package ASC_Dev::Attr;

use strict;
use warnings;

use GPUtils qw(:all);

## Import der FHEM Funktionen
BEGIN {
    GP_Import(
        qw(
          AttrVal)
    );
}

sub getBrightnessMinVal {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 8000 if ( not defined($default) );
    return AttrVal( $name, 'ASC_brightnessMinVal', $default );
}

sub getBrightnessMaxVal {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 20000 if ( not defined($default) );
    return AttrVal( $name, 'ASC_brightnessMaxVal', $default );
}

sub getAutoAstroModeEvening {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $name, 'ASC_autoAstroModeEvening', $default );
}

sub getAutoAstroModeEveningHorizon {
    my $self = shift;
    my $name = $self->{name};

    return AttrVal( $name, 'ASC_autoAstroModeEveningHorizon', 0 );
}

sub getAutoAstroModeMorning {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $name, 'ASC_autoAstroModeMorning', $default );
}

sub getAutoAstroModeMorningHorizon {
    my $self = shift;
    my $name = $self->{name};

    return AttrVal( $name, 'ASC_autoAstroModeMorningHorizon', 0 );
}

sub getAutoShuttersControlMorning {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $name, 'ASC_autoShuttersControlMorning', $default );
}

sub getAutoShuttersControlEvening {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $name, 'ASC_autoShuttersControlEvening', $default );
}

sub getAutoShuttersControlComfort {
    my $self = shift;
    my $name = $self->{name};

    return AttrVal( $name, 'ASC_autoShuttersControlComfort', 'off' );
}

sub getAntifreezeTemp {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $name, 'ASC_antifreezeTemp', $default );
}

sub getTempSensor {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $name, 'ASC_temperatureSensor', $default );
}

sub getTempReading {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $name, 'ASC_temperatureReading', $default );
}

sub getResidentsDev {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'none' if ( not defined($default) );
    return AttrVal( $name, 'ASC_residentsDevice', $default );
}

sub getResidentsReading {
    my $self    = shift;
    my $name    = $self->{name};
    my $default = $self->{defaultarg};

    $default = 'state' if ( not defined($default) );
    return AttrVal( $name, 'ASC_residentsDeviceReading', $default );
}
1;

=pod
=item device
=item summary       Modul 
=item summary_DE    Modul zur Automatischen Rolladensteuerung auf Basis bestimmter Ereignisse

=begin html

<a name="AutoShuttersControl"></a>
<h3>Automated Shutter Control - ASC</h3>
<ul>
  <u><b>AutoShuttersControl (shurt: ASC) is designed for automation of shutter levels based on individual presets and timers. Timers can use sunrise and sunset events,reaction on opening or closing of correspondant window contacts is possible.</b></u>
  <br>
  This module generates a virtual device. If your shutters are represented in FHEM as devices,just put them under controll of this module. Then you get further options to let ASC controll them. Set the provided attributes and ASC will e.g. open your shutter after sunrise when resident is awoken. Or let it go to a predifined position for ventilation when window is tilted. 
  <br><br>
  <a name="AutoShuttersControlDefine"></a>
  <b>Define</b>
  <ul><br>
    <code>define &lt;name&gt; AutoShuttersControl</code>
    <br><br>
    Example:
    <ul><br>
      <code>define Rolladensteuerung AutoShuttersControl</code><br>
    </ul>
    <br>
    This creates a AutoShuttersControl Device named Rolladensteuerung.<br>
    After this first step,start adding shutter devices by assigning the new attribute  "AutoShuttersControl" using "1" or "2" as value.<br>
    Use "1" if your shutter is open at lower position (typically: 0 = open,100 = closed) and shutter command "position" is used. Right choice for ROLLO devices.
	"2" means opposite,so open is 100 and closed corresponds to 0; command for going to a specific position is "pct". Use "2" especially for HomeMatic devices.<br>
    Next use the "scanForShutters" setter to get your shutter(s) controlled by ASC and start configuring your shutter devices by setting the ASC attributes to your needs.
  </ul>
  <br><br>
  <a name="AutoShuttersControlReadings"></a>
  <b>Readings</b>
  <ul>
    Module Device
    <ul>
      <li>..._nextAstroTimeEvent - Execution time of the next Astro Event,sunrise,sunset or fixed time per shutter</li>
      <li>..._lastPosValue - last sent positioning command per shutter</li>
      <li>..._lastDelayPosValue - last positioning command per shutter not yet sent,waiting for event dependent execution.</li>
      <li>partyMode - on/off; activates a global party mode,all shutters with ASC_Partymode attribute set to "on" will not get any command from ASC until part is set to "off" again. Then the last intermediate positioning command will be executed,e.g. based on window opening or resident state.</li>
      <li>lockOut - on/off f&uuml;r das aktivieren des Aussperrschutzes gem&auml;&szlig; dem entsprechenden Attribut ASC_lock-out im jeweiligen Rolladen. (siehe Beschreibung bei den Attributen f&uuml;r die Rolladendevices)</li>
      <li>room_... - List of all shutter devices under ASC control per room</li>
      <li>state - State of the ASC device (active,enabled or disabled)</li>
      <li>userAttrList - Indicates if all UserAttributes are rolled out to shutter devices.</li>
    </ul><br>
    Shutter Devices
    <ul>
      <li>ASC_Time_DriveUp - Shutter's individual sunrise time</li>
      <li>ASC_Time_DriveDown - Shutter's individual sunset time</li>
    </ul>
  </ul>
  <br><br>
  <a name="AutoShuttersControlSet"></a>
  <b>Set</b>
  <ul>
    <li>partyMode - on/off activates global party mode. See Reading partyMode</li>
    <li>lockOut - on/off aktiviert den globalen Aussperrschutz. Siehe Reading partyMode</li>
    <li>renewSetSunriseSunsetTimer - renews individual times and internal timers for all shutters under ASC control.</li>
    <li>scanForShutters - add all FHEM devices to ASC control; looks up for devices with attribute "AutoShuttersControl" set to 1 or 2.</li>
    <li></li>
  </ul>
  <br><br>
  <a name="AutoShuttersControlGet"></a>
  <b>Get</b>
  <ul>
    <li></li>
  </ul>
  <br><br>
  <a name="AutoShuttersControlAttributes"></a>
  <b>Attributes</b>
  <ul>
  Modul Device
    <ul>
      <li>ASC_antifreezeTemp - Temperature limit. Below this temperature,ASC will not issue positioning commands to prevent damages from frozen shutters. Last positioning command will be stored for later execution.</li>
      <li>ASC_autoAstroModeEvening - can be set to REAL,CIVIL,NAUTIC,ASTRONOMIC</li>
      <li>ASC_autoAstroModeEveningHorizon - Highth above horizon. Use this in combination with attribute ASC_autoAstroModeEvening set to HORIZON</li>
      <li>ASC_autoAstroModeMorning - can be set to REAL,CIVIL,NAUTIC,ASTRONOMIC</li>
      <li>ASC_autoAstroModeMorningHorizon - similar to ASC_autoAstroModeEvening</li>
      <li>ASC_autoShuttersControlComfort - on/off. Switch to on to react on open or tilted events. Needs further info in shutter attributes about WindowRec,WindowRecType and ASC_Pos_after_ComfortOpen (last sets target position).</li>
      <li>ASC_autoShuttersControlEvening - on/off; Switch to on to close this shutter in the evening</li>
      <li>ASC_autoShuttersControlMorning - on/off; similar to ASC_autoShuttersControlEvening for opening.</li>
      <li>ASC_temperatureReading - Reading name for outside temperature</li>
      <li>ASC_temperatureSensor - Device name for outside temperature</li>
    </ul><br>
    Individual Shutter Devices
    <ul>
      <li>AutoShuttersControl - 0/1/2. Use "1" if your shutter is open at lower position (typically: 0 = open,100 = closed) and shutter command "position" is used. Right choice for ROLLO devices.
	"2" means opposite,so open is 100 and closed corresponds to 0; command for going to a specific position is "pct". Use "2" especially for HomeMatic devices.</li>
      <li>ASC_Antifreeze - on/off; Set to on to prevent ASC commands under the set temperature limit</li>
      <li>ASC_AutoAstroModeEvening - can be set to REAL,CIVIL,NAUTIC,ASTRONOMIC</li>
      <li>ASC_AutoAstroModeEveningHorizon - Highth above horizon. Use this in combination with attribute ASC_autoAstroModeEvening set to HORIZON</li>
      <li>ASC_AutoAstroModeMorning - can be set to REAL,CIVIL,NAUTIC,ASTRONOMIC</li>
      <li>ASC_AutoAstroModeMorningHorizon - similar to ASC_autoAstroModeEvening</li>
      <li>ASC_Closed_Pos - in 10 steps from 0 to 100,defaults will be set dependent on AutoShuttersControl attribute value.</li>
      <li>ASC_Down - astro/time. "Astro" uses sunrise logic to calculate sunset time,"time" uses ASC_Time_Down_Early attibute's value.</li>
      <li>ASC_Mode_Down - always/absent/off. Additional conditions for close commands based on roommate state. Please note: If there's no roommate and attribute set to "absent" no closing command will be issued.</li>
      <li>ASC_Mode_Up - always/absent/off. Like ASC_Mode_Down for opening commands.</li>
      <li>ASC_Offset_Minutes_Evening - </li>
      <li>ASC_Offset_Minutes_Morning - </li>
      <li>ASC_Open_Pos -  in 10 steps from 0 to 100,defaults will be set dependent on AutoShuttersControl attribute value.</li>
      <li>ASC_Partymode -  on/off. See correspondant Attribute for ASC Module.</li>
      <li>ASC_Pos_Cmd - set command for setting the shutter to a decent level; must correspond to the reading name for the actual position of the shutter</li>
      <li>ASC_Pos_after_ComfortOpen - in 10 steps from 0 to 100,defaults will be set dependent on AutoShuttersControl attribute value.</li>
      <li>ASC_Roommate_Reading - Reading name of the roommate device's status info.</li>
      <li>ASC_Roommate_Device - Name of comma seperated roommate device/s to be used to controll all shutters in the same room as the roommate.</li>
      <li>ASC_Time_Down_Early - Early limit for closing timer calculation using sunset</li>
      <li>ASC_Time_Down_Late - Latest limit for closing timer calculation using sunset</li>
      <li>ASC_Time_Up_Early - Like ...Time_Down... for opening</li>
      <li>ASC_Time_Up_Late - Like ...Time_Down... for opening</li>
      <li>ASC_Time_Up_WE_Holiday - Sunrise fr&uuml;hste Zeit zum hochfahren am Wochenende und/oder Urlaub</li>
      <li>ASC_Time_Up_HolidayDevice - Device zur Urlaubserkennung/muss 0 oder 1 im Reading state beinhalten.</li>
      <li>ASC_Up - astro/time "Astro" will use sunrise calculation for opening times,"time" uses ASC_Time_Up_Early value.</li>
      <li>ASC_Ventilate_Pos -  in 10 steps from 0 to 100,defaults will be set dependent on AutoShuttersControl attribute value.</li>
      <li>ASC_Ventilate_Window_Open - Level to be set for ventilation in case of opening or tilted event (only if current shutter position is below this level</li>
      <li>ASC_WindowRec - Name of the window contact corresponding to the shutter</li>
      <li>ASC_WindowRec_subType - Type of the used window contact: twostate (only sends open and closed) or threestate (sends also tilted)</li>
      <li>ASC_lock-out - soft/hard stellt entsprechend den Aussperrschutz ein. Bei global aktiven Aussperrschutz (set ASC-Device lockOut soft) und einem Fensterkontakt open bleibt dann der Rolladen oben. Dies gilt nur bei Steuerbefehle über das ASC Modul. Stellt man global auf hard,wird bei entsprechender M&ouml;glichkeit versucht den Rolladen Hardwareseitig zu blockieren. Dann ist auch ein fahren &uuml;ber die Taster nicht mehr m&ouml;glich.</li>
      <li>ASC_lock-outCmd - inhibit/blocked set Befehl für das Rolladen-Device zum Hardware sperren. Zum gesetzt werden wenn man "ASC_lock-out" auf hard setzt</li>
    </ul>
  </ul>
</ul>

=end html

=begin html_DE

<a name="AutoShuttersControl"></a>
<h3>Automatische Rolladensteuerung - ASC</h3>
<ul>
  <u><b>AutoShuttersControl oder kurz ASC,steuert automatisch Deine Rolladen nach bestimmten Vorgaben. Zum Beispiel Sonnenaufgang und Sonnenuntergang oder je nach Fenstervent</b></u>
  <br>
  Dieses Modul soll alle vom Modul &uuml;berwachten Roll&auml;den entsprechend der Konfiguration &uuml;ber die Attribute im Rolladen Device steuern. Es wird bei entsprechender Konfiguration zum Beispiel die Roll&auml;den hochfahren wenn ein Bewohner erwacht ist und draussen bereits die Sonne aufgegangen ist. Auch ist es m&ouml;glich das bei ankippen eines Fensters der geschlossene Rolladen in eine L&uuml;ftungsposition f&auml;hrt.
  <br><br>
  <a name="AutoShuttersControlDefine"></a>
  <b>Define</b>
  <ul><br>
    <code>define &lt;name&gt; AutoShuttersControl</code>
    <br><br>
    Example:
    <ul><br>
      <code>define Rolladensteuerung AutoShuttersControl</code><br>
    </ul>
    <br>
    Der Befehl erstellt ein AutoShuttersControl Device mit Namen Rolladen.<br>
    Nachdem das Device angelegt wurde,m&uuml;ssen in allen Roll&auml;den Devices welche gesterut werden sollen das Attribut AutoShuttersControl mit Wert 1 oder 2 gesetzt werden.<br>
    Dabei bedeutet 1 = "Inverse oder Rollo Bsp.: Rollo Oben 0,Rollo Unten 100 und der Befehl zum Prozentualen fahren ist position",2 = "Homematic Style Bsp.: Rollo Oben 100,Rollo Unten 0 und der Befehl zum Prozentualen fahren ist pct.<br>
    Habt Ihr das Attribut gesetzt,k&ouml;nnt Ihr den automatischen Scan nach den Devices anstossen.
  </ul>
  <br><br>
  <a name="AutoShuttersControlReadings"></a>
  <b>Readings</b>
  <ul>
    Im Modul Device
    <ul>
      <li>..._nextAstroTimeEvent - Uhrzeit des nächsten Astro Events,Sonnenauf,Sonnenuntergang oder feste Zeit pro Rollonamen</li>
      <li>..._lastPosValue - letzter abgesetzter Fahrbefehl pro Rollanamen</li>
      <li>..._lastDelayPosValue - letzter abgesetzter Fahrbefehl welcher beim n&auml;chsten zul&auml;ssigen Event ausgef&uuml;hrt wird.</li>
      <li>partyMode - on/off aktiviert den globalen Partymodus,alle Roll&auml;den welche das Attribut ASC_Partymode bei sich auf on gestellt haben werden nicht mehr gesteuert. Der letzte Schaltbefehle welcher durch ein Fensterevent oder Bewohnerstatus an die Roll&auml;den gesendet wurde,wird beim off setzen durch set ASC-Device partyMode off ausgef&uuml;hrt</li>
      <li>lockOut - on/off f&uuml;r das aktivieren des Aussperrschutzes gem&auml;&szlig; dem entsprechenden Attribut ASC_lock-out im jeweiligen Rolladen. (siehe Beschreibung bei den Attributen f&uuml;r die Rolladendevices)</li>
      <li>room_... - Auflistung aller Roll&auml;den welche in den jeweiligen R&auml;men gefunden wurde,Bsp.: room_Schlafzimmer,Terrasse</li>
      <li>state - Status des Devices active,enabled,disabled</li>
      <li>sunriseTimeWeHoliday - on/off wird das Rolladen Device Attribut Attributes ASC_Time_Up_WE_Holiday Beachtet oder nicht</li>
      <li>userAttrList - Status der UserAttribute welche an die Roll&auml;den gesendet werden</li>
    </ul><br>
    In den Roll&auml;den Devices
    <ul>
      <li>ASC_Time_DriveUp - Sonnenaufgangszei f&uuml;r das Rollo</li>
      <li>ASC_Time_DriveDown - Sonnenuntergangszeit f&uuml;r das Rollo</li>
    </ul>
  </ul>
  <br><br>
  <a name="AutoShuttersControlSet"></a>
  <b>Set</b>
  <ul>
    <li>partyMode - on/off aktiviert den globalen Partymodus. Siehe Reading partyMode</li>
    <li>lockOut - on/off aktiviert den globalen Aussperrschutz. Siehe Reading partyMode</li>
    <li>renewSetSunriseSunsetTimer - erneuert bei allen Roll&auml;den die Zeiten f&uuml;r Sunset und Sunrise und setzt die internen Timer neu.</li>
    <li>scanForShutters - sucht alle FHEM Devices mit dem Attribut "AutoShuttersControl" 1/2</li>
    <li>sunriseTimeWeHoliday - on/off aktiviert/deaktiviert die Beachtung des Rolladen Device Attributes ASC_Time_Up_WE_Holiday</li>
    <li>createNewNotifyDev - Legt die interne Struktur f&uuml;r NOTIFYDEV neu an</li>
    <li>selfDefense - on/off,aktiviert/deaktiviert den Selbstschutz,wenn das Residents Device absent meldet und selfDefense aktiv ist und ein Fenster im Haus steht noch offen,wird an diesem Fenster das Rollo runter gefahren</li>
  </ul>
  <br><br>
  <a name="AutoShuttersControlGet"></a>
  <b>Get</b>
  <ul>
    <li>showShuttersInformations - zeigt eine &Uuml;bersicht der Autofahrzeiten</li>
    <li>showNotifyDevsInformations - zeigt eine &Uuml;bersicht der abgelegten NOTIFYDEV Struktur. Diehnt zur Kontrolle</li>
  </ul>
  <br><br>
  <a name="AutoShuttersControlAttributes"></a>
  <b>Attributes</b>
  <ul>
  Im Modul Device
    <ul>
      <li>ASC_antifreezeTemp - Temperatur ab welcher der Frostschutz greifen soll und das Rollo nicht mehr f&auml;hrt. Der letzte Fahrbefehl wird gespeichert.</li>
      <li>ASC_autoAstroModeEvening - aktuell REAL,CIVIL,NAUTIC,ASTRONOMIC</li>
      <li>ASC_autoAstroModeEveningHorizon - H&ouml;he &uuml;ber Horizont wenn beim Attribut ASC_autoAstroModeEvening HORIZON ausgew&auml;hlt</li>
      <li>ASC_autoAstroModeMorning - aktuell REAL,CIVIL,NAUTIC,ASTRONOMIC</li>
      <li>ASC_autoAstroModeMorningHorizon - H&ouml;he &uuml;ber Horizont wenn beim Attribut ASC_autoAstroModeMorning HORIZON ausgew&auml;hlt</li>
      <li>ASC_autoShuttersControlComfort - on/off schaltet die Komfortfunktion an. Bedeutet das ein Rolladen mit einem threestate Sensor am Fenster beim &ouml;ffnen in eine weit offen Position  f&auml;hrt. Die Offenposition wird beim Rolladen &uuml;ber das Attribut ASC_Pos_after_ComfortOpen eingestellt.</li>
      <li>ASC_autoShuttersControlEvening - on/off,ob Abends die Roll&auml;den automatisch nach Zeit gesteuert werden sollen</li>
      <li>ASC_autoShuttersControlMorning - on/off,ob Morgens die Roll&auml;den automatisch nach Zeit gesteuert werden sollen</li>
      <li>ASC_temperatureReading - Reading f&uuml;r die Aussentemperatur</li>
      <li>ASC_temperatureSensor - Device f&uuml;r die Aussentemperatur</li>
      <li>ASC_timeUpHolidayDevice - Device zur Urlaubserkennung oder Sonstiges / muss 0 oder 1 im Reading state beinhalten.</li>
      <li>ASC_residentsDevice - Devicenamen vom Residents Device der obersten Ebene</li>
      <li>ASC_residentsDeviceReading - Status Reading vom Residents Device der obersten Ebene</li>
      <li>ASC_brightnessMinVal - minimaler Lichtwert ab welchen Schaltbedingungen gepr&uuml;ft werden sollen</li>
      <li>ASC_brightnessMaxVal - maximaler Lichtwert ab welchen Schaltbedingungen gepr&uuml;ft werden sollen</li>
    </ul><br>
    In den Roll&auml;den Devices
    <ul>
      <li>AutoShuttersControl - 0/1/2 1 = "Inverse oder Rollo Bsp.: Rollo Oben 0,Rollo Unten 100 und der Befehl zum Prozentualen fahren ist position",2 = "Homematic Style Bsp.: Rollo Oben 100,Rollo Unten 0 und der Befehl zum Prozentualen fahren ist pct</li>
      <li>ASC_Antifreeze - on/off Frostschutz an oder aus</li>
      <li>ASC_AutoAstroModeEvening - aktuell REAL,CIVIL,NAUTIC,ASTRONOMIC</li>
      <li>ASC_AutoAstroModeEveningHorizon - H&ouml;he &uuml;ber Horizont wenn beim Attribut ASC_autoAstroModeEvening HORIZON ausgew&auml;hlt</li>
      <li>ASC_AutoAstroModeMorning - aktuell REAL,CIVIL,NAUTIC,ASTRONOMIC</li>
      <li>ASC_AutoAstroModeMorningHorizon - H&ouml;he &uuml;ber Horizont wenn beim Attribut ASC_autoAstroModeMorning HORIZON ausgew&auml;hlt</li>
      <li>ASC_Closed_Pos - in 10 Schritten von 0 bis 100,default Vorgabe ist abh&auml;ngig vom Attribut AutoShuttersControl</li>
      <li>ASC_Down - astro/time/brightness bei Astro wird Sonnenuntergang berechnet,bei time wird der Wert aus ASC_Time_Down_Early als Fahrzeit verwendet und bei brightness muss ASC_Time_Down_Early und ASC_Time_Down_Late korrekt gesetzt werden. Der Timer l&auml;uft dann nach ASC_Time_Down_Late Zeit,es wird aber in der Zeit zwischen ASC_Time_Down_Early und ASC_Time_Down_Late geschaut ob die als Attribut im Moduldevice hinterlegte ASC_brightnessMinVal erreicht wurde,wenn ja wird der Rolladen runter gefahren</li>
      <li>ASC_Mode_Down - always/absent/off wann darf die Automatik steuern. immer,niemals,bei abwesenheit des Roomate (ist kein Roommate und absent eingestellt wird gar nicht gesteuert)</li>
      <li>ASC_Mode_Up - always/absent/off wann darf die Automatik steuern. immer,niemals,bei abwesenheit des Roomate (ist kein Roommate und absent eingestellt wird gar nicht gesteuert)</li>
      <li>ASC_Offset_Minutes_Evening - maximale zufällige Verzögerung in Minuten (minimal 1) bei der Berechnung der Fahrzeiten für Abends</li>
      <li>ASC_Offset_Minutes_Morning - maximale zufällige Verzögerung in Minuten (minimal 1) bei der Berechnung der Fahrzeiten für Morgens</li>
      <li>ASC_Open_Pos -  in 10 Schritten von 0 bis 100,default Vorgabe ist abh&auml;ngig vom Attribut AutoShuttersControl</li>
      <li>ASC_Partymode -  on/off  schaltet den Partymodus an oder aus,Wird dann am ASC Device set ASC-DEVICE partyMode on geschalten,werden alle Fahrbefehle an den Roll&auml;den welche das Attribut auf on haben zwischen gespeichert und sp&auml;ter erst ausgef&uuml;hrt</li>
      <li>ASC_Pos_Cmd - der set Befehl um den Rolladen in Prozent Angaben zu fahren,muss der selbe sein wie das Reading welches die Position des Rolladen in Prozent an gibt</li>
      <li>ASC_Pos_after_ComfortOpen - in 10 Schritten von 0 bis 100,default Vorgabe ist abh&auml;ngig vom Attribut AutoShuttersControl</li>
      <li>ASC_Roommate_Reading - das Reading zum Roommate Device welches den Status wieder gibt</li>
      <li>ASC_Roommate_Device - mit Komma getrennte Namen des/der Roommate Device/s welche den/die Bewohner des Raumes vom Rolladen wieder gibt</li>
      <li>ASC_Time_Down_Early - Sunset frühste Zeit zum runter fahren</li>
      <li>ASC_Time_Down_Late - Sunset späteste Zeit zum runter fahren</li>
      <li>ASC_Time_Up_Early - Sunrise frühste Zeit zum hoch fahren</li>
      <li>ASC_Time_Up_Late - Sunrise späteste Zeit zum hoch fahren</li>
      <li>ASC_Time_Up_WE_Holiday - Sunrise fr&uuml;hste Zeit zum hochfahren am Wochenende und/oder Urlaub (we2holiday wird beachtet),Achtung sollte nicht gr&ouml;&szlig;er sein wie ASC_Time_Up_Late sonst wird ASC_Time_Up_Late verwendet</li>
      <li>ASC_Up - astro/time/brightness bei Astro wird Sonnenaufgang berechnet,bei time wird der Wert aus ASC_Time_Up_Early als Fahrzeit verwendet und bei brightness muss ASC_Time_Up_Early und ASC_Time_Up_Late korrekt gesetzt werden. Der Timer l&auml;uft dann nach ASC_Time_Up_Late Zeit,es wird aber in der Zeit zwischen ASC_Time_Up_Early und ASC_Time_Up_Late geschaut ob die als Attribut im Moduldevice hinterlegte ASC_brightnessMinVal erreicht wurde,wenn ja wird der Rolladen runter gefahren</li>
      <li>ASC_Ventilate_Pos -  in 10 Schritten von 0 bis 100,default Vorgabe ist abh&auml;ngig vom Attribut AutoShuttersControl</li>
      <li>ASC_Ventilate_Window_Open - auf l&uuml;ften,wenn das Fenster gekippt/ge&ouml;ffnet wird und aktuelle Position unterhalb der L&uuml;ften-Position ist</li>
      <li>ASC_WindowRec - Name des Fensterkontaktes an welchen Fenster der Rolladen angebracht ist</li>
      <li>ASC_WindowRec_subType - Typ des verwendeten Fensterkontakts: twostate (optisch oder magnetisch) oder threestate (Drehgriffkontakt)</li>
      <li>ASC_lock-out - soft/hard stellt entsprechend den Aussperrschutz ein. Bei global aktiven Aussperrschutz (set ASC-Device lockOut soft) und einem Fensterkontakt open bleibt dann der Rolladen oben. Dies gilt nur bei Steuerbefehle über das ASC Modul. Stellt man global auf hard,wird bei entsprechender M&ouml;glichkeit versucht den Rolladen Hardwareseitig zu blockieren. Dann ist auch ein fahren &uuml;ber die Taster nicht mehr m&ouml;glich.</li>
      <li>ASC_lock-outCmd - inhibit/blocked set Befehl für das Rolladen-Device zum Hardware sperren. Zum gesetzt werden wenn man "ASC_lock-out" auf hard setzt</li>
      <li>ASC_Self_Defense_Exclude - on/off bei on Wert wird dieser Rolladen bei aktiven Self Defense und offenen Fenster nicht runter gefahren wenn Residents absent ist.</li>
      <li>ASC_BrightnessMinVal - minimaler Lichtwert ab welchen Schaltbedingungen gepr&uuml;ft werden sollen / wird der Wert von -1 nicht ge&auml;ndert, so wird automatisch der Wert aus dem Moduldevice genommen</li>
      <li>ASC_BrightnessMaxVal - maximaler Lichtwert ab welchen Schaltbedingungen gepr&uuml;ft werden sollen / wird der Wert von -1 nicht ge&auml;ndert, so wird automatisch der Wert aus dem Moduldevice genommen</li>
    </ul>
  </ul>
</ul>

=end html_DE

=cut
