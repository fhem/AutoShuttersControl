###############################################################################
# 
# Developed with Kate
#
#  (c) 2018 Copyright: Marko Oldenburg (leongaultier at gmail dot com)
#  All rights reserved
#
#   Special thanks goes to:
#       -
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




my $version = "0.0.12";


sub AutoShuttersControl_Initialize($) {
    my ($hash) = @_;

    $hash->{SetFn}      = "AutoShuttersControl::Set";
    #$hash->{GetFn}      = "ShuttersControl::Get";
    $hash->{DefFn}      = "AutoShuttersControl::Define";
    $hash->{NotifyFn}   = "AutoShuttersControl::Notify";
    $hash->{UndefFn}    = "AutoShuttersControl::Undef";
    $hash->{AttrFn}     = "AutoShuttersControl::Attr";
    $hash->{AttrList}   = "disable:1 ".
                            "disabledForIntervals ".
                            "guestPresence:on,off ".
                            "temperatureSensor ".
                            "temperatureReading ".
                            "brightnessMinVal ".
                            "autoShutterControlMorning:on,off ".
                            "autoShuttersControlEvening:on,off ".
                            "autoShuttersControl_Shading:on,off ".
                            "autoShuttersControlComfort:on,off ".
                            "sunPosDevice ".
                            "sunPosReading ".
                            "sunElevationDevice ".
                            "sunElevationReading ".
                            "presenceDevice ".
                            "presenceReading ".
                            "autoAstroModeMorning:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON ".
                            "autoAstroModeMorningHorizon ".
                            "autoAstroModeEvening:REAL,CIVIL,NAUTIC,ASTRONOMIC,HORIZON ".
                            "autoAstroModeEveningHorizon ".
                            "antifreezeTemp ".
                            "autoShutterControlPartymode:on,off ".
                            $readingFnAttributes;


    foreach my $d(sort keys %{$modules{AutoShuttersControl}{defptr}}) {
        my $hash = $modules{AutoShuttersControl}{defptr}{$d};
        $hash->{VERSION}    = $version;
    }
}




package AutoShuttersControl;


use strict;
use warnings;
use POSIX;

use GPUtils qw(:all);
use Data::Dumper;      #only for Debugging

my $missingModul = "";



BEGIN {

    GP_Import(qw(
        devspec2array
        readingsSingleUpdate
        readingsBulkUpdate
        readingsBeginUpdate
        readingsEndUpdate
        defs
        modules
        Log3
        CommandAttr
        CommandDeleteReading
        AttrVal
        ReadingsVal
        IsDisabled
        deviceEvents
        init_done
        addToDevAttrList
    ))
};




