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
#  the Free Software Foundation; either version 2 of the License, or
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





package main;

use strict;
use warnings;




my $version = "0.1.52";


sub AutoShuttersControl_Initialize($) {
    my ($hash) = @_;

## Da ich mit package arbeite müssen in die Initialize für die jeweiligen hash Fn Funktionen der Funktionsname
#  und davor mit :: getrennt der eigentliche package Name des Modules
    $hash->{SetFn}      = "AutoShuttersControl::Set";
    $hash->{GetFn}      = "AutoShuttersControl::Get";
    $hash->{DefFn}      = "AutoShuttersControl::Define";
    $hash->{NotifyFn}   = "AutoShuttersControl::Notify";
    $hash->{UndefFn}    = "AutoShuttersControl::Undef";
    $hash->{AttrFn}     = "AutoShuttersControl::Attr";
    $hash->{AttrList}   = "disable:0,1 ".
                            "disabledForIntervals ".
                            "AutoShuttersControl_guestPresence:on,off ".
                            "AutoShuttersControl_temperatureSensor ".
                            "AutoShuttersControl_temperatureReading ".
                            "AutoShuttersControl_brightnessMinVal ".
                            "AutoShuttersControl_autoShuttersControlMorning:on,off ".
                            "AutoShuttersControl_autoShuttersControlEvening:on,off ".
                            "AutoShuttersControl_autoShuttersControl_Shading:on,off ".
                            "AutoShuttersControl_autoShuttersControlComfort:on,off ".
                            "AutoShuttersControl_sunPosDevice ".
                            "AutoShuttersControl_sunPosReading ".
                            "AutoShuttersControl_sunElevationDevice ".
                            "AutoShuttersControl_sunElevationReading ".
                            "AutoShuttersControl_residentsDevice ".
                            "AutoShuttersControl_residentsDeviceReading ".
                            "AutoShuttersControl_autoAstroModeMorning:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON ".
                            "AutoShuttersControl_autoAstroModeMorningHorizon:-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9 ".
                            "AutoShuttersControl_autoAstroModeEvening:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON ".
                            "AutoShuttersControl_autoAstroModeEveningHorizon:-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9 ".
                            "AutoShuttersControl_antifreezeTemp:-5,-4,-3,-2,-1,0,1,2,3,4,5 ".
                            "AutoShuttersControl_timeUpHolidayDevice ".
                            $readingFnAttributes;

## Ist nur damit sich bei einem reload auch die Versionsnummer erneuert.
    foreach my $d(sort keys %{$modules{AutoShuttersControl}{defptr}}) {
        my $hash = $modules{AutoShuttersControl}{defptr}{$d};
        $hash->{VERSION}    = $version;
    }
}



## unserer packagename der Funktion
package AutoShuttersControl;


use strict;
use warnings;
use POSIX;

use GPUtils qw(:all);  # wird für den Import der FHEM Funktionen aus der fhem.pl benötigt
use Data::Dumper;      #only for Debugging
use Date::Parse;

my $missingModul = "";


## Import der FHEM Funktionen
BEGIN {

    GP_Import(qw(
        devspec2array
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
        ReplaceEventMap
    ))
};



## Die Attributsliste welche an die Rolläden verteilt wird. Zusammen mit Default Werten
my %userAttrList =  (   'AutoShuttersControl_Mode_Up:absent,always,off'                                                     =>  'always',
                        'AutoShuttersControl_Mode_Down:absent,always,off'                                                   =>  'always',
                        'AutoShuttersControl_Up:time,astro'                                                                 =>  'astro',
                        'AutoShuttersControl_Down:time,astro'                                                               =>  'astro',
                        'AutoShuttersControl_AutoAstroModeMorning:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON'                     =>  'none',
                        'AutoShuttersControl_AutoAstroModeMorningHorizon:-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9'    =>  'none',
                        'AutoShuttersControl_AutoAstroModeEvening:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON'                     =>  'none',
                        'AutoShuttersControl_AutoAstroModeEveningHorizon:-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9'    =>  'none',
                        'AutoShuttersControl_Open_Pos:0,10,20,30,40,50,60,70,80,90,100'                                     =>  ['',0,100],
                        'AutoShuttersControl_Closed_Pos:0,10,20,30,40,50,60,70,80,90,100'                                   =>  ['',100,0],
                        'AutoShuttersControl_Pos_Cmd'                                                                       =>  ['','position','pct'],
                        'AutoShuttersControl_Direction'                                                                     =>  178,
                        'AutoShuttersControl_Time_Up_Early'                                                                 =>  '04:30:00',
                        'AutoShuttersControl_Time_Up_Late'                                                                  =>  '09:00:00',
                        'AutoShuttersControl_Time_Up_WE_Holiday'                                                            =>  '08:30:00',
                        'AutoShuttersControl_Time_Down_Early'                                                               =>  '15:30:00', 
                        'AutoShuttersControl_Time_Down_Late'                                                                =>  '22:30:00',
                        'AutoShuttersControl_Rand_Minutes'                                                                  =>  20,
                        'AutoShuttersControl_WindowRec'                                                                     =>  'none',
                        'AutoShuttersControl_Ventilate_Window_Open:on,off'                                                  =>  'on',
                        'AutoShuttersControl_lock-out:soft,hard'                                                            =>  'soft',
                        'AutoShuttersControl_lock-outCmd:inhibit,blocked'                                                   =>  'none',
                        'AutoShuttersControl_Shading_Pos:10,20,30,40,50,60,70,80,90,100'                                    =>  30,
                        'AutoShuttersControl_Shading:on,off,delayed,present,absent'                                         =>  'off',
                        'AutoShuttersControl_Shading_Pos_after_Shading:-1,0,10,20,30,40,50,60,70,80,90,100'                 =>  -1,
                        'AutoShuttersControl_Shading_Angle_Left:0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90'     =>  85,
                        'AutoShuttersControl_Shading_Angle_Right:0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90'    =>  85,
                        'AutoShuttersControl_Shading_Brightness_Sensor'                                                     =>  'none',
                        'AutoShuttersControl_Shading_Brightness_Reading'                                                    =>  'brightness',
                        'AutoShuttersControl_Shading_StateChange_Sunny'                                                     =>  '6000',
                        'AutoShuttersControl_Shading_StateChange_Cloudy'                                                    =>  '4000',
                        'AutoShuttersControl_Shading_WaitingPeriod'                                                         =>  20,
                        'AutoShuttersControl_Shading_Min_Elevation'                                                         =>  'none',
                        'AutoShuttersControl_Shading_Min_OutsideTemperature'                                                =>  18,
                        'AutoShuttersControl_Shading_BlockingTime_After_Manual'                                             =>  20,
                        'AutoShuttersControl_Shading_BlockingTime_Twilight'                                                 =>  45,
                        'AutoShuttersControl_Shading_Fast_Open:on,off'                                                      =>  'none',
                        'AutoShuttersControl_Shading_Fast_Close:on,off'                                                     =>  'none',
                        'AutoShuttersControl_Offset_Minutes_Morning'                                                        =>  1,
                        'AutoShuttersControl_Offset_Minutes_Evening'                                                        =>  1,
                        'AutoShuttersControl_WindowRec_subType:twostate,threestate'                                         =>  'twostate',
                        'AutoShuttersControl_Ventilate_Pos:10,20,30,40,50,60,70,80,90,100'                                  =>  ['',70,30],
                        'AutoShuttersControl_Pos_after_ComfortOpen:0,10,20,30,40,50,60,70,80,90,100'                        =>  ['',20,80],
                        'AutoShuttersControl_GuestRoom:on,off'                                                              =>  'none',
                        'AutoShuttersControl_Antifreeze:off,on'                                                             =>  'off',
                        'AutoShuttersControl_Partymode:on,off'                                                              =>  'off',
                        'AutoShuttersControl_Roommate_Device'                                                               =>  'none',
                        'AutoShuttersControl_Roommate_Reading'                                                              =>  'state',
                    );





sub Define($$) {

    my ( $hash, $def ) = @_;
    my @a = split( "[ \t][ \t]*", $def );
    
    return "only one AutoShuttersControl instance allowed" if( devspec2array('TYPE=AutoShuttersControl') > 1 ); # es wird geprüft ob bereits eine Instanz unseres Modules existiert, wenn ja wird abgebrochen
    return "too few parameters: define <name> ShuttersControl" if( @a != 2 );
    return "Cannot define ShuttersControl device. Perl modul ${missingModul}is missing." if ( $missingModul );  # Abbruch wenn benötigte Hilfsmodule nicht vorhanden sind / vorerst unwichtig
    

    my $name                    = $a[0];

    $hash->{VERSION}            = $version;
    $hash->{MID}                = 'da39a3ee5e6b4b0d3255bfef95601890afd80709';   # eine Ein Eindeutige ID für interne FHEM Belange / nicht weiter wichtig
    $hash->{NotifyOrderPrefix}  = "51-";                                        # Order Nummer für NotifyFn
    $hash->{NOTIFYDEV}          = "global,".$name;                              # Liste aller Devices auf deren Events gehört werden sollen
    

    readingsSingleUpdate($hash,"state","please set attribut 'AutoShuttersControl' with value 1 or 2 to all your auto controlled shutters and then do 'set DEVICENAME scanForShutters", 1);
    CommandAttr(undef,$name . ' room AutoShuttersControl') if( AttrVal($name,'room','none') eq 'none' );
    CommandAttr(undef,$name . ' icon fts_shutter_automatic') if( AttrVal($name,'icon','none') eq 'none' );
    CommandAttr(undef,$name . ' AutoShuttersControl_autoAstroModeEvening REAL') if( AttrVal($name,'AutoShuttersControl_autoAstroModeEvening','none') eq 'none' );
    CommandAttr(undef,$name . ' AutoShuttersControl_autoAstroModeMorning REAL') if( AttrVal($name,'AutoShuttersControl_autoAstroModeMorning','none') eq 'none' );
    CommandAttr(undef,$name . ' AutoShuttersControl_autoShuttersControlMorning on') if( AttrVal($name,'AutoShuttersControl_autoShuttersControlMorning','none') eq 'none' );
    CommandAttr(undef,$name . ' AutoShuttersControl_autoShuttersControlEvening on') if( AttrVal($name,'AutoShuttersControl_autoShuttersControlEvening','none') eq 'none' );
    CommandAttr(undef,$name . ' AutoShuttersControl_temperatureReading temperature') if( AttrVal($name,'AutoShuttersControl_temperatureReading','none') eq 'none' );
    CommandAttr(undef,$name . ' AutoShuttersControl_antifreezeTemp 3') if( AttrVal($name,'AutoShuttersControl_antifreezeTemp','none') eq 'none' );
    
    addToAttrList('AutoShuttersControl:0,1,2');
    
    
    Log3 $name, 3, "AutoShuttersControl ($name) - defined";
    
    $modules{AutoShuttersControl}{defptr}{$hash->{MID}} = $hash;
    
    return undef;
}

