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




my $version = "0.0.29";


sub AutoShuttersControl_Initialize($) {
    my ($hash) = @_;

    $hash->{SetFn}      = "AutoShuttersControl::Set";
    #$hash->{GetFn}      = "ShuttersControl::Get";
    $hash->{DefFn}      = "AutoShuttersControl::Define";
    $hash->{NotifyFn}   = "AutoShuttersControl::Notify";
    $hash->{UndefFn}    = "AutoShuttersControl::Undef";
    $hash->{AttrFn}     = "AutoShuttersControl::Attr";
    $hash->{AttrList}   = "disable:0,1 ".
                            #"disabledForIntervals ".
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
use Date::Parse;

my $missingModul = "";



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
        CommandDeleteAttr
        CommandDeleteReading
        CommandSet
        AttrVal
        ReadingsVal
        IsDisabled
        deviceEvents
        init_done
        addToDevAttrList
        gettimeofday
        sunset_abs
        sunrise_abs
        InternalTimer
        RemoveInternalTimer
        computeAlignTime
    ))
};




my %userAttrList =  (   'AutoShuttersControl_Mode_Up:present,absent,always,off' =>  'always',
                        'AutoShuttersControl_Mode_Down:present,absent,always,off'   =>  'always',
                        'AutoShuttersControl_Up:time,astro' =>  'astro',
                        'AutoShuttersControl_Down:time,astro'   =>  'astro',
                        'AutoShuttersControl_Open_Pos:0,10,20,30,40,50,60,70,80,90,100'   =>  0,
                        'AutoShuttersControl_Closed_Pos_WinRecTilted:0,10,20,30,40,50,60,70,80,90,100'   =>  80,
                        'AutoShuttersControl_Closed_Pos:0,10,20,30,40,50,60,70,80,90,100'   =>  100,
                        'AutoShuttersControl_Pos_Cmd'   =>  'pct',
                        'AutoShuttersControl_Direction' =>  178,
                        'AutoShuttersControl_Time_Up_Early' =>  '05:30:00',
                        'AutoShuttersControl_Time_Up_Late'  =>  '09:00:00',
                        'AutoShuttersControl_Time_Up_WE_Holiday'    =>  '09:30:00',
                        'AutoShuttersControl_Time_Down_Early'   =>  '15:30:00', 
                        'AutoShuttersControl_Time_Down_Late'    =>   '22:30:00',
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
                        'AutoShuttersControl_Ventilate_Pos:10,20,30,40,50,60,70,80,90,100'  =>  30,
                        'AutoShuttersControl_GuestRoom:on,off'  =>  '',
                        'AutoShuttersControl_Pos_after_ComfortOpen:-2,-1,0,10,20,30,40,50,60,70,80,90,100'  =>  '',
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
    
    UserAttributsForShutters($hash,'del');
    
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
            WriteReadingsShuttersList($hash)
            unless( scalar(@{$hash->{helper}{shuttersList}} ) == 0 );
    
    } elsif( grep /^userAttrList:.rolled.out$/,@{$events}
            and $devname eq $name) {

                UserAttributsForShutters($hash,'add')
                unless( scalar(@{$hash->{helper}{shuttersList}} ) == 0 );

    } elsif( $devname eq "global" ) {
        if (grep /^(ATTR|DELETEATTR).+(AutoShuttersControl_Roommate_Device|AutoShuttersControl_WindowRec)\s/,@{$events}) {
            GeneralEventProcessing($hash,undef,join(' ',@{$events}));
        }
        
    } else {
        GeneralEventProcessing($hash,$devname,join(' ',@{$events}));
    }

    return;
}

sub GeneralEventProcessing($$$) {

    my ($hash,$devname,$events)  = @_;
    my $name            = $hash->{NAME};


    if( defined($devname) and ($devname) ) {
    
        my ($notifyDevHash)    = extractNotifyDevfromReadingString($hash,$devname);
        Log3 $name, 3, "AutoShuttersControl ($name) - EventProcessing: " . $notifyDevHash->{$devname};        
        
        foreach(@{$notifyDevHash->{$devname}}) {
        
        
            WindowRecEventProcessing($hash,(split(':',$_))[0],$events) if( (split(':',$_))[1] eq 'AutoShuttersControl_WindowRec' );
            RoommateEventProcessing($hash,(split(':',$_))[0],$events) if( (split(':',$_))[1] eq 'AutoShuttersControl_Roommate_Device' );
        
        
        
            Log3 $name, 3, "AutoShuttersControl ($name) - EventProcessing Hash Array: " . $_;
        }
    } else {
        if( $events =~ m#^ATTR\s(.*)\s(AutoShuttersControl_Roommate_Device|AutoShuttersControl_WindowRec)\s(.*)$# ) {
            AddNotifyDev($hash,$3,$1 . ':' . $2 . ':' . $3);
        
        } elsif($events =~ m#^DELETEATTR\s(.*AutoShuttersControl_Roommate_Device|AutoShuttersControl_WindowRec)$# ) {
        
            DeleteNotifyDev($hash,$1);
        }
    }
}