my %userAttrList =  (   'AutoShuttersControl_Mode_Up:present,absent,always,off' =>  'always',
                        'AutoShuttersControl_Mode_Down:present,absent,always,off'   =>  'always',
                        'AutoShuttersControl_Up:time,astro' =>  'astro',
                        'AutoShuttersControl_Down:time,astro'   =>  'astro',
                        'AutoShuttersControl_Ventilate_Pos:10,20,30,40,50,60,70,80,90,100'  =>  30,
                        'AutoShuttersControl_Open_Pos:10,20,30,40,50,60,70,80,90,100'   =>  100,
                        'AutoShuttersControl_Direction' =>  178,
                        'AutoShuttersControl_Time_Up_Early' =>  '05:30:00',
                        'AutoShuttersControl_Time_Up_Late'  =>  '09:00:00',
                        'AutoShuttersControl_Time_Up_WE_Holiday'    =>  '09:30:00',
                        'AutoShuttersControl_Time_Down_Early'   =>  '15:30:00', 
                        'AutoShuttersControl_Time_Down_Late'    =>   '22:00:00',
                        'AutoShuttersControl_Rand_Minutes'  =>  20,
                        'AutoShuttersControl_WindowRec' =>  '',
                        'AutoShuttersControl_Ventilate_Window_Open:on,off'  =>  'on',
                        'AutoShuttersControl_lock-out:on,off'   =>  'off',
                        'AutoShuttersControl_Shading_Pos:10,20,30,40,50,60,70,80,90,100'    =>  30,
                        'AutoShuttersControl_Shading:on,off,delayed,present,absent' =>  'off',
                        'AutoShuttersControl_Shading_Pos_after_Shading:-1,0,10,20,30,40,50,60,70,80,90,100' =>  -1,
                        'AutoShuttersControl_Shading_Angle_Left:0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90' =>  85,
                        'AutoShuttersControl_Shading_Angle_Right:0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90'    =>  85,
                        'AutoShuttersControl_Shading_Brightness_Sensor' =>  '',
                        'AutoShuttersControl_Shading_Brightness_Reading'    =>  'brightness',
                        'AutoShuttersControl_Shading_StateChange_Sunny'     =>  6000,
                        'AutoShuttersControl_Shading_StateChange_Cloudy'    =>  4000,
                        'AutoShuttersControl_Shading_WaitingPeriod' =>  20,
                        'AutoShuttersControl_Shading_Min_Elevation' =>  '',
                        'AutoShuttersControl_Shading_Min_OutsideTemperature'    =>  18,
                        'AutoShuttersControl_Shading_BlockingTime_After_Manual' =>  20,
                        'AutoShuttersControl_Shading_BlockingTime_Twilight'     => 45,
                        'AutoShuttersControl_Shading_Fast_Open:on,off'  =>  '',
                        'AutoShuttersControl_Shading_Fast_Close:on,off' =>  '',
                        'AutoShuttersControl_Offset_Minutes_Morning'    =>  0,
                        'AutoShuttersControl_Offset_Minutes_Evening'    =>  0,
                        'AutoShuttersControl_WindowRec_subType:twostate,threestate' =>  'twostate',
                        'AutoShuttersControl_Pos_Cmd'   =>  'pct',
                        'AutoShuttersControl_Closed_Pos'    =>  '',
                        'AutoShuttersControl_GuestRoom:on,off'  =>  '',
                        'AutoShuttersControl_Pos_after_ComfortOpen:-2,-1,0,10,20,30,40,50,60,70,80,90,100'  =>  '',
                        'AutoShuttersControl:on,off'    => 'on',
                        'AutoShuttersControl_Antifreeze:off,morning'    =>  'off',
                        'AutoShuttersControl_Partymode:on,off'  =>  '',
                        'AutoShuttersControl_Roommate_Device'   =>  '',
                        'AutoShuttersControl_Roommate_Reading'   =>  'state',
                    );





sub Define($$) {

    my ( $hash, $def ) = @_;
    my @a = split( "[ \t][ \t]*", $def );
    
    return "only one AutoShuttersControl instance allowed" if( devspec2array('TYPE=AutoShuttersControl') > 1 );
    return "too few parameters: define <name> ShuttersControl <Shutters1 Shutters2 ...> or <auto>" if( @a < 3 );
    return "Cannot define ShuttersControl device. Perl modul ${missingModul}is missing." if ( $missingModul );
    

    my $name                    = $a[0];

    $hash->{VERSION}            = $version;
    $hash->{MID}                = 'da39a3ee5e6b4b0d3255bfef95601890afd80709';
    $hash->{DETECTDEV}          = ($a[2] eq 'auto' ? 'auto' : 'manual');
    $hash->{NotifyOrderPrefix}  = "51-";
    $hash->{NOTIFYDEV}          = "global,".$name;
    

    readingsSingleUpdate($hash,"state","initialized", 1);
    CommandAttr(undef,$name . ' room AutoShuttersControl') if( AttrVal($name,'room','none') eq 'none' );
    
    Log3 $name, 3, "AutoShuttersControl ($name) - defined";
    
    $modules{AutoShuttersControl}{defptr}{$hash->{MID}} = $hash;
    
    return undef;
}

sub Undef($$) {

    my ($hash,$arg) = @_;
    
    
    my $name = $hash->{NAME};
    
    delete($modules{AutoShuttersControl}{defptr}{$hash->{MID}});
    
    Log3 $name, 3, "AutoShuttersControl ($name) - delete device $name";
    return undef;
}