sub Undef($$) {

    my ($hash,$arg) = @_;
    
    
    my $name = $hash->{NAME};
    
    UserAttributs_Readings_ForShutters($hash,'del');          # es sollen alle Attribute und Readings in den Rolläden Devices gelöscht werden welche vom Modul angelegt wurden
    delFromAttrList('AutoShuttersControl:0,1,2');
    
    delete($modules{AutoShuttersControl}{defptr}{$hash->{MID}});
    
    Log3 $name, 3, "AutoShuttersControl ($name) - delete device $name";
    return undef;
}

sub Attr(@) {

    my ( $cmd, $name, $attrName, $attrVal ) = @_;
    my $hash                                = $defs{$name};


    if( $attrName eq "disable" ) {
        if( $cmd eq "set" and $attrVal eq "1" ) {
            #RemoveInternalTimer($hash);
            
            #readingsSingleUpdate ( $hash, "state", "disabled", 1 );
            Log3 $name, 3, "AutoShuttersControl ($name) - disabled";
        }

        elsif( $cmd eq "del" ) {
            Log3 $name, 3, "AutoShuttersControl ($name) - enabled";
        }
    }
    
    elsif( $attrName eq "disabledForIntervals" ) {
        if( $cmd eq "set" ) {
            return "check disabledForIntervals Syntax HH:MM-HH:MM or 'HH:MM-HH:MM HH:MM-HH:MM ...'"
            unless($attrVal =~ /^((\d{2}:\d{2})-(\d{2}:\d{2})\s?)+$/);
            Log3 $name, 3, "AutoShuttersControl ($name) - disabledForIntervals";
            #readingsSingleUpdate ( $hash, "state", "disabled", 1 );
        }
        
        elsif( $cmd eq "del" ) {
            Log3 $name, 3, "AutoShuttersControl ($name) - enabled";
            #readingsSingleUpdate ( $hash, "state", "active", 1 );
        }
    }
    
    return undef;
}

sub Notify($$) {

    my ($hash,$dev) = @_;
    my $name = $hash->{NAME};
    return if (IsDisabled($name));

    
    my $devname = $dev->{NAME};
    my $devtype = $dev->{TYPE};
    my $events = deviceEvents($dev,1);
    return if (!$events);

    Log3 $name, 5, "AutoShuttersControl ($name) - Devname: ".$devname." Name: ".$name." Notify: ".Dumper $events;       # mit Dumper


    if( (grep /^DEFINED.$name$/,@{$events}
        and $devname eq 'global'
        and $init_done)
        or (grep /^INITIALIZED$/,@{$events}
        or grep /^REREADCFG$/,@{$events}
        or grep /^MODIFIED.$name$/,@{$events})
        and $devname eq 'global') {

            readingsSingleUpdate($hash,'partyMode','off',0) if(ReadingsVal($name,'partyMode','none') eq 'none');
            readingsSingleUpdate($hash,'lockOut','off',0) if(ReadingsVal($name,'lockOut','none') eq 'none');
            readingsSingleUpdate($hash,'sunriseTimeWeHoliday','off',0) if(ReadingsVal($name,'sunriseTimeWeHoliday','none') eq 'none');
            
            ## Ist der Event ein globaler und passt zum Rest der Abfrage oben wird nach neuen Rolläden Devices gescannt und eine Liste im Rolladenmodul sortiert nach Raum generiert
            ShuttersDeviceScan($hash)
            unless( ReadingsVal($name,'userAttrList','none') eq 'none');
    
    } 
    
    return unless( ref($hash->{helper}{shuttersList}) eq 'ARRAY' and scalar(@{$hash->{helper}{shuttersList}}) > 0);
    
    if( $devname eq $name ) {
        if( grep /^userAttrList:.rolled.out$/,@{$events} ) {
            unless( scalar(@{$hash->{helper}{shuttersList}} ) == 0 ) {
                WriteReadingsShuttersList($hash);
                UserAttributs_Readings_ForShutters($hash,'add');
                InternalTimer(gettimeofday() + 3,'AutoShuttersControl::RenewSunRiseSetShuttersTimer',$hash);
            }
            
        } elsif( grep /^partyMode:.off$/,@{$events} ) {
            PartyModeEventProcessing($hash);
        
        } elsif( grep /^sunriseTimeWeHoliday:.(on|off)$/,@{$events} ) {
            RenewSunRiseSetShuttersTimer($hash);
        }

    } elsif( $devname eq "global" ) {           # Kommt ein globales Event und beinhaltet folgende Syntax wird die Funktion zur Verarbeitung aufgerufen
        if( grep /^(ATTR|DELETEATTR)\s(.*AutoShuttersControl_Roommate_Device|.*AutoShuttersControl_WindowRec)(\s.*|$)/,@{$events}) {
            GeneralEventProcessing($hash,undef,join(' ',@{$events}));
        
        } elsif(grep /^(ATTR|DELETEATTR)\s(.*AutoShuttersControl_Time_Up_WE_Holiday)(\s.*|$)/,@{$events}) {
            RenewSunRiseSetShuttersTimer($hash)
                unless( ReadingsVal($name,'sunriseTimeWeHoliday','off') eq 'off' );
        }
        
    } else {
        GeneralEventProcessing($hash,$devname,join(' ',@{$events}));            # bei allen anderen Events wird die entsprechende Funktion zur Verarbeitung aufgerufen
    }

    return;
}

sub GeneralEventProcessing($$$) {

    my ($hash,$devname,$events)  = @_;
    my $name            = $hash->{NAME};


    if( defined($devname) and ($devname) ) {                # es wird lediglich der Devicename der Funktion mitgegeben wenn es sich nicht um global handelt daher hier die Unterschiedung
    
        my ($notifyDevHash)    = ExtractNotifyDevfromReadingString($hash,$devname);     # da wir nicht wissen im welchen Zusammenhang das Device, welches das Event ausgelöst hat, mit unseren Attributen steht lesen wir ein spezielles Reading aus dessen Wert einen bestimmten Aufbau hat und uns sagen kann ob es ein Fenster oder ein Bewohner oder sonst was für ein Device ist.
        Log3 $name, 4, "AutoShuttersControl ($name) - EventProcessing: " . $notifyDevHash->{$devname};
        
        foreach(@{$notifyDevHash->{$devname}}) {        # Wir lesen nun alle Einträge aus welche dieses Device betreffen. Kann ja mehrere Rolläden betreffen.

            WindowRecEventProcessing($hash,(split(':',$_))[0],$events) if( (split(':',$_))[1] eq 'AutoShuttersControl_WindowRec' );     # ist es ein Fensterdevice wird die Funktion gestartet
            RoommateEventProcessing($hash,(split(':',$_))[0],$events) if( (split(':',$_))[1] eq 'AutoShuttersControl_Roommate_Device' );    # ist es ein Bewohner Device wird diese Funktion gestartet
        
        
        
            Log3 $name, 4, "AutoShuttersControl ($name) - EventProcessing Hash Array: " . $_;
        }
    } else {        # alles was kein Devicenamen mit übergeben hat landet hier

        if( $events =~ m#^ATTR\s(.*)\s(AutoShuttersControl_Roommate_Device|AutoShuttersControl_WindowRec)\s(.*)$# ) {       # wurde den Attributen unserer Rolläden ein Wert zugewiesen ?
            AddNotifyDev($hash,$3,$1 . ':' . $2 . ':' . $3);
            Log3 $name, 4, "AutoShuttersControl ($name) - EventProcessing: ATTR";
        } elsif($events =~ m#^DELETEATTR\s(.*AutoShuttersControl_Roommate_Device|.*AutoShuttersControl_WindowRec)$# ) {      # wurde das Attribut unserer Rolläden gelöscht ?
            Log3 $name, 4, "AutoShuttersControl ($name) - EventProcessing: DELETEATTR";
            DeleteNotifyDev($hash,$1);
        }
    }
}

sub Set($$@) {
    
    my ($hash, $name, @aa)  = @_;
    
    
    my ($cmd, @args)        = @aa;

    if( lc $cmd eq 'renewsetsunrisesunsettimer' ) {
        return "usage: $cmd" if( @args != 0 );
        RenewSunRiseSetShuttersTimer($hash);
        
    } elsif( lc $cmd eq 'scanforshutters' ) {
        return "usage: $cmd" if( @args != 0 );
        
        ShuttersDeviceScan($hash);
        
    } elsif( lc $cmd eq 'partymode' ) {
        return "usage: $cmd" if( @args > 1 );
        
        readingsSingleUpdate($hash, "partyMode", join(' ',@args), 1);
        
    } elsif( lc $cmd eq 'lockout' ) {
        return "usage: $cmd" if( @args > 1 );
        
        readingsSingleUpdate($hash, "lockOut", join(' ',@args), 1);
        SetHardewareBlockForShutters($hash,join(' ',@args));
        
    } elsif( lc $cmd eq 'sunrisetimeweholiday' ) {
        return "usage: $cmd" if( @args > 1 );
        
        readingsSingleUpdate($hash, "sunriseTimeWeHoliday", join(' ',@args), 1);
    
    } else {
        my $list = "scanForShutters:noArg";
        $list .= " renewSetSunriseSunsetTimer:noArg partyMode:on,off lockOut:on,off sunriseTimeWeHoliday:on,off" if( ReadingsVal($name,'userAttrList',0) eq 'rolled out');
        
        return "Unknown argument $cmd, choose one of $list";
    }
    
    return undef;
}