sub Set($$@) {
    
    my ($hash, $name, @aa)  = @_;
    
    
    my ($cmd, @args)        = @aa;

    if( lc $cmd eq 'deletenotifydev' ) {
        return "usage: $cmd" if( @args != 0 );

        
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
    
    @list = devspec2array('(Roll.*|Shutter.*):FILTER=TYPE!=AutoShuttersControl') if($hash->{DETECTDEV} eq 'auto');
    @list = split( "[ \t][ \t]*", $hash->{DEF} ) if($hash->{DETECTDEV} eq 'manual');
    
    delete $hash->{helper}{shuttersList};
    
    return unless( scalar(@list) > 0 );

    
    foreach(@list) {
        push (@{$hash->{helper}{shuttersList}},$_);
        #AddNotifyDev($hash,$_);        # Vorerst keine Shutters in NOTIFYDEV
        CreateSunRiseSetShuttersTimer($hash,$_);
        Log3 $name, 4, "AutoShuttersControl ($name) - ShuttersList: " . $_;
    }
    

    if( ReadingsVal($name,'monitoredDevs','none') ne 'none' ) {

        my ($notifyDevHash)    = extractNotifyDevfromReadingString($hash,undef);
        my $notifyDevString;
        
        while( my  (undef,$notifyDev) = each %{$notifyDevHash}) {
            $notifyDevString .= ',' . $notifyDev;
        }
        
        $hash->{NOTIFYDEV}  = $hash->{NOTIFYDEV} . $notifyDevString;
    }

    
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

sub UserAttributsForShutters($$) {

    my ($hash,$cmd) = @_;
    my $name        = $hash->{NAME};

    
    while( my ($attrib,$attribValue) = each %{userAttrList} ) {
        foreach (@{$hash->{helper}{shuttersList}}) {

            addToDevAttrList($_,$attrib);
            
            if( $cmd eq 'add' ) {
                CommandAttr(undef,$_ . ' ' . (split(':',$attrib))[0] . ' ' . $attribValue) if( defined($attribValue) and $attribValue and AttrVal($_,(split(':',$attrib))[0],'none') eq 'none' );

            } elsif( $cmd eq 'del' ) {
                CommandDeleteAttr(undef,$_ . ' ' . (split(':',$attrib))[0]);
            }
        }
    }
}

sub AddNotifyDev($@) {

    my ($hash,$dev,$readingPart)    = @_;
    
    my $name                        = $hash->{NAME};

    
    my @notifyDev;
    
    unless( $hash->{NOTIFYDEV} =~ m#$dev# ) {
        @notifyDev  = split(',',$hash->{NOTIFYDEV});
        
        push (@notifyDev,$dev);
        $hash->{NOTIFYDEV}  = join(',',@notifyDev);
    }
    
    unless( ReadingsVal($name,'monitoredDevs','none') =~ m#$readingPart# ) {
        if( ReadingsVal($name,'monitoredDevs','none') ne 'none' ) {
                readingsSingleUpdate($hash,'monitoredDevs',ReadingsVal($name,'monitoredDevs','none') . ',' . $readingPart,0);
            } else {
                readingsSingleUpdate($hash,'monitoredDevs',$readingPart,0);
            }
    }
}

sub DeleteNotifyDev($$) {

    my ($hash,$dev)     = @_;

    my $name    = $hash->{NAME};
    $dev =~ s/\s/:/g;


    my ($r,$v);
    my ($notifyDevHash)    = extractNotifyDevfromReadingString($hash,undef);
    
    my @notifyDev           = split(',',$hash->{NOTIFYDEV});
    my @notifyDevReading    = split(',',ReadingsVal($name,'monitoredDevs','none'));
    
    @notifyDev          = grep {$_ ne $notifyDevHash->{$dev}} @notifyDev;
    $hash->{NOTIFYDEV}  = join(',',@notifyDev);

    @notifyDevReading   = grep {$_ ne $dev.':'.$notifyDevHash->{$dev}} @notifyDevReading;
    readingsSingleUpdate($hash,'monitoredDevs',join(',',@notifyDevReading),0);
}

sub WindowRecEventProcessing($@) {

    my ($hash,$shuttersDev,$events)    = @_;
    
    my $name                    = $hash->{NAME};
    
    
    if($events =~ m#state:\s(open|closed|tilted)# ) {
        my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);
         
        ShuttersCommandSet($shuttersDev,ReadingsVal($shuttersDev,'AutoShuttersControl_DelayCmd',0)) unless(ReadingsVal($shuttersDev,'AutoShuttersControl_DelayCmd','none') eq 'none' and $1 ne 'closed');
    }
}

sub RoommateEventProcessing($@) {

    my ($hash,$shuttersDev,$events)    = @_;
    
    my $name                    = $hash->{NAME};
    my $reading    = AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Reading','state');

    
    if($events =~ m#$reading:\s(gotosleep|asleep|awoken|home)# ) {
    
        my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);
        
    
        Log3 $name, 3, "AutoShuttersControl ($name) - RoommateEventProcessing: $reading";
        Log3 $name, 3, "AutoShuttersControl ($name) - RoommateEventProcessing: $shuttersDev und Events $events";
    
    

        ShuttersCommandSet($shuttersDev,$openPos)
        if( ($1 eq 'home' or $1 eq 'awoken') and (ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),'lastState','none') eq 'asleep' or ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),'lastState','none') eq 'awoken') and AttrVal($name,'autoShutterControlMorning','off') eq 'on' and CheckIfSunRiseSunSet($hash,$shuttersDev,'Sunrise') );
        Log3 $name, 3, "AutoShuttersControl ($name) - RoommateEventProcessing - home awoken" if(CheckIfSunRiseSunSet($hash,$shuttersDev,'Sunrise'));
        Log3 $name, 3, "AutoShuttersControl ($name) - RoommateEventProcessing - sunrise: " . CheckIfSunRiseSunSet($hash,$shuttersDev,'Sunrise');

        if( CheckIfShuttersWindowRecOpen($shuttersDev) == 2 ) {

            ShuttersCommandDelaySet($shuttersDev,$closedPos);
            Log3 $name, 3, "AutoShuttersControl ($name) - RoommateEventProcessing - Spring in ShuttersCommandDelaySet";
        } else {
        
            ShuttersCommandSet($shuttersDev,(CheckIfShuttersWindowRecOpen($shuttersDev) == 0 ? $closedPos : $closedPosWinRecTilted))
            if( ($1 eq 'gotosleep' or $1 eq 'asleep') and AttrVal($name,'autoShuttersControlEvening','off') eq 'on' );
        }
    }
}