sub Attr(@) {

    my ( $cmd, $name, $attrName, $attrVal ) = @_;
    my $hash                                = $defs{$name};


    if( $attrName eq "disable" ) {
        if( $cmd eq "set" and $attrVal eq "1" ) {
            RemoveInternalTimer($hash);
            
            readingsSingleUpdate ( $hash, "state", "disabled", 1 );
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
            readingsSingleUpdate ( $hash, "state", "disabled", 1 );
        }
        
        elsif( $cmd eq "del" ) {
            Log3 $name, 3, "AutoShuttersControl ($name) - enabled";
            readingsSingleUpdate ( $hash, "state", "active", 1 );
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

    Log3 $name, 3, "AutoShuttersControl ($name) - Devname: ".$devname." Name: ".$name." Notify: ".Dumper $events;       # mit Dumper


    if( (grep /^DEFINED.$name$/,@{$events}
        and $devname eq 'global'
        and $init_done)
        or (grep /^INITIALIZED$/,@{$events}
        or grep /^REREADCFG$/,@{$events}
        or grep /^MODIFIED.$name$/,@{$events})
        and $devname eq 'global') {

            ShuttersDeviceScan($hash);
            WriteReadingsShuttersList($hash) unless( scalar(@{$hash->{helper}{shuttersList}} ) == 0 );
    
    } elsif( grep /^userAttrList:.rolled.out$/,@{$events}
            and $devname eq $name) {

                CreateUserAttributsForShutters($hash) unless( scalar(@{$hash->{helper}{shuttersList}} ) == 0 );
    }
#     } elsif( ) {
#     
#     
#     
#     }

    return;
}

sub Set($$@) {
    
    my ($hash, $name, @aa)  = @_;
    
    
    my ($cmd, @args)        = @aa;

    if( lc $cmd eq 'rolloutattr' ) {
        return "usage: $cmd" if( @args != 0 );
        
        CreateUserAttributsForShutters($hash);
        
    } elsif( lc $cmd eq 'shutterslist' ) {
        return "usage: $cmd" if( @args != 0 );
        
        WriteReadingsShuttersList($hash);
    
    } else {
        my $list = "";
        
        return "Unknown argument $cmd, choose one of $list";
    }
    
    return undef;
}

sub ShuttersDeviceScan($) {

    my $hash    = shift;
    my $name    = $hash->{NAME};
    
    
    my @list;
    my @notifyDev   = split(',',$hash->{NOTIFYDEV});
    
    @list = devspec2array('(Roll.*|Shutter.*):FILTER=TYPE!=AutoShuttersControl');
    @list = split( "[ \t][ \t]*", $hash->{DEF} ) if($hash->{DETECTDEV} eq 'manual');
    
    delete $hash->{helper}{shuttersList};
    
    return unless( scalar(@list) > 0 );

    foreach(@list) {
        push (@{$hash->{helper}{shuttersList}},$_);
        push (@notifyDev,$_);
        Log3 $name, 4, "AutoShuttersControl ($name) - ShuttersList: " . $_;
    }
    
    $hash->{NOTIFYDEV}  = join(',',@notifyDev);
    readingsSingleUpdate($hash,'userAttrList','rolled out',1);
}

sub WriteReadingsShuttersList($) {

    my $hash    = shift;
    my $name    = $hash->{NAME};
    

    CommandDeleteReading(undef,$name . ' room_.*');
    
    readingsBeginUpdate($hash);
    
    foreach (@{$hash->{helper}{shuttersList}}) {
    
        readingsBulkUpdate($hash,'room_' . AttrVal($_,'room','unsorted'),ReadingsVal($name,'room_' . AttrVal($_,'room','unsorted'),'') . ', ' . $_) if( ReadingsVal($name,'room_' . AttrVal($_,'room','unsorted'),'none') ne 'none' );
        
        readingsBulkUpdate($hash,'room_' . AttrVal($_,'room','unsorted'),$_) if( ReadingsVal($name,'room_' . AttrVal($_,'room','unsorted'),'none') eq 'none' );
    }
    
    readingsBulkUpdate($hash,'state','active');
    readingsEndUpdate($hash,0);
}

sub CreateUserAttributsForShutters($) {

    my $hash    = shift;
    my $name    = $hash->{NAME};

    
    while( my ($attrib,$attribValue) = each %{userAttrList} ) {
        foreach (@{$hash->{helper}{shuttersList}}) {

            addToDevAttrList($_,$attrib);
            CommandAttr(undef,$_ . ' ' . (split(':',$attrib))[0] . ' ' . $attribValue) if( defined($attribValue) and $attribValue and AttrVal($_,(split(':',$attrib))[0],'none') eq 'none' );
        }
    }
}





1;




=pod
=item device
=item summary       Modul 
=item summary_DE    Modul zur Automatischen Rolladensteuerung auf Basis bestimmter Ereignisse

=begin html

<a name="AutoShuttersControl"></a>
<h3>Auto Shutters Control</h3>
<ul>
  
</ul>

=end html

=begin html_DE

<a name="AutoShuttersControl"></a>
<h3>Automatische Rolladensteuerung</h3>
<ul>
  <u><b>AutoShuttersControl - Steuert automatisch Deine Rolladen nach bestimmten Vorgaben. Zum Beispiel Sonnenaufgang und Sonnenuntergang</b></u>
  <br>
  Das Modul synct alle Repositotys und stellt dann Informationen &uuml;ber zu aktualisierende Packete bereit.</br>
  Es ist Voraussetzung das folgende Zeile via "visudo" eingef&uuml;gt wird: "fhem    ALL=NOPASSWD:   /usr/bin/apt-get".
  <br><br>
  <a name="ShuttersControldefine"></a>
  <b>Define</b>
  <ul><br>
    <code>define &lt;name&gt; ShuttersControl &lt;HOST&gt;</code>
    <br><br>
    Beispiel:
    <ul><br>
      <code>define fhemServer ShuttersControl localhost</code><br>
    </ul>
    <br>
    Der Befehl erstellt eine ShuttersControl Instanz mit dem Namen fhemServer und dem Host localhost.<br>
    Nachdem die Instanz erstellt wurde werden die ben&ouml;tigten Informationen geholt und als Readings angezeigt.
    Dies kann einen Moment dauern.
  </ul>
  <br><br>
  <a name="ShuttersControlreadings"></a>
  <b>Readings</b>
  <ul>
    <li>state - update Status des Servers, liegen neue Updates an oder nicht</li>
    <li>os-release_ - alle Informationen aus /etc/os-release</li>
    <li>repoSync - status des letzten repository sync.</li>
    <li>toUpgrade - status des letzten upgrade Befehles</li>
    <li>updatesAvailable - Anzahl der verf&uuml;gbaren Paketupdates</li>
  </ul>
  <br><br>
  <a name="ShuttersControlset"></a>
  <b>Set</b>
  <ul>
    <li>repoSync - holt aktuelle Informationen &uuml;ber den Updatestatus</li>
    <li>toUpgrade - f&uuml;hrt den upgrade prozess aus.</li>
    <br>
  </ul>
  <br><br>
  <a name="ShuttersControlget"></a>
  <b>Get</b>
  <ul>
    <li>showUpgradeList - Paketiste aller zur Verf&uuml;gung stehender Updates</li>
    <li>showUpdatedList - Liste aller als letztes aktualisierter Pakete, von der alten Version zur neuen Version</li>
    <li>showWarningList - Liste der letzten Warnings</li>
    <li>showErrorList - Liste der letzten Fehler</li>
    <br>
  </ul>
  <br><br>
  <a name="ShuttersControl attribut"></a>
  <b>Attributes</b>
  <ul>
    <li>disable - Deaktiviert das Device</li>
    <li>upgradeListReading - f&uuml;gt die Upgrade Liste als ein zus&auml;iches Reading im JSON Format ein.</li>
    <li>distupgrade - wechselt den upgrade Prozess nach dist-upgrade</li>
    <li>disabledForIntervals - Deaktiviert das Device f&uuml;r eine bestimmte Zeit (13:00-18:30 or 13:00-18:30 22:00-23:00)</li>
  </ul>
</ul>

=end html_DE

=cut