sub Get($$@) {
    
    my ($hash, $name, @aa)  = @_;
    
    
    my ($cmd, @args)        = @aa;

    if( lc $cmd eq 'showshuttersinformations' ) {
        return "usage: $cmd" if( @args != 0 );

        my $ret = GetShuttersInformation($hash);
        return $ret;

    } else {
        my $list = "";
        $list .= " showShuttersInformations:noArg" if( ReadingsVal($name,'userAttrList','none') eq 'rolled out' );

        return "Unknown argument $cmd, choose one of $list";
    }
}

sub ShuttersDeviceScan($) {

    my $hash    = shift;
    my $name    = $hash->{NAME};
    
    
    delete $hash->{helper}{shuttersList};

    my @list;
    @list = devspec2array('AutoShuttersControl=[1-2]');

    CommandDeleteReading(undef,$name . ' .*_nextAstroTimeEvent');
    CommandDeleteReading(undef,$name . ' .*_lastDelayPosValue');
    CommandDeleteReading(undef,$name . ' .*_lastPosValue');
    unless( scalar(@list) > 0 ) {
        readingsBeginUpdate($hash);
        readingsBulkUpdate($hash,'userAttrList','none');
        readingsBulkUpdate($hash,'state','no shutters found');
        readingsEndUpdate($hash,1);
        return;
    }

    foreach(@list) {
        push (@{$hash->{helper}{shuttersList}},$_);             ## einem Hash wird ein Array zugewiesen welches die Liste der erkannten Rollos beinhaltet
        #AddNotifyDev($hash,$_);        # Vorerst keine Shutters in NOTIFYDEV
    }


    if( ReadingsVal($name,'.monitoredDevs','none') ne 'none' ) {             # Dieses besondere Reading ist so aufgebaut das egal wie der Devicename bei einem Event lautet dieses Device nach seiner Funktionalität in FHEM zugeordnet werden kann

        # Der Aufbau des Strings im Reading monitoredDevs sieht so aus Rolloname:Attributname:Wert_desAttributes
        # Wert des Attributes beinhaltet in diesem Fall immer den Devcenamen von dem auch Events von unserem Modul getriggert werden sollen.
        my ($notifyDevHash)    = ExtractNotifyDevfromReadingString($hash,undef);        # in der Funktion wird aus dem String ein Hash wo wir über den Devicenamen z.B. FensterLinks ganz einfach den Rest des Strings heraus bekommen. Also welches Rollo und welches Attribut. So wissen wir das es sich um ein Fenster handelt und dem Rollo bla bla zu geordnet wird.

        my $notifyDevString = $hash->{NOTIFYDEV};
        
        while( my  (undef,$notifyDev) = each %{$notifyDevHash}) {
        
            $notifyDevString .= ',' . $notifyDev unless( $notifyDevString =~ /$notifyDev/ );

            Log3 $name, 5, "AutoShuttersControl ($name) - NotifyDev: " . $notifyDev . ", NotifyDevString: " . $notifyDevString;
        }

        $hash->{NOTIFYDEV}  = $notifyDevString;
    }

    
    readingsSingleUpdate($hash,'userAttrList','rolled out',1);
}

## Die Funktion schreibt in das Moduldevice Readings welche Rolläden in welchen Räumen erfasst wurden.
sub WriteReadingsShuttersList($) {

    my $hash    = shift;
    my $name    = $hash->{NAME};


    CommandDeleteReading(undef,$name . ' room_.*');
    
    readingsBeginUpdate($hash);
    
    foreach (@{$hash->{helper}{shuttersList}}) {
    
        readingsBulkUpdate($hash,'room_' . makeReadingName(AttrVal($_,'room','unsorted')),ReadingsVal($name,'room_' . makeReadingName(AttrVal($_,'room','unsorted')),'') . ', ' . $_) if( ReadingsVal($name,'room_' . makeReadingName(AttrVal($_,'room','unsorted')),'none') ne 'none' );
        
        readingsBulkUpdate($hash,'room_' . makeReadingName(AttrVal($_,'room','unsorted')),$_) if( ReadingsVal($name,'room_' . makeReadingName(AttrVal($_,'room','unsorted')),'none') eq 'none' );
    }
    
    readingsBulkUpdate($hash,'state','active');
    readingsEndUpdate($hash,0);
}

sub UserAttributs_Readings_ForShutters($$) {

    my ($hash,$cmd) = @_;
    my $name        = $hash->{NAME};

    
    while( my ($attrib,$attribValue) = each %{userAttrList} ) {
        foreach (@{$hash->{helper}{shuttersList}}) {

            addToDevAttrList($_,$attrib);       ## fhem.pl bietet eine Funktion um ein userAttr Attribut zu befüllen. Wir schreiben also in den Attribut userAttr alle unsere Attribute rein. Pro Rolladen immer ein Attribut pro Durchlauf
            
            ## Danach werden die Attribute die im userAttr stehen gesetzt und mit default Werten befüllt
            if( $cmd eq 'add' ) {
                if( ref($attribValue) ne 'ARRAY' ) {
                    #CommandAttr(undef,$_ . ' ' . (split(':',$attrib))[0] . ' ' . $attribValue) if( defined($attribValue) and $attribValue and AttrVal($_,(split(':',$attrib))[0],'none') eq 'none' );
                    $attr{$_}{(split(':',$attrib))[0]}  = $attribValue if( not defined($attr{$_}{(split(':',$attrib))[0]}) );
                } else {
                    #CommandAttr(undef,$_ . ' ' . (split(':',$attrib))[0] . ' ' . $attribValue->[AttrVal($_,'AutoShuttersControl',2)]) if( defined($attribValue) and $attribValue and AttrVal($_,(split(':',$attrib))[0],'none') eq 'none' );
                    $attr{$_}{(split(':',$attrib))[0]}  = $attribValue->[AttrVal($_,'AutoShuttersControl',2)] if( not defined($attr{$_}{(split(':',$attrib))[0]}) );
                }
            ## Oder das Attribut wird wieder gelöscht.
            } elsif( $cmd eq 'del' ) {
                RemoveInternalTimer(ReadingsVal($_,'.AutoShuttersControl_InternalTimerFuncHash',0));
                CommandDeleteReading(undef,$_ . ' .?AutoShuttersControl_.*' );
                CommandDeleteAttr(undef,$_ . ' AutoShuttersControl');
                delFromDevAttrList($_,$attrib);
            }
        }
    }
}

## Fügt dem NOTIFYDEV Hash weitere Devices hinzu
sub AddNotifyDev($@) {

    my ($hash,$dev,$readingPart)    = @_;
    
    my $name                        = $hash->{NAME};
    my $readingPart3                = (split(':', $readingPart))[2];


    my $notifyDev                   = $hash->{NOTIFYDEV};
    $notifyDev                      = "" if(!$notifyDev);
    my %hash;
    
    %hash = map { ($_ => 1) }
            split(",", "$notifyDev,$readingPart3");
                
    $hash->{NOTIFYDEV}              = join(",", sort keys %hash);

    
    my $monitoredDevString          = ReadingsVal($name,'.monitoredDevs','');
    %hash = map { ($_ => 1) }
            split(",", "$monitoredDevString,$readingPart");
    readingsSingleUpdate($hash,'.monitoredDevs',(ReadingsVal($name,'.monitoredDevs','none') eq 'none' ? join("", sort keys %hash) : join(",", sort keys %hash)),0);
}

## entfernt aus dem NOTIFYDEV Hash Devices welche als Wert in Attributen steckten
sub DeleteNotifyDev($$) {

    my ($hash,$dev)     = @_;

    my $name    = $hash->{NAME};
    $dev =~ s/\s/:/g;


    my ($notifyDevHash)             = ExtractNotifyDevfromReadingString($hash,undef);
    my $devFromDevHash              = $notifyDevHash->{$dev};
    
    ##### Entfernen des gesamten Device Stringes vom Reading monitoredDevs
    my $monitoredDevString          = ReadingsVal($name,'.monitoredDevs','none');
    my $devStringAndDevFromDevHash  = $dev . ':' . $devFromDevHash;
    my %hash;
    
    %hash = map { ($_ => 1) }
            grep { " $devStringAndDevFromDevHash " !~ m/ $_ / }
            split(",", "$monitoredDevString,$devStringAndDevFromDevHash");

    readingsSingleUpdate($hash,'.monitoredDevs',join(",", sort keys %hash),0);
    
    
    ### Entfernen des Deviceeintrages aus dem NOTIFYDEV
    unless( ReadingsVal($name,'.monitoredDevs','none') =~ m#$devFromDevHash# ) {

        my $notifyDevString             = $hash->{NOTIFYDEV};
        $notifyDevString                = "" if(!$notifyDevString);

        %hash = map { ($_ => 1) }
                grep { " $devFromDevHash " !~ m/ $_ / }
                split(",", "$notifyDevString,$devFromDevHash");
                    
        $hash->{NOTIFYDEV}              = join(",", sort keys %hash);
    }
}