sub ShuttersCommandSet($$) {

    my ($shuttersDev,$posValue)   = @_;


    my $posCmd   = AttrVal($shuttersDev,'AutoShuttersControl_Pos_Cmd','pct');
    
    CommandSet(undef,$shuttersDev . ':FILTER=' . $posCmd . '!=' . $posValue . ' ' . $posCmd . ' ' . $posValue);
    readingsSingleUpdate($defs{$shuttersDev},'AutoShuttersControl_DelayCmd','none',0) if(ReadingsVal($shuttersDev,'AutoShuttersControl_DelayCmd','none') ne 'none');
}

sub ShuttersCommandDelaySet($$) {

    my ($shuttersDev,$posValue)   = @_;

    readingsSingleUpdate($defs{$shuttersDev},'AutoShuttersControl_DelayCmd',$posValue,0);
}

sub CreateSunRiseSetShuttersTimer($$) {

    my ($hash,$shuttersDev)             = @_;
    
    
    my $name                            = $hash->{NAME} if( defined($hash) and $hash );
    
    my $autoShuttersControlTimeSunset   = sunset_abs(AttrVal($name,'autoAstroModeEvening','REAL'),0,AttrVal($shuttersDev,'AutoShuttersControl_Time_Down_Early','15:30:00'),AttrVal($shuttersDev,'AutoShuttersControl_Time_Down_Late','22:30:00'));
    my $autoShuttersControlTimeSunrise  = sunrise_abs(AttrVal($name,'autoAstroModeMorning','REAL'),0,AttrVal($shuttersDev,'AutoShuttersControl_Time_Up_Early','05:30:00'),AttrVal($shuttersDev,'AutoShuttersControl_Time_Up_Late','09:00:00'));

    
    readingsBeginUpdate($defs{$shuttersDev});
    readingsBulkUpdateIfChanged( $defs{$shuttersDev},'AutoShuttersControl_Time_Sunset',(AttrVal($name,'autoShuttersControlEvening','off') eq 'on' ? $autoShuttersControlTimeSunset : 'AutoShuttersControl off') );
    readingsBulkUpdateIfChanged($defs{$shuttersDev},'AutoShuttersControl_Time_Sunrise',(AttrVal($name,'autoShutterControlMorning','off') eq 'on' ? $autoShuttersControlTimeSunrise : 'AutoShuttersControl off') );
    readingsEndUpdate($defs{$shuttersDev},0);

    
    my %arg = ('h' => $hash, 'd' => $shuttersDev);
    my $arg = \%arg;

    RemoveInternalTimer($arg,'AutoShuttersControl::SunSetShuttersAfterTimerFn');
    RemoveInternalTimer($arg,'AutoShuttersControl::SunRiseShuttersAfterTimerFn');
    
    InternalTimer(computeAlignTime('24:00',$autoShuttersControlTimeSunset), 'AutoShuttersControl::SunSetShuttersAfterTimerFn', $arg ) if( AttrVal($name,'autoShuttersControlEvening','off') eq 'on' );
    InternalTimer(computeAlignTime('24:00',$autoShuttersControlTimeSunrise), 'AutoShuttersControl::SunRiseShuttersAfterTimerFn',$arg ) if( AttrVal($name,'autoShutterControlMorning','off') eq 'on' );
}