## Sub zum steuern der Rolläden bei einem Fenster Event
sub WindowRecEventProcessing($@) {

    my ($hash,$shuttersDev,$events)    = @_;
    
    my $name                           = $hash->{NAME};


    if($events =~ m#state:\s(open|closed|tilted)# ) {
        my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);
        my $queryShuttersPosWinRecTilted                = (ShuttersPosCmdValueNegieren($shuttersDev) ? ReadingsVal($shuttersDev,AttrVal($shuttersDev,'AutoShuttersControl_Pos_Cmd','pct'),0) > $closedPosWinRecTilted : ReadingsVal($shuttersDev,AttrVal($shuttersDev,'AutoShuttersControl_Pos_Cmd','pct'),0) < $closedPosWinRecTilted);

        
        if(ReadingsVal($shuttersDev,'.AutoShuttersControl_DelayCmd','none') ne 'none') {                # Es wird geschaut ob wärend der Fenster offen Phase ein Fahrbefehl über das Modul kam, wenn ja wird dieser aus geführt
            my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);

            ### Es wird ausgewertet ob ein normaler Fensterkontakt oder ein Drehgriff vorhanden ist. Beim normalen Fensterkontakt bedeutet ein open das selbe wie tilted beim Drehgriffkontakt.
            if( $1 eq 'closed' ) {
                ShuttersCommandSet($hash,$shuttersDev,$closedPos);

            } elsif( ($1 eq 'tilted' or ($1 eq 'open' and AttrVal($shuttersDev,'AutoShuttersControl_WindowRec_subType','twostate') eq 'twostate')) and AttrVal($shuttersDev,'AutoShuttersControl_Ventilate_Window_Open','off') eq 'on' and $queryShuttersPosWinRecTilted ) {
                ShuttersCommandSet($hash,$shuttersDev,$closedPosWinRecTilted);
            }
        } elsif( $1 eq 'closed' ) {             # wenn nicht dann wird entsprechend dem Fensterkontakt Event der Rolladen geschlossen oder zum lüften geöffnet
            ShuttersCommandSet($hash,$shuttersDev,$closedPos) if(ReadingsVal($shuttersDev,AttrVal($shuttersDev,'AutoShuttersControl_Pos_Cmd','pct'),0) == $closedPosWinRecTilted or ReadingsVal($shuttersDev,AttrVal($shuttersDev,'AutoShuttersControl_Pos_Cmd','pct'),0) == AttrVal($shuttersDev,'AutoShuttersControl_Pos_after_ComfortOpen',50));
        
        } elsif( ($1 eq 'tilted' or ($1 eq 'open' and AttrVal($shuttersDev,'AutoShuttersControl_WindowRec_subType','twostate') eq 'twostate')) and AttrVal($shuttersDev,'AutoShuttersControl_Ventilate_Window_Open','off') eq 'on' and $queryShuttersPosWinRecTilted ) {
            ShuttersCommandSet($hash,$shuttersDev,$closedPosWinRecTilted);
        
        } elsif($1 eq 'open' and AttrVal($shuttersDev,'AutoShuttersControl_WindowRec_subType','twostate') eq 'threestate' and AttrVal($name,'AutoShuttersControl_autoShuttersControlComfort','off') eq 'on') {
            ShuttersCommandSet($hash,$shuttersDev,AttrVal($shuttersDev,'AutoShuttersControl_Pos_after_ComfortOpen',50));
        }
    }
}

## Sub zum steuern der Rolladen bei einem Bewohner/Roommate Event
sub RoommateEventProcessing($@) {

    my ($hash,$shuttersDev,$events) = @_;
    
    my $name                        = $hash->{NAME};
    my $reading                     = AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Reading','state');

    
    if($events =~ m#$reading:\s(gotosleep|asleep|awoken|home)# ) {
    
        my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);

        Log3 $name, 4, "AutoShuttersControl ($name) - RoommateEventProcessing: $reading";
        Log3 $name, 4, "AutoShuttersControl ($name) - RoommateEventProcessing: $shuttersDev und Events $events";


        ShuttersCommandSet($hash,$shuttersDev,$openPos)
        if( ($1 eq 'home' or $1 eq 'awoken') and
            (ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),'lastState','none') eq 'asleep' or ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),'lastState','none') eq 'awoken')
                and AttrVal($name,'AutoShuttersControl_autoShuttersControlMorning','off') eq 'on'
                and IsDay($hash,$shuttersDev)
                and AttrVal($shuttersDev,'AutoShuttersControl_Mode_Up','off') eq 'always' );


        if( AttrVal($shuttersDev,'AutoShuttersControl_Mode_Down','off') eq 'always' and ($1 eq 'gotosleep' or $1 eq 'asleep') and AttrVal($name,'AutoShuttersControl_autoShuttersControlEvening','off') eq 'on' ) {
        
            my $position;
            if(CheckIfShuttersWindowRecOpen($shuttersDev) == 0 or AttrVal($shuttersDev,'AutoShuttersControl_Ventilate_Window_Open','on') eq 'off') {
                $position   = $closedPos;
            } else {
                $position   = $closedPosWinRecTilted;
            }
            
            ShuttersCommandSet($hash,$shuttersDev,$position)
        }
    }
}

sub PartyModeEventProcessing($) {

    my ($hash)  = @_;
    
    my $name            = $hash->{NAME};


    foreach my $shuttersDev (@{$hash->{helper}{shuttersList}}) {
        my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);
        
        if( CheckIfShuttersWindowRecOpen($shuttersDev) == 2 and AttrVal($shuttersDev,'AutoShuttersControl_WindowRec_subType','twostate') eq 'threestate') {
            Log3 $name, 4, "AutoShuttersControl ($name) - PartyModeEventProcessing Fenster offen";
            ShuttersCommandDelaySet($shuttersDev,$closedPos);
            Log3 $name, 4, "AutoShuttersControl ($name) - PartyModeEventProcessing - Spring in ShuttersCommandDelaySet";
        } else {
            Log3 $name, 4, "AutoShuttersControl ($name) - PartyModeEventProcessing Fenster nicht offen";
            ShuttersCommandSet($hash,$shuttersDev,(CheckIfShuttersWindowRecOpen($shuttersDev) == 0 ? $closedPos : $closedPosWinRecTilted));
        }
    }
}

# Sub für das Zusammensetzen der Rolläden Steuerbefehle
sub ShuttersCommandSet($$$) {

    my ($hash,$shuttersDev,$posValue)   = @_;
    my $name                            = $hash->{NAME};


    readingsBeginUpdate($hash);
    
    if( (AttrVal($shuttersDev,'AutoShuttersControl_Partymode','off') eq 'on' and ReadingsVal($hash->{NAME},'partyMode','off') eq 'on')
        or (CheckIfShuttersWindowRecOpen($shuttersDev) == 2 and AttrVal($shuttersDev,'AutoShuttersControl_WindowRec_subType','twostate') eq 'threestate' and AttrVal($name,'AutoShuttersControl_autoShuttersControlComfort','on') eq 'off')
        or (CheckIfShuttersWindowRecOpen($shuttersDev) == 2 and (AttrVal($shuttersDev,'AutoShuttersControl_lock-out','soft') eq 'soft' or AttrVal($shuttersDev,'AutoShuttersControl_lock-out','hard') eq 'hard') and ReadingsVal($shuttersDev,'lockOut','off') eq 'on')
        or (AttrVal($shuttersDev,'AutoShuttersControl_Antifreeze','off') eq 'on' and ReadingsVal(AttrVal($name,'AutoShuttersControl_temperatureSensor','none'),AttrVal($name,'AutoShuttersControl_temperatureReading','temperature'),100) <=  AttrVal($name,'AutoShuttersControl_antifreezeTemp',0)) ) {

        ShuttersCommandDelaySet($shuttersDev,$posValue);
        readingsBulkUpdateIfChanged($hash,$shuttersDev.'_lastDelayPosValue',$posValue);

    } else {

        my $posCmd   = AttrVal($shuttersDev,'AutoShuttersControl_Pos_Cmd','pct');

        CommandSet(undef,$shuttersDev . ':FILTER=' . $posCmd . '!=' . $posValue . ' ' . $posCmd . ' ' . $posValue);
        readingsSingleUpdate($defs{$shuttersDev},'.AutoShuttersControl_DelayCmd','none',0) if(ReadingsVal($shuttersDev,'.AutoShuttersControl_DelayCmd','none') ne 'none');    # setzt den Wert des Readings auf none da der Rolladen nun gesteuert werden kann. Dieses Reading setzt die Delay Funktion ShuttersCommandDelaySet
        
        readingsBulkUpdateIfChanged($hash,$shuttersDev.'_lastPosValue',$posValue);
    }
    
    readingsEndUpdate($hash,1);
}

# Sub zum späteren ausführen der Steuerbefehle für Rolläden, zum Beispiel weil Fenster noch auf ist
sub ShuttersCommandDelaySet($$) {

    my ($shuttersDev,$posValue)   = @_;

    readingsSingleUpdate($defs{$shuttersDev},'.AutoShuttersControl_DelayCmd',$posValue,0);
}

## Sub welche die InternalTimer nach entsprechenden Sunset oder Sunrise zusammen stellt
sub CreateSunRiseSetShuttersTimer($$) {

    my ($hash,$shuttersDev)     = @_;
    my $name                    = $hash->{NAME};
    my $shuttersDevHash         = $defs{$shuttersDev};

    return if( IsDisabled($name) );


    my $shuttersSunriseUnixtime = ShuttersSunrise($hash,$shuttersDev,'unix') + int(rand(TimeMin2Sec(AttrVal($shuttersDev,'AutoShuttersControl_Offset_Minutes_Morning',0))));
    my $shuttersSunsetUnixtime  = ShuttersSunset($hash,$shuttersDev,'unix') + int(rand(TimeMin2Sec(AttrVal($shuttersDev,'AutoShuttersControl_Offset_Minutes_Evening',0))));

    ## In jedem Rolladen werden die errechneten Zeiten hinterlegt, es sei denn das autoShuttersControlEvening/Morning auf off steht
    readingsBeginUpdate($shuttersDevHash);
    readingsBulkUpdate( $shuttersDevHash,'AutoShuttersControl_Time_DriveDown',(AttrVal($name,'AutoShuttersControl_autoShuttersControlEvening','off') eq 'on' ? strftime("%e.%m.%Y - %H:%M:%S",localtime($shuttersSunsetUnixtime)) : 'AutoShuttersControl off'),1 );
    readingsBulkUpdate($shuttersDevHash,'AutoShuttersControl_Time_DriveUp',(AttrVal($name,'AutoShuttersControl_autoShuttersControlMorning','off') eq 'on' ? strftime("%e.%m.%Y - %H:%M:%S",localtime($shuttersSunriseUnixtime)) : 'AutoShuttersControl off'),1 );
    readingsEndUpdate($shuttersDevHash,0);

    readingsBeginUpdate($hash);
    readingsBulkUpdateIfChanged($hash,$shuttersDev . '_nextAstroTimeEvent',($shuttersSunriseUnixtime < $shuttersSunsetUnixtime ? strftime("%e.%m.%Y - %H:%M:%S",localtime($shuttersSunriseUnixtime)) : strftime("%e.%m.%Y - %H:%M:%S",localtime($shuttersSunsetUnixtime))));
    readingsEndUpdate($hash,1);

    CommandDeleteReading(undef,$name . ' ' . $shuttersDev . '_nextAstroEvent') if( ReadingsVal($name,$shuttersDev . '_nextAstroEvent','none') ne 'none' );  # temporär
    CommandDeleteReading(undef,$shuttersDev . ' AutoShuttersControl_Time_Sunrise') if( ReadingsVal($shuttersDev,'AutoShuttersControl_Time_Sunrise','none') ne 'none' );  # temporär
    CommandDeleteReading(undef,$shuttersDev . ' AutoShuttersControl_Time_Sunset') if( ReadingsVal($shuttersDev,'AutoShuttersControl_Time_Sunset','none') ne 'none' );  # temporär


    RemoveInternalTimer(ReadingsVal($shuttersDev,'.AutoShuttersControl_InternalTimerFuncHash','none'))
        unless(ReadingsVal($shuttersDev,'.AutoShuttersControl_InternalTimerFuncHash','none') eq 'none');
    
    ## kleine Hilfe für InternalTimer damit ich alle benötigten Variablen an die Funktion übergeben kann welche von Internal Timer aufgerufen wird.
    my %funcHash = ( hash => $hash, shuttersdevice => $shuttersDev, sunsettime => $shuttersSunsetUnixtime, sunrisetime => $shuttersSunriseUnixtime);
    
    ## Ich brauche beim löschen des InternalTimer den Hash welchen ich mitgegeben habe, dieser muss gesichert werden
    readingsSingleUpdate($shuttersDevHash,'.AutoShuttersControl_InternalTimerFuncHash',\%funcHash,0);
    InternalTimer($shuttersSunsetUnixtime, 'AutoShuttersControl::SunSetShuttersAfterTimerFn',\%funcHash ) if( AttrVal($name,'AutoShuttersControl_autoShuttersControlEvening','off') eq 'on' );
    InternalTimer($shuttersSunriseUnixtime, 'AutoShuttersControl::SunRiseShuttersAfterTimerFn',\%funcHash ) if( AttrVal($name,'AutoShuttersControl_autoShuttersControlMorning','off') eq 'on' );
}

## Funktion zum neu setzen der Timer und der Readings für Sunset/Rise
sub RenewSunRiseSetShuttersTimer($) {

    my $hash    = shift;


    foreach (@{$hash->{helper}{shuttersList}}) {
        RemoveInternalTimer(ReadingsVal($_,'.AutoShuttersControl_InternalTimerFuncHash','none'));
        CommandDeleteReading(undef,$_ . ' .AutoShuttersControl_InternalTimerFuncHash' );
        CreateSunRiseSetShuttersTimer($hash,$_);
    }
}

## Funktion zum hardwareseitigen setzen des lock-out oder blocking beim Rolladen selbst
sub SetHardewareBlockForShutters($$) {

    my ($hash,$cmd) = @_;


    foreach (@{$hash->{helper}{shuttersList}}) {
        if( AttrVal($_,'AutoShuttersControl_lock-out','soft') eq 'hard' and AttrVal($_,'AutoShuttersControl_lock-outCmd','none') ne 'none' ) {
            CommandSet(undef,$_ . ' inhibit ' . $cmd) if(AttrVal($_,'AutoShuttersControl_lock-outCmd','none') eq 'inhibit');
            CommandSet(undef,$_ . ' ' . ($cmd eq 'on' ? 'blocked' : 'unblocked')) if(AttrVal($_,'AutoShuttersControl_lock-outCmd','none') eq 'blocked');
        }
    }
}

## Funktion zum hardwareseitigen setzen des lock-out oder blocking beim Rolladen selbst

## Funktion welche beim Ablaufen des Timers für Sunset aufgerufen werden soll
sub SunSetShuttersAfterTimerFn($) {

    my $funcHash                                    = shift;
    my $hash                                        = $funcHash->{hash};
    my $shuttersDev                                 = $funcHash->{shuttersdevice};
    

    my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);
    my $posValue;
    
    if( CheckIfShuttersWindowRecOpen($shuttersDev) == 0 or AttrVal($shuttersDev,'AutoShuttersControl_Ventilate_Window_Open','on') eq 'off' ) {
        $posValue                                   = $closedPos;
    } else {
        $posValue                                   =  $closedPosWinRecTilted;
    }


    ShuttersCommandSet($hash,$shuttersDev,$posValue)
        if( AttrVal($shuttersDev,'AutoShuttersControl_Mode_Down','off') eq ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Reading','none'),'home') or AttrVal($shuttersDev,'AutoShuttersControl_Mode_Down','off') eq 'always' );

    CreateSunRiseSetShuttersTimer($hash,$shuttersDev);
}

## Funktion welche beim Ablaufen des Timers für Sunrise aufgerufen werden soll
sub SunRiseShuttersAfterTimerFn($) {

    my $funcHash                                    = shift;
    my $hash                                        = $funcHash->{hash};
    my $shuttersDev                                 = $funcHash->{shuttersdevice};


    my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);
    
    if( AttrVal($shuttersDev,'AutoShuttersControl_Mode_Up','off') eq ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Reading','none'),'home') or AttrVal($shuttersDev,'AutoShuttersControl_Mode_Up','off') eq 'always' ) {
    
        ShuttersCommandSet($hash,$shuttersDev,$openPos)
            if( ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Reading','none'),'home') eq 'home' or ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Reading','none'),'awoken') eq 'awoken' );
    }
    
    CreateSunRiseSetShuttersTimer($hash,$shuttersDev);
}