sub SunSetShuttersAfterTimerFn($) {

    my $arg                                         = shift;
    my $hash                                        = $arg->{h};
    my $shuttersDev                                 = $arg->{d};
    
    
    my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);
    
    if( CheckIfShuttersWindowRecOpen($shuttersDev) == 2 ) {

        ShuttersCommandDelaySet($shuttersDev,$closedPos);
    } else {
        
        ShuttersCommandSet($shuttersDev,(CheckIfShuttersWindowRecOpen($shuttersDev) == 0 ? $closedPos : $closedPosWinRecTilted));
    }
    
    CreateSunRiseSetShuttersTimer($hash,$shuttersDev);
}

sub SunRiseShuttersAfterTimerFn($) {

    my $arg                                         = shift;
    my $hash                                        = $arg->{h};
    my $shuttersDev                                 = $arg->{d};
    
    
    my ($openPos,$closedPos,$closedPosWinRecTilted) = ShuttersReadAttrForShuttersControl($shuttersDev);
    
    ShuttersCommandSet($shuttersDev,$openPos) if( ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Reading','none'),'home') eq 'home' or ReadingsVal(AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Device','none'),AttrVal($shuttersDev,'AutoShuttersControl_Roommate_Reading','none'),'awoken') eq 'awoken' );
    
    CreateSunRiseSetShuttersTimer($hash,$shuttersDev);
}










#################################
## my little helper
#################################

sub extractNotifyDevfromReadingString($$) {

    my ($hash,$dev) = @_;


    my %notifyDevString;
    
    my @notifyDev = split(',',ReadingsVal($hash->{NAME},'monitoredDevs','none'));

    if( defined($dev) ) {
        foreach my $notifyDev (@notifyDev) {
            Log3 $hash->{NAME}, 3, "AutoShuttersControl ($hash->{NAME}) - extractNotifyDevfromReadingString: " . (split(':',$notifyDev))[2].'-'.(split(':',$notifyDev))[0].':'.(split(':',$notifyDev))[1];
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

sub ShuttersReadAttrForShuttersControl($) {

    my $shuttersDev                      = shift;
    
    my $shuttersOpenValue               = AttrVal($shuttersDev,'AutoShuttersControl_Open_Pos',0);
    my $shuttersClosedValue             = AttrVal($shuttersDev,'AutoShuttersControl_Closed_Pos',100);
    my $shuttersClosedByWindowRecTilted = AttrVal($shuttersDev,'AutoShuttersControl_Closed_Pos_WinRecTilted',80);

    return ($shuttersOpenValue,$shuttersClosedValue,$shuttersClosedByWindowRecTilted);
}

sub CheckIfSunRiseSunSet($@) {

    my ($hash,$shuttersDev,$sunvalue)   = @_;

    return (gettimeofday() - str2time(ReadingsVal($shuttersDev,'AutoShuttersControl_Time_' . $sunvalue,'00:00:00')) >= 0 ? 1 : 0);
}

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
  
</ul>

=end html_DE

=cut