sub GetShuttersInformation($) {

    my $hash    = shift;
    
    my $name    = $hash->{NAME};
    
    
    my $shuttersInformations    = ShuttersInformation($hash);

    Log3 $name, 2, "AutoShuttersControl ($name) - GetShuttersInformation Info " . $shuttersInformations->{'RolloKinZimSteven_F1'}{'Time_Sunrise'};
    
    my $ret = '<html><table><tr><td>';
    $ret .= '<table class="block wide">';
    $ret .= '<tr class="even">';
    $ret .= "<td><b>Shuttername</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>Next DriveUp</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>Next DriveDown</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>Partymode</b></td>";
    $ret .= "<td> </td>";
    $ret .= "<td><b>Lock-Out</b></td>";
    $ret .= '</tr>';
    Log3 $name, 2, "AutoShuttersControl ($name) - GetShuttersInformation - for if";
    if( ref($shuttersInformations) eq "HASH" ) {
        Log3 $name, 2, "AutoShuttersControl ($name) - GetShuttersInformation - fafter if";
        my $linecount = 1;
        foreach my $shutter (keys (%{$shuttersInformations}) ) {
            if ( $linecount % 2 == 0 ) {
                $ret .= '<tr class="even">';
            } else {
                $ret .= '<tr class="odd">';
            }

            $ret .= "<td>$shutter</td>";
            $ret .= "<td> </td>";
            $ret .= "<td>$shuttersInformations->{$shutter}{Time_DriveUp}</td>";
            $ret .= "<td> </td>";
            $ret .= "<td>$shuttersInformations->{$shutter}{Time_DriveDown}</td>";
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

    my $hash    = shift;


    my %shuttersInformations    = ();

    foreach (@{$hash->{helper}{shuttersList}}) {
        $shuttersInformations{$_}{'Time_DriveUp'}   = ReadingsVal($_,'AutoShuttersControl_Time_DriveUp','none');
        $shuttersInformations{$_}{'Time_DriveDown'}    = ReadingsVal($_,'AutoShuttersControl_Time_DriveDown','none');
        $shuttersInformations{$_}{'Partymode'}      = AttrVal($_,'AutoShuttersControl_Partymode','none');
        $shuttersInformations{$_}{'Lock-Out'}       = AttrVal($_,'AutoShuttersControl_lock-out','none');
    }

    return \%shuttersInformations;
}









#################################
## my little helper
#################################

# Hilfsfunktion welche meinen ReadingString zum finden der getriggerten Devices und der Zurdnung was das Device überhaupt ist und zu welchen Rolladen es gehört aus liest und das Device extraiert
sub ExtractNotifyDevfromReadingString($$) {

    my ($hash,$dev) = @_;


    my %notifyDevString;
    
    my @notifyDev = split(',',ReadingsVal($hash->{NAME},'.monitoredDevs','none'));

    if( defined($dev) ) {
        foreach my $notifyDev (@notifyDev) {
            Log3 $hash->{NAME}, 4, "AutoShuttersControl ($hash->{NAME}) - ExtractNotifyDevfromReadingString: " . (split(':',$notifyDev))[2].'-'.(split(':',$notifyDev))[0].':'.(split(':',$notifyDev))[1];
            $notifyDevString{(split(':',$notifyDev))[2]}    = [] unless( ref($notifyDevString{(split(':',$notifyDev))[2]}) eq "ARRAY" );
            push (@{$notifyDevString{(split(':',$notifyDev))[2]}},(split(':',$notifyDev))[0].':'.(split(':',$notifyDev))[1]) unless( $dev ne (split(':',$notifyDev))[2] );
        }

    } else {
        foreach my $notifyDev (@notifyDev) {
            $notifyDevString{(split(':',$notifyDev))[0].':'.(split(':',$notifyDev))[1]}    = (split(':',$notifyDev))[2];
        }
    }

    return \%notifyDevString;
}

## Attribute aud den Rolladen auslesen welche zum Steuern des Rolladen wichtig sind
sub ShuttersReadAttrForShuttersControl($) {

    my $shuttersDev                      = shift;
    
    my $shuttersOpenValue               = AttrVal($shuttersDev,'AutoShuttersControl_Open_Pos',0);
    my $shuttersClosedValue             = AttrVal($shuttersDev,'AutoShuttersControl_Closed_Pos',100);
    my $shuttersClosedByWindowRecTilted = AttrVal($shuttersDev,'AutoShuttersControl_Ventilate_Pos',80);

    return ($shuttersOpenValue,$shuttersClosedValue,$shuttersClosedByWindowRecTilted);
}

## Ist Tag oder Nacht für den entsprechende Rolladen
sub IsDay($$) {

    my ($hash,$shuttersDev) = @_;
    
    my $name                = $hash->{NAME};


    return (ShuttersSunrise($hash,$shuttersDev,'unix') > ShuttersSunset($hash,$shuttersDev,'unix') ? 1 : 0);
}

sub ShuttersSunrise($$$) {

    my ($hash,$shuttersDev,$tm) = @_;       # Tm steht für Timemode und bedeutet Realzeit oder Unixzeit
    
    my $name                    = $hash->{NAME};
    my $autoAstroMode;

    if( AttrVal($shuttersDev,'AutoShuttersControl_AutoAstroModeMorning','none') ne 'none' ) {
        $autoAstroMode          = AttrVal($shuttersDev,'AutoShuttersControl_AutoAstroModeMorning','REAL');
        $autoAstroMode          = $autoAstroMode . '=' . AttrVal($shuttersDev,'AutoShuttersControl_AutoAstroModeMorningHorizon',0) if( $autoAstroMode eq 'HORIZON' );
    } else {
        $autoAstroMode          = AttrVal($name,'AutoShuttersControl_autoAstroModeMorning','REAL');
        $autoAstroMode          = $autoAstroMode . '=' . AttrVal($name,'AutoShuttersControl_autoAstroModeMorningHorizon',0) if( $autoAstroMode eq 'HORIZON' );
    }
    
    my $oldFuncHash             = ReadingsVal($shuttersDev,'.AutoShuttersControl_InternalTimerFuncHash',0);
    my $shuttersSunriseUnixtime;


    if( $tm eq 'unix' ) {
        if( AttrVal($shuttersDev,'AutoShuttersControl_Up','astro') eq 'astro') {
            if( (IsWe() or IsWeTomorrow()) and ReadingsVal($name,'sunriseTimeWeHoliday','off') eq 'on' ) {
                $shuttersSunriseUnixtime    = (computeAlignTime('24:00',sunrise_abs($autoAstroMode,0,AttrVal($shuttersDev,'AutoShuttersControl_Time_Up_WE_Holiday','04:00:00'))) + 1);
                
            } else {
                $shuttersSunriseUnixtime    = (computeAlignTime('24:00',sunrise_abs($autoAstroMode,0,AttrVal($shuttersDev,'AutoShuttersControl_Time_Up_Early','04:30:00'),AttrVal($shuttersDev,'AutoShuttersControl_Time_Up_Late','09:00:00'))) + 1);
            }

            if( defined($oldFuncHash) and ref($oldFuncHash) eq 'HASH' and (IsWe() or IsWeTomorrow()) and ReadingsVal($name,'sunriseTimeWeHoliday','off') eq 'on' ) {
                $shuttersSunriseUnixtime = ($shuttersSunriseUnixtime + 86400)
                    if( ($shuttersSunriseUnixtime < ($oldFuncHash->{sunrisetime} + 1440) or $shuttersSunriseUnixtime != $oldFuncHash->{sunrisetime}) and $oldFuncHash->{sunrisetime} < gettimeofday() );
            
            } elsif( defined($oldFuncHash) and ref($oldFuncHash) eq 'HASH') {
                $shuttersSunriseUnixtime = ($shuttersSunriseUnixtime + 86400)
                    if( ($shuttersSunriseUnixtime < ($oldFuncHash->{sunrisetime} + 900) or $shuttersSunriseUnixtime != $oldFuncHash->{sunrisetime}) and $oldFuncHash->{sunrisetime} < gettimeofday() );
            }
        } elsif( AttrVal($shuttersDev,'AutoShuttersControl_Up','astro') eq 'time' ) {
        
            $shuttersSunriseUnixtime    = computeAlignTime('24:00',AttrVal($shuttersDev,'AutoShuttersControl_Time_Up_Early','04:30:00'));
        }
        
        return $shuttersSunriseUnixtime;
        
    } elsif( $tm eq 'real' ) {
        return sunrise_abs($autoAstroMode,0,AttrVal($shuttersDev,'AutoShuttersControl_Time_Up_Early','04:30:00'),AttrVal($shuttersDev,'AutoShuttersControl_Time_Up_Late','09:00:00')) if( AttrVal($shuttersDev,'AutoShuttersControl_Up','astro') eq 'astro');
        
        return AttrVal($shuttersDev,'AutoShuttersControl_Time_Up_Early','04:30:00') if( AttrVal($shuttersDev,'AutoShuttersControl_Up','astro') eq 'time');
    }
}

sub ShuttersSunset($$$) {

    my ($hash,$shuttersDev,$tm) = @_;       # Tm steht für Timemode und bedeutet Realzeit oder Unixzeit
    
    my $name                    = $hash->{NAME};
    my $autoAstroMode;

    if( AttrVal($shuttersDev,'AutoShuttersControl_AutoAstroModeEvening','none') ne 'none') {
        $autoAstroMode          = AttrVal($shuttersDev,'AutoShuttersControl_AutoAstroModeEvening','REAL');
        $autoAstroMode          = $autoAstroMode . '=' . AttrVal($shuttersDev,'AutoShuttersControl_AutoAstroModeEveningHorizon',0) if( $autoAstroMode eq 'HORIZON' );
    } else {
        $autoAstroMode          = AttrVal($name,'AutoShuttersControl_autoAstroModeEvening','REAL');
        $autoAstroMode          = $autoAstroMode . '=' . AttrVal($name,'AutoShuttersControl_autoAstroModeEveningHorizon',0) if( $autoAstroMode eq 'HORIZON' );
    }
    
    my $oldFuncHash             = ReadingsVal($shuttersDev,'.AutoShuttersControl_InternalTimerFuncHash',0);
    my $shuttersSunsetUnixtime;


    if( $tm eq 'unix' ) {
        if( AttrVal($shuttersDev,'AutoShuttersControl_Down','astro') eq 'astro') {
        
            $shuttersSunsetUnixtime     = (computeAlignTime('24:00',sunset_abs($autoAstroMode,0,AttrVal($shuttersDev,'AutoShuttersControl_Time_Down_Early','15:30:00'),AttrVal($shuttersDev,'AutoShuttersControl_Time_Down_Late','22:30:00'))) + 1);
            
            if( defined($oldFuncHash) and ref($oldFuncHash) eq 'HASH') {
                $shuttersSunsetUnixtime = ($shuttersSunsetUnixtime + 86400)
                    if( ($shuttersSunsetUnixtime < ($oldFuncHash->{sunsettime} + 900) or $shuttersSunsetUnixtime != $oldFuncHash->{sunsettime}) and $oldFuncHash->{sunsettime} < gettimeofday() );
            }
        } elsif( AttrVal($shuttersDev,'AutoShuttersControl_Down','astro') eq 'time' ) {
        
            $shuttersSunsetUnixtime     = computeAlignTime('24:00',AttrVal($shuttersDev,'AutoShuttersControl_Time_Down_Early','15:30:00'));
        }
        
        return $shuttersSunsetUnixtime;

    } elsif( $tm eq 'real' ) {
        return sunset_abs($autoAstroMode,0,AttrVal($shuttersDev,'AutoShuttersControl_Time_Down_Early','15:30:00'),AttrVal($shuttersDev,'AutoShuttersControl_Time_Down_Late','22:30:00')) if( AttrVal($shuttersDev,'AutoShuttersControl_Down','astro') eq 'astro');
        
        return AttrVal($shuttersDev,'AutoShuttersControl_Time_Down_Early','15:30:00') if( AttrVal($shuttersDev,'AutoShuttersControl_Down','astro') eq 'time');
    }
}

## Kontrolliert ob das Fenster von einem bestimmten Rolladen offen ist
sub CheckIfShuttersWindowRecOpen($) {

    my $shuttersDev = shift;


    if( ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_WindowRec','none'),'state','closed') eq 'open' ) {
        return 2;
    } elsif( ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_WindowRec','none'),'state','closed') eq 'tilted' and AttrVal($shuttersDev,'AutoShuttersControl_WindowRec_subType','twostate') eq 'threestate') {
        return 1;
    } elsif( ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_WindowRec','none'),'state','closed') eq 'closed' ) {
        return 0;
    }
}

sub ShuttersPosCmdValueNegieren($) {

    my $shuttersDev     = shift;
    
    return (AttrVal($shuttersDev,'AutoShuttersControl_Open_Pos',0) < AttrVal($shuttersDev,'AutoShuttersControl_Closed_Pos',100) ? 1 : 0);
}

sub makeReadingName($) {

    my ($name)      = @_;
    
    
    my %charHash    = ("ä" => "ae", "Ä" => "Ae", "ü" => "ue", "Ü" => "Ue", "ö" => "oe", "Ö" => "Oe", "ß" => "ss");
    my $charHashkeys = join ("|", keys(%charHash));

    $name = "UNDEFINED" if(!defined($name));
    return $name if($name =~ m/^\./);

    $name =~ s/($charHashkeys)/$charHash{$1}/gi;
    $name =~ s/[^a-z0-9._\-\/]/_/gi;

    return $name;
}

sub TimeMin2Sec($) {

    my $min = shift;
    my $sec;
    
    $sec    = $min * 60;
    
    return $sec;
}

sub IsWe() {
    
    my (undef,undef,undef,undef,undef,undef,$wday,undef,undef) = localtime(gettimeofday());
    my $we  = (($wday == 0 || $wday == 6) ? 1 : 0);


    if(!$we) {
        foreach my $h2we (split(",", AttrVal("global", "holiday2we", ""))) {
            my ($a, $b) = ReplaceEventMap($h2we, [$h2we, Value($h2we)], 0);
            $we = 1 if($b && $b ne "none");
        }
    }
    
    return $we
}

sub IsWeTomorrow() {

    my (undef,undef,undef,undef,undef,undef,$wday,undef,undef) = localtime(gettimeofday());
    my $we  = (((($wday+1 == 7 ? 0 : $wday+1)) == 0 || ($wday+1) == 6) ? 1 : 0);


    if(!$we) {
        foreach my $h2we (split(",", AttrVal("global", "holiday2we", ""))) {
            my ($a, $b) = ReplaceEventMap($h2we, [$h2we, ReadingsVal($h2we,"tomorrow","none")], 0);
            $we = 1 if($b && $b ne "none");
        }
    }
    
    return $we
}

sub IsHoliday($) {

    my $hash    = shift;
    my $name    = $hash->{NAME};
    
    return ( ReadingsVal(AttrVal($name,'AutoShuttersControl_timeUpHolidayDevice','none'),'state',0) == 1 ? 1 : 0 );
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
  <u><b>AutoShuttersControl (shurt: ASC) is designed for automation of shutter levels based on individual presets and timers. Timers can use sunrise and sunset events, reaction on opening or closing of correspondant window contacts is possible.</b></u>
  <br>
  This module generates a virtual device. If your shutters are represented in FHEM as devices, just put them under controll of this module. Then you get further options to let ASC controll them. Set the provided attributes and ASC will e.g. open your shutter after sunrise when resident is awoken. Or let it go to a predifined position for ventilation when window is tilted. 
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
    After this first step, start adding shutter devices by assigning the new attribute  "AutoShuttersControl" using "1" or "2" as value.<br>
    Use "1" if your shutter is open at lower position (typically: 0 = open, 100 = closed) and shutter command "position" is used. Right choice for ROLLO devices.
	"2" means opposite, so open is 100 and closed corresponds to 0; command for going to a specific position is "pct". Use "2" especially for HomeMatic devices.<br>
    Next use the "scanForShutters" setter to get your shutter(s) controlled by ASC and start configuring your shutter devices by setting the ASC attributes to your needs.
  </ul>
  <br><br>
  <a name="AutoShuttersControlReadings"></a>
  <b>Readings</b>
  <ul>
    Module Device
    <ul>
      <li>..._nextAstroTimeEvent - Execution time of the next Astro Event, sunrise, sunset or fixed time per shutter</li>
      <li>..._lastPosValue - last sent positioning command per shutter</li>
      <li>..._lastDelayPosValue - last positioning command per shutter not yet sent, waiting for event dependent execution.</li>
      <li>partyMode - on/off; activates a global party mode, all shutters with AutoShuttersControl_Partymode attribute set to "on" will not get any command from ASC until part is set to "off" again. Then the last intermediate positioning command will be executed, e.g. based on window opening or resident state.</li>
      <li>lockOut - on/off f&uuml;r das aktivieren des Aussperrschutzes gem&auml;&szlig; dem entsprechenden Attribut AutoShuttersControl_lock-out im jeweiligen Rolladen. (siehe Beschreibung bei den Attributen f&uuml;r die Rolladendevices)</li>
      <li>room_... - List of all shutter devices under ASC control per room</li>
      <li>state - State of the ASC device (active, enabled or disabled)</li>
      <li>userAttrList - Indicates if all UserAttributes are rolled out to shutter devices.</li>
    </ul><br>
    Shutter Devices
    <ul>
      <li>AutoShuttersControl_Time_DriveUp - Shutter's individual sunrise time</li>
      <li>AutoShuttersControl_Time_DriveDown - Shutter's individual sunset time</li>
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
      <li>AutoShuttersControl_antifreezeTemp - Temperature limit. Below this temperature, ASC will not issue positioning commands to prevent damages from frozen shutters. Last positioning command will be stored for later execution.</li>
      <li>AutoShuttersControl_autoAstroModeEvening - can be set to REAL, CIVIL, NAUTIC, ASTRONOMIC</li>
      <li>AutoShuttersControl_autoAstroModeEveningHorizon - Highth above horizon. Use this in combination with attribute AutoShuttersControl_autoAstroModeEvening set to HORIZON</li>
      <li>AutoShuttersControl_autoAstroModeMorning - can be set to REAL, CIVIL, NAUTIC, ASTRONOMIC</li>
      <li>AutoShuttersControl_autoAstroModeMorningHorizon - similar to AutoShuttersControl_autoAstroModeEvening</li>
      <li>AutoShuttersControl_autoShuttersControlComfort - on/off. Switch to on to react on open or tilted events. Needs further info in shutter attributes about WindowRec, WindowRecType and AutoShuttersControl_Pos_after_ComfortOpen (last sets target position).</li>
      <li>AutoShuttersControl_autoShuttersControlEvening - on/off; Switch to on to close this shutter in the evening</li>
      <li>AutoShuttersControl_autoShuttersControlMorning - on/off; similar to AutoShuttersControl_autoShuttersControlEvening for opening.</li>
      <li>AutoShuttersControl_temperatureReading - Reading name for outside temperature</li>
      <li>AutoShuttersControl_temperatureSensor - Device name for outside temperature</li>
    </ul><br>
    Individual Shutter Devices
    <ul>
      <li>AutoShuttersControl - 0/1/2. Use "1" if your shutter is open at lower position (typically: 0 = open, 100 = closed) and shutter command "position" is used. Right choice for ROLLO devices.
	"2" means opposite, so open is 100 and closed corresponds to 0; command for going to a specific position is "pct". Use "2" especially for HomeMatic devices.</li>
      <li>AutoShuttersControl_Antifreeze - on/off; Set to on to prevent ASC commands under the set temperature limit</li>
      <li>AutoShuttersControl_AutoAstroModeEvening - can be set to REAL, CIVIL, NAUTIC, ASTRONOMIC</li>
      <li>AutoShuttersControl_AutoAstroModeEveningHorizon - Highth above horizon. Use this in combination with attribute AutoShuttersControl_autoAstroModeEvening set to HORIZON</li>
      <li>AutoShuttersControl_AutoAstroModeMorning - can be set to REAL, CIVIL, NAUTIC, ASTRONOMIC</li>
      <li>AutoShuttersControl_AutoAstroModeMorningHorizon - similar to AutoShuttersControl_autoAstroModeEvening</li>
      <li>AutoShuttersControl_Closed_Pos - in 10 steps from 0 to 100, defaults will be set dependent on AutoShuttersControl attribute value.</li>
      <li>AutoShuttersControl_Down - astro/time. "Astro" uses sunrise logic to calculate sunset time, "time" uses AutoShuttersControl_Time_Down_Early attibute's value.</li>
      <li>AutoShuttersControl_Mode_Down - always/absent/off. Additional conditions for close commands based on roommate state. Please note: If there's no roommate and attribute set to "absent" no closing command will be issued.</li>
      <li>AutoShuttersControl_Mode_Up - always/absent/off. Like AutoShuttersControl_Mode_Down for opening commands.</li>
      <li>AutoShuttersControl_Offset_Minutes_Evening - </li>
      <li>AutoShuttersControl_Offset_Minutes_Morning - </li>
      <li>AutoShuttersControl_Open_Pos -  in 10 steps from 0 to 100, defaults will be set dependent on AutoShuttersControl attribute value.</li>
      <li>AutoShuttersControl_Partymode -  on/off. See correspondant Attribute for ASC Module.</li>
      <li>AutoShuttersControl_Pos_Cmd - set command for setting the shutter to a decent level; must correspond to the reading name for the actual position of the shutter</li>
      <li>AutoShuttersControl_Pos_after_ComfortOpen - in 10 steps from 0 to 100, defaults will be set dependent on AutoShuttersControl attribute value.</li>
      <li>AutoShuttersControl_Roommate_Reading - Reading name of the roommate device's status info.</li>
      <li>AutoShuttersControl_Roommate_Device - Name of the roommate device to be used to controll all shutters in the same room as the roommate.</li>
      <li>AutoShuttersControl_Time_Down_Early - Early limit for closing timer calculation using sunset</li>
      <li>AutoShuttersControl_Time_Down_Late - Latest limit for closing timer calculation using sunset</li>
      <li>AutoShuttersControl_Time_Up_Early - Like ...Time_Down... for opening</li>
      <li>AutoShuttersControl_Time_Up_Late - Like ...Time_Down... for opening</li>
      <li>AutoShuttersControl_Time_Up_WE_Holiday - Sunrise fr&uuml;hste Zeit zum hochfahren am Wochenende und/oder Urlaub</li>
      <li>AutoShuttersControl_Time_Up_HolidayDevice - Device zur Urlaubserkennung/muss 0 oder 1 im Reading state beinhalten.
      <li>AutoShuttersControl_Up - astro/time "Astro" will use sunrise calculation for opening times, "time" uses AutoShuttersControl_Time_Up_Early value.</li>
      <li>AutoShuttersControl_Ventilate_Pos -  in 10 steps from 0 to 100, defaults will be set dependent on AutoShuttersControl attribute value.</li>
      <li>AutoShuttersControl_Ventilate_Window_Open - Level to be set for ventilation in case of opening or tilted event (only if current shutter position is below this level</li>
      <li>AutoShuttersControl_WindowRec - Name of the window contact corresponding to the shutter</li>
      <li>AutoShuttersControl_WindowRec_subType - Type of the used window contact: twostate (only sends open and closed) or threestate (sends also tilted)</li>
      <li>AutoShuttersControl_lock-out - soft/hard stellt entsprechend den Aussperrschutz ein. Bei global aktiven Aussperrschutz (set ASC-Device lockOut soft) und einem Fensterkontakt open bleibt dann der Rolladen oben. Dies gilt nur bei Steuerbefehle über das ASC Modul. Stellt man global auf hard, wird bei entsprechender M&ouml;glichkeit versucht den Rolladen Hardwareseitig zu blockieren. Dann ist auch ein fahren &uuml;ber die Taster nicht mehr m&ouml;glich.</li>
      <li>AutoShuttersControl_lock-outCmd - inhibit/blocked set Befehl für das Rolladen-Device zum Hardware sperren. Zum gesetzt werden wenn man "AutoShuttersControl_lock-out" auf hard setzt</li>
    </ul>
  </ul>
</ul>

=end html

=begin html_DE

<a name="AutoShuttersControl"></a>
<h3>Automatische Rolladensteuerung - ASC</h3>
<ul>
  <u><b>AutoShuttersControl oder kurz ASC, steuert automatisch Deine Rolladen nach bestimmten Vorgaben. Zum Beispiel Sonnenaufgang und Sonnenuntergang oder je nach Fenstervent</b></u>
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
    Nachdem das Device angelegt wurde, m&uuml;ssen in allen Roll&auml;den Devices welche gesterut werden sollen das Attribut AutoShuttersControl mit Wert 1 oder 2 gesetzt werden.<br>
    Dabei bedeutet 1 = "Inverse oder Rollo Bsp.: Rollo Oben 0, Rollo Unten 100 und der Befehl zum Prozentualen fahren ist position", 2 = "Homematic Style Bsp.: Rollo Oben 100, Rollo Unten 0 und der Befehl zum Prozentualen fahren ist pct.<br>
    Habt Ihr das Attribut gesetzt, k&ouml;nnt Ihr den automatischen Scan nach den Devices anstossen.
  </ul>
  <br><br>
  <a name="AutoShuttersControlReadings"></a>
  <b>Readings</b>
  <ul>
    Im Modul Device
    <ul>
      <li>..._nextAstroTimeEvent - Uhrzeit des nächsten Astro Events, Sonnenauf, Sonnenuntergang oder feste Zeit pro Rollonamen</li>
      <li>..._lastPosValue - letzter abgesetzter Fahrbefehl pro Rollanamen</li>
      <li>..._lastDelayPosValue - letzter abgesetzter Fahrbefehl welcher beim n&auml;chsten zul&auml;ssigen Event ausgef&uuml;hrt wird.</li>
      <li>partyMode - on/off aktiviert den globalen Partymodus, alle Roll&auml;den welche das Attribut AutoShuttersControl_Partymode bei sich auf on gestellt haben werden nicht mehr gesteuert. Der letzte Schaltbefehle welcher durch ein Fensterevent oder Bewohnerstatus an die Roll&auml;den gesendet wurde, wird beim off setzen durch set ASC-Device partyMode off ausgef&uuml;hrt</li>
      <li>lockOut - on/off f&uuml;r das aktivieren des Aussperrschutzes gem&auml;&szlig; dem entsprechenden Attribut AutoShuttersControl_lock-out im jeweiligen Rolladen. (siehe Beschreibung bei den Attributen f&uuml;r die Rolladendevices)</li>
      <li>room_... - Auflistung aller Roll&auml;den welche in den jeweiligen R&auml;men gefunden wurde, Bsp.: room_Schlafzimmer,Terrasse</li>
      <li>state - Status des Devices active, enabled, disabled</li>
      <li>sunriseTimeWeHoliday - on/off wird das Rolladen Device Attribut Attributes AutoShuttersControl_Time_Up_WE_Holiday Beachtet oder nicht</li>
      <li>userAttrList - Status der UserAttribute welche an die Roll&auml;den gesendet werden</li>
    </ul><br>
    In den Roll&auml;den Devices
    <ul>
      <li>AutoShuttersControl_Time_DriveUp - Sonnenaufgangszei f&uuml;r das Rollo</li>
      <li>AutoShuttersControl_Time_DriveDown - Sonnenuntergangszeit f&uuml;r das Rollo</li>
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
    <li>sunriseTimeWeHoliday - on/off aktiviert/deaktiviert die Beachtung des Rolladen Device Attributes AutoShuttersControl_Time_Up_WE_Holiday</li>
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
  Im Modul Device
    <ul>
      <li>AutoShuttersControl_antifreezeTemp - Temperatur ab welcher der Frostschutz greifen soll und das Rollo nicht mehr f&auml;hrt. Der letzte Fahrbefehl wird gespeichert.</li>
      <li>AutoShuttersControl_autoAstroModeEvening - aktuell REAL, CIVIL, NAUTIC, ASTRONOMIC</li>
      <li>AutoShuttersControl_autoAstroModeEveningHorizon - H&ouml;he &uuml;ber Horizont wenn beim Attribut AutoShuttersControl_autoAstroModeEvening HORIZON ausgew&auml;hlt</li>
      <li>AutoShuttersControl_autoAstroModeMorning - aktuell REAL, CIVIL, NAUTIC, ASTRONOMIC</li>
      <li>AutoShuttersControl_autoAstroModeMorningHorizon - H&ouml;he &uuml;ber Horizont wenn beim Attribut AutoShuttersControl_autoAstroModeMorning HORIZON ausgew&auml;hlt</li>
      <li>AutoShuttersControl_autoShuttersControlComfort - on/off schaltet die Komfortfunktion an. Bedeutet das ein Rolladen mit einem threestate Sensor am Fenster beim &ouml;ffnen in eine weit offen Position  f&auml;hrt. Die Offenposition wird beim Rolladen &uuml;ber das Attribut AutoShuttersControl_Pos_after_ComfortOpen eingestellt.</li>
      <li>AutoShuttersControl_autoShuttersControlEvening - on/off, ob Abends die Roll&auml;den automatisch nach Zeit gesteuert werden sollen</li>
      <li>AutoShuttersControl_autoShuttersControlMorning - on/off, ob Morgens die Roll&auml;den automatisch nach Zeit gesteuert werden sollen</li>
      <li>AutoShuttersControl_temperatureReading - Reading f&uuml;r die Aussentemperatur</li>
      <li>AutoShuttersControl_temperatureSensor - Device f&uuml;r die Aussentemperatur</li>
      <li>AutoShuttersControl_timeUpHolidayDevice - Device zur Urlaubserkennung oder Sonstiges / muss 0 oder 1 im Reading state beinhalten.
    </ul><br>
    In den Roll&auml;den Devices
    <ul>
      <li>AutoShuttersControl - 0/1/2 1 = "Inverse oder Rollo Bsp.: Rollo Oben 0, Rollo Unten 100 und der Befehl zum Prozentualen fahren ist position", 2 = "Homematic Style Bsp.: Rollo Oben 100, Rollo Unten 0 und der Befehl zum Prozentualen fahren ist pct</li>
      <li>AutoShuttersControl_Antifreeze - on/off Frostschutz an oder aus</li>
      <li>AutoShuttersControl_AutoAstroModeEvening - aktuell REAL, CIVIL, NAUTIC, ASTRONOMIC</li>
      <li>AutoShuttersControl_AutoAstroModeEveningHorizon - H&ouml;he &uuml;ber Horizont wenn beim Attribut AutoShuttersControl_autoAstroModeEvening HORIZON ausgew&auml;hlt</li>
      <li>AutoShuttersControl_AutoAstroModeMorning - aktuell REAL, CIVIL, NAUTIC, ASTRONOMIC</li>
      <li>AutoShuttersControl_AutoAstroModeMorningHorizon - H&ouml;he &uuml;ber Horizont wenn beim Attribut AutoShuttersControl_autoAstroModeMorning HORIZON ausgew&auml;hlt</li>
      <li>AutoShuttersControl_Closed_Pos - in 10 Schritten von 0 bis 100, default Vorgabe ist abh&auml;ngig vom Attribut AutoShuttersControl</li>
      <li>AutoShuttersControl_Down - astro/time bei Astro wird Sonnenuntergang berechnet, bei time wird der Wert aus AutoShuttersControl_Time_Down_Early als Fahrzeit verwendet</li>
      <li>AutoShuttersControl_Mode_Down - always/absent/off wann darf die Automatik steuern. immer, niemals, bei abwesenheit des Roomate (ist kein Roommate und absent eingestellt wird gar nicht gesteuert)</li>
      <li>AutoShuttersControl_Mode_Up - always/absent/off wann darf die Automatik steuern. immer, niemals, bei abwesenheit des Roomate (ist kein Roommate und absent eingestellt wird gar nicht gesteuert)</li>
      <li>AutoShuttersControl_Offset_Minutes_Evening - maximale zufällige Verzögerung in Minuten (minimal 1) bei der Berechnung der Fahrzeiten für Abends</li>
      <li>AutoShuttersControl_Offset_Minutes_Morning - maximale zufällige Verzögerung in Minuten (minimal 1) bei der Berechnung der Fahrzeiten für Morgens</li>
      <li>AutoShuttersControl_Open_Pos -  in 10 Schritten von 0 bis 100, default Vorgabe ist abh&auml;ngig vom Attribut AutoShuttersControl</li>
      <li>AutoShuttersControl_Partymode -  on/off  schaltet den Partymodus an oder aus, Wird dann am ASC Device set ASC-DEVICE partyMode on geschalten, werden alle Fahrbefehle an den Roll&auml;den welche das Attribut auf on haben zwischen gespeichert und sp&auml;ter erst ausgef&uuml;hrt</li>
      <li>AutoShuttersControl_Pos_Cmd - der set Befehl um den Rolladen in Prozent Angaben zu fahren, muss der selbe sein wie das Reading welches die Position des Rolladen in Prozent an gibt</li>
      <li>AutoShuttersControl_Pos_after_ComfortOpen - in 10 Schritten von 0 bis 100, default Vorgabe ist abh&auml;ngig vom Attribut AutoShuttersControl</li>
      <li>AutoShuttersControl_Roommate_Reading - das Reading zum Roommate Device welches den Status wieder gibt</li>
      <li>AutoShuttersControl_Roommate_Device - Name des Roommate Devices welcher den Bewohner des Raumes vom Rolladen wieder gibt</li>
      <li>AutoShuttersControl_Time_Down_Early - Sunset frühste Zeit zum runter fahren</li>
      <li>AutoShuttersControl_Time_Down_Late - Sunset späteste Zeit zum runter fahren</li>
      <li>AutoShuttersControl_Time_Up_Early - Sunrise frühste Zeit zum hoch fahren</li>
      <li>AutoShuttersControl_Time_Up_Late - Sunrise späteste Zeit zum hoch fahren</li>
      <li>AutoShuttersControl_Time_Up_WE_Holiday - Sunrise fr&uuml;hste Zeit zum hochfahren am Wochenende und/oder Urlaub (we2holiday wird beachtet), Achtung sollte nicht gr&ouml;&szlig;er sein wie AutoShuttersControl_Time_Up_Late sonst wird AutoShuttersControl_Time_Up_Late verwendet</li>
      <li>AutoShuttersControl_Up - astro/time bei Astro wird Sonnenaufgang berechnet, bei time wird der Wert aus AutoShuttersControl_Time_Up_Early als Fahrzeit verwendet</li>
      <li>AutoShuttersControl_Ventilate_Pos -  in 10 Schritten von 0 bis 100, default Vorgabe ist abh&auml;ngig vom Attribut AutoShuttersControl</li>
      <li>AutoShuttersControl_Ventilate_Window_Open - auf l&uuml;ften, wenn das Fenster gekippt/ge&ouml;ffnet wird und aktuelle Position unterhalb der L&uuml;ften-Position ist</li>
      <li>AutoShuttersControl_WindowRec - Name des Fensterkontaktes an welchen Fenster der Rolladen angebracht ist</li>
      <li>AutoShuttersControl_WindowRec_subType - Typ des verwendeten Fensterkontakts: twostate (optisch oder magnetisch) oder threestate (Drehgriffkontakt)</li>
      <li>AutoShuttersControl_lock-out - soft/hard stellt entsprechend den Aussperrschutz ein. Bei global aktiven Aussperrschutz (set ASC-Device lockOut soft) und einem Fensterkontakt open bleibt dann der Rolladen oben. Dies gilt nur bei Steuerbefehle über das ASC Modul. Stellt man global auf hard, wird bei entsprechender M&ouml;glichkeit versucht den Rolladen Hardwareseitig zu blockieren. Dann ist auch ein fahren &uuml;ber die Taster nicht mehr m&ouml;glich.</li>
      <li>AutoShuttersControl_lock-outCmd - inhibit/blocked set Befehl für das Rolladen-Device zum Hardware sperren. Zum gesetzt werden wenn man "AutoShuttersControl_lock-out" auf hard setzt</li>
    </ul>
  </ul>
</ul>

=end html_DE

=cut
