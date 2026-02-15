### Fix HTML list formatting in documentation comments (HEAD -> patch-negative-tagcount_and_unbalanced-li)
>Sun, 15 Feb 2026 08:44:23 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

Updated the HTML list formatting within the documentation
comments in the FHEM/73_AutoShuttersControl.pm file.
The previous use of improper closing tags for list items
(<i>) has been corrected to proper list item tags (<li>).
This change enhances the clarity and correctness of the
documentation, ensuring that it displays properly in any
HTML-rendering environment. No functional changes were made
to the code itself, only improvements to the documentation.



### ``` Update copyright year to 2026 and fix Candlemas Day issue (origin/dev, origin/HEAD, dev)
>Sun, 15 Feb 2026 08:27:03 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

This commit updates the copyright year in multiple files of the
FHEM project from 2025 to 2026, ensuring that all files reflect
the current ownership status of Marko Oldenburg. Minor formatting
adjustments have also been made in `ShuttersControl.pm` for
better readability.

Additionally, the logic in the IsAdv function within the
ShuttersControl Helper module has been corrected to accurately
evaluate Candlemas Day, which prevents automation errors due to
miscalculations. Important usage information for the roller shutter
control module was added in both English and German, clarifying
operational requirements.

These changes do not introduce any breaking changes but are vital
for user understanding and functionality improvements. The
version has been updated to v1.0.1 to reflect these changes.
```



### Update copyright year to 2026 across all relevant files
>Sun, 15 Feb 2026 08:26:46 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

This commit updates the copyright year in multiple files of the FHEM
project from 2025 to 2026. The changes were made to reflect the
continuation of development and intellectual property rights held by
Marko Oldenburg.

Additionally, minor formatting adjustments were made in
`ShuttersControl.pm` for better readability. These changes ensure that
all files are up to date regarding copyright information and enhance
the overall code quality with properly formatted code.

No breaking changes or functional modifications were introduced with
this commit.



### Fix Candlemas Day condition in IsAdv function (origin/main, main)
>Sun, 15 Feb 2026 08:00:06 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

This commit corrects the conditional logic within the IsAdv function
of the ShuttersControl Helper module to accurately evaluate Candlemas
Day. The previous implementation miscalculated the date due to an
incorrect evaluation of the month and day, which could lead to
automation errors in shutters control based on holiday schedules.

Additionally, crucial usage information for the roller shutter control
module has been added to the documentation. New sections in both
English and German clarify operational requirements to prevent
delays when a window contact is opened. Specifically, it is emphasized
that for the functionality to work correctly, the roller shutter must
be open, the sensor should be set to open, and attributes like
ASC_ShuttersPlace and ASC_Self_Defense_Mode need proper configuration.

These enhancements do not introduce breaking changes but are essential
for improving user understanding and functionality of the
AutoShuttersControl module. The version was updated to v1.0.1 to
reflect these additions.



### fixes #147 - Fix candlemas day condition in IsAdv function
>Sun, 15 Feb 2026 07:59:46 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

This commit modifies the conditional logic in the IsAdv function
within the ShuttersControl Helper module. The existing code incorrectly
evaluated the month and day for determining if it is Candlemas Day.
The change ensures that the correct evaluation is performed, setting
the $adv and $month variables accordingly.

This adjustment is necessary to ensure accurate automation behavior
for shutters control based on holiday schedules. No breaking changes
are introduced, but it is essential for the logical flow of
the holiday-dependent functionality.



### ``` Add usage information for roller shutter control
>Wed, 5 Feb 2025 08:00:28 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

This update enhances the documentation by adding crucial
usage information for the roller shutter control module.
New sections in both English and German were introduced
to explain the necessary conditions for preventing delayed
operation when a window contact is opened.

It is clarified that for the functionality to operate
as intended, the roller shutter must be open, the sensor
needs to be set to open, and specific attributes
(ASC_ShuttersPlace and ASC_Self_Defense_Mode) must
be configured correctly. These additions aim to improve
user understanding and usability of the AutoShuttersControl
module. The version was updated to v1.0.1 to reflect
these enhancements.
```



### ``` Add important usage information for roller shutter control
>Wed, 5 Feb 2025 07:57:46 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

This update includes new sections in both English and German
explaining the conditions necessary to prevent delayed operation
of roller shutters when a window contact is opened. The changes
clarify that for this functionality to work, the roller shutter
must be open, the sensor should be set to open, and specific
attributes (ASC_ShuttersPlace and ASC_Self_Defense_Mode) must
be appropriately configured.

These additions help users understand proper settings required
for optimal functionality, improving the overall usability
and effectiveness of the AutoShuttersControl module. The version
has been updated to v1.0.1 to reflect these enhancements.
```



### docs: changelog
>Sat, 25 Jan 2025 11:14:17 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: new version
>Sat, 25 Jan 2025 11:14:01 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: Changelog
>Tue, 21 Jan 2025 18:19:54 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix: commandref
>Tue, 21 Jan 2025 18:19:42 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### docs: new changelog
>Tue, 21 Jan 2025 17:19:04 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### feat: change version
>Tue, 21 Jan 2025 17:18:12 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### feat: https://forum.fhem.de/index.php?topic=136510.0
>Sun, 12 Jan 2025 12:56:08 +0100

>Author: Marko Oldenburg (oldenburg@b1-systems.de)

>Commiter: Marko Oldenburg (oldenburg@b1-systems.de)




### Corrected some typos and missing spaces
>Thu, 26 Dec 2024 23:30:36 +0100

>Author: riedel2 (riedel2@yahoo.de)

>Commiter: riedel2 (riedel2@yahoo.de)




### docs: Changelog
>Sat, 12 Oct 2024 07:40:57 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix: remove experimental features change copyright
>Sat, 12 Oct 2024 07:40:39 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### change Copyright text
>Tue, 20 Dec 2022 14:17:08 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

new year range



### fix selfdefense
>Thu, 15 Dec 2022 09:56:26 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

change selfdefense condition in SunRiseShuttersAfterTimerFn



### Update 73_AutoShuttersControl.pm
>Wed, 9 Nov 2022 22:39:07 +0100

>Author: riedel2 (56700949+riedel2@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

added 'roommate' option at inline help for ASC_Down


### Update 73_AutoShuttersControl.pm
>Sat, 5 Nov 2022 21:52:39 +0100

>Author: riedel2 (56700949+riedel2@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

HORIZON option not yet added to german help


### closes: #116
>Tue, 30 Aug 2022 18:12:01 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: #116]



### fix CommandRef ASC_Up and ASC_Down entry
>Mon, 29 Aug 2022 13:30:37 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix is in external trigger and shading is aktive
>Mon, 29 Aug 2022 10:00:01 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: X]



### fix little typo in ASC_WindParameter
>Mon, 29 Aug 2022 09:43:06 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: no]



### Change WindUnprotectionFn if ShuttersPlace awning
>Mon, 29 Aug 2022 09:25:34 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: X]



### fix ASC_Shading_BetweenTheTime Commandref entry
>Mon, 29 Aug 2022 08:45:51 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: no]



### expane rain and wind protection control
>Mon, 20 Jun 2022 15:56:47 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

add condition for wind and rain protection

[Ticket: none]



### code review rain unprotection drive
>Tue, 19 Apr 2022 12:32:19 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### more Log out with information
>Thu, 7 Apr 2022 21:25:03 +0200

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### observed ShuttersPlace awning for shading condition
>Thu, 24 Mar 2022 09:54:55 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

[Ticket: no]



### change ShuttersInformation fn
>Fri, 4 Mar 2022 07:01:54 +0100

>Author: Marko Oldenburg (development@cooltux.net)

>Commiter: Marko Oldenburg (development@cooltux.net)

add table frame and whitespace-character to ShuttersInformation

[Ticket: no]



### fix bug if comfotPos 0
>Wed, 2 Mar 2022 16:47:56 +0100

>Author: Marko Oldenburg (development@cooltux.net)

>Commiter: Marko Oldenburg (development@cooltux.net)

if Comfort_Pos 0 and window is open then shutter is no drive

[Ticket: no]



### fix setter readings Bug
>Sat, 15 Jan 2022 15:39:29 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### change default value for ASC_advEndDate
>Mon, 10 Jan 2022 11:07:42 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix condition
>Mon, 10 Jan 2022 11:04:43 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix error in adv condition
>Mon, 10 Jan 2022 11:01:07 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### add end of advent season variable
>Mon, 10 Jan 2022 10:43:51 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)

change attribut ASC_advDate to ASC_advStartDate



### no critic for perlcritic parser
>Sun, 2 Jan 2022 08:49:58 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### bugfix
>Sun, 2 Jan 2022 08:31:38 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### coderewrite
>Sun, 2 Jan 2022 08:26:14 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### little bugfix
>Sun, 2 Jan 2022 07:55:00 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### change condition syntax of SetFn
>Sun, 2 Jan 2022 07:49:03 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### export object variable
>Sun, 2 Jan 2022 07:13:04 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### chnage require@ISA to use base
>Sun, 2 Jan 2022 06:42:49 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### bugfix
>Sat, 1 Jan 2022 20:21:26 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### change  version
>Sat, 1 Jan 2022 09:39:28 +0100

>Author: Marko Oldenburg (fhemdevelopment@cooltux.net)

>Commiter: Marko Oldenburg (fhemdevelopment@cooltux.net)




### fix FHEM::Automation::ShuttersControl::Helper::GetAttrValues
>Sat, 1 Jan 2022 09:22:19 +0100

>Author: Marko Oldenburg (development@cooltux.net)

>Commiter: Marko Oldenburg (development@cooltux.net)




### fix bareword sunsettime
>Sat, 1 Jan 2022 09:08:49 +0100

>Author: Marko Oldenburg (development@cooltux.net)

>Commiter: Marko Oldenburg (development@cooltux.net)




### fix error wrong hash sunrisetime bareword
>Sat, 1 Jan 2022 09:04:09 +0100

>Author: Marko Oldenburg (development@cooltux.net)

>Commiter: Marko Oldenburg (development@cooltux.net)




### change modul header
>Sat, 1 Jan 2022 08:55:31 +0100

>Author: Marko Oldenburg (development@cooltux.net)

>Commiter: Marko Oldenburg (development@cooltux.net)




### fix syntax error
>Wed, 8 Dec 2021 11:45:22 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix little bug is shutter position above the window tilted position and shutters place is terrace and sybType is twoState and event is window open
>Wed, 8 Dec 2021 11:35:55 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change condition for BlockingAfterManualDrive in WendowRec Section
>Wed, 8 Dec 2021 11:14:46 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change logical in condition
>Sun, 5 Dec 2021 11:01:19 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### bugfix
>Sun, 5 Dec 2021 07:44:51 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change hardBlock action if shutters pos close
>Sat, 4 Dec 2021 20:48:53 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix: #77
>Sat, 4 Dec 2021 10:50:29 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix logical issues
>Sat, 4 Dec 2021 10:22:22 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change condition of Window events if the place is terrace
>Sat, 4 Dec 2021 09:55:46 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### all shading functions are disabled when external trigger active
>Sat, 4 Dec 2021 09:28:38 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix condition
>Sat, 4 Dec 2021 09:07:31 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change condition for GetUp roommate. no shutters drive if you have been on absent or gone
>Sat, 4 Dec 2021 08:36:56 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add commandref change of Beta_User
>Mon, 29 Nov 2021 15:20:33 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### rain un-protect: keep awning open at night
>Mon, 22 Nov 2021 22:20:05 +0100

>Author: Jochen Luedering (j@chaotisch.org)

>Commiter: Jochen Luedering (j@chaotisch.org)




### closed: #68 fix bug PERL WARNING: Use of uninitialized value within %charHash in substitution iterator at lib/FHEM/Automation/ShuttersControl/Helper.pm line 1021 is FHEM startup.
>Sun, 14 Nov 2021 13:44:35 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix commandref
>Wed, 27 Oct 2021 09:59:53 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change names of CommandTemplate variables, change commadref for CommandTemplate
>Wed, 27 Oct 2021 09:43:16 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add example with owner perlfunction for ASC_CommandTemplate
>Tue, 26 Oct 2021 19:42:19 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change ASC_BlockingTime_beforNightClose and ASC_BlockingTime_beforDayOpen Attributs
>Tue, 26 Oct 2021 19:29:29 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add drive reason to CommandTemplte varibales
>Tue, 26 Oct 2021 14:05:06 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change commandref
>Mon, 25 Oct 2021 19:54:51 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix ASC_BlockingTime_beforNightClose wird bei Regen(-schutz) ignoriert
>Mon, 25 Oct 2021 19:25:13 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix Can't locate object method "getCommandTemplte"
>Mon, 25 Oct 2021 18:43:30 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add commandref enrty for ASC_CommandTemplate Attribut
>Mon, 25 Oct 2021 18:24:17 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version
>Mon, 25 Oct 2021 17:58:08 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### Patch beliebigen Fahrbefehl zulassen #53
>Mon, 25 Oct 2021 17:51:37 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### Terrasse schließen Prüfung auf externe Trigger zum nachholen der Fahrt
>Mon, 25 Oct 2021 10:02:29 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### expand regex to detect position event with dot's
>Sun, 24 Oct 2021 17:16:11 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix set rainstate by night
>Sat, 23 Oct 2021 10:08:37 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change code for ExternlTriggerStatus.
>Sat, 9 Oct 2021 08:10:09 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add EG_window to ShuttersPlace and expand ProcessingResidents Fn for close Shutter by open window then gone
>Sat, 9 Oct 2021 07:53:53 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version and contact information in all files (tag: v0.10.16)
>Sat, 9 Oct 2021 07:11:52 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix rain
>Fri, 8 Oct 2021 11:44:13 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix: #46
>Fri, 8 Oct 2021 09:55:44 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### drive awning to open position if (wind unprotected) at night
>Tue, 28 Sep 2021 11:12:14 +0200

>Author: Jochen Lüdering (jochen@luedering.de)

>Commiter: Jochen Lüdering (jochen@luedering.de)




### fix Copyright
>Tue, 14 Sep 2021 09:50:44 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix CVS ID Tag
>Tue, 14 Sep 2021 09:19:39 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### Add HMCCUDEV TYPE
>Fri, 10 Sep 2021 09:51:33 +0200

>Author: rejoe2 (rejoe2@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### Add Shelly TYPE
>Thu, 9 Sep 2021 13:11:28 +0200

>Author: rejoe2 (rejoe2@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### use "id" format, add some missing info in english
>Tue, 31 Aug 2021 12:34:04 +0200

>Author: rejoe2 (rejoe2@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### prepare vor use of "id" sections in commandref
>Tue, 31 Aug 2021 12:32:22 +0200

>Author: rejoe2 (rejoe2@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### change version to v0.10.15 (tag: v0.10.15)
>Thu, 27 May 2021 08:55:48 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add condition for window closed and status open and shuttersPlace terrace
>Tue, 25 May 2021 07:58:53 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add condition for hardLock ne off and window closed at night
>Mon, 24 May 2021 11:32:09 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix #36
>Mon, 24 May 2021 11:15:08 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version (tag: v0.10.14)
>Tue, 18 May 2021 10:43:10 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change Code for rain protection
>Tue, 18 May 2021 09:58:00 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change unprotection Code
>Tue, 18 May 2021 09:32:07 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix default value for rain waiting time
>Tue, 18 May 2021 09:01:27 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix Global symbol "$shutters" requires explicit package name
>Tue, 18 May 2021 08:50:21 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### bugfix scalar
>Tue, 18 May 2021 08:48:38 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change remove InternalTimer Routine for Rain Unprotection
>Tue, 18 May 2021 08:42:49 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add remove DelayTimer or set new then new rain protection trigger
>Tue, 18 May 2021 08:38:31 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change function call
>Mon, 17 May 2021 14:17:46 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change object call methode
>Mon, 17 May 2021 14:14:58 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### bugfix
>Mon, 17 May 2021 14:09:13 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change function name in function call
>Mon, 17 May 2021 14:05:28 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### bugfix
>Mon, 17 May 2021 10:17:15 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### bugfix
>Mon, 17 May 2021 10:11:49 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change package loading
>Mon, 17 May 2021 10:08:09 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add new file for git pre-commit
>Mon, 17 May 2021 10:02:19 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix syntax error line 1061, near "} return"
>Tue, 11 May 2021 06:19:05 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### stop CreateSunRiseSetShuttersTimer fn processing if no DevHash found for shutter device name
>Mon, 10 May 2021 08:21:00 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change Code for Window closed then place is terrace
>Thu, 29 Apr 2021 12:20:49 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### Implementation for rain unprotected delay drive, split rain function in to new asc rain package
>Tue, 27 Apr 2021 08:55:10 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix $getModeUp declaration
>Wed, 21 Apr 2021 13:21:53 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix Logikfehler? siehe Forum https://forum.fhem.de/index.php/topic,120390.msg1149463.html#msg1149463
>Sat, 17 Apr 2021 15:24:14 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix ignore shading waiting time after set current state
>Fri, 26 Feb 2021 13:59:25 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix problem with brightness and weekend function
>Wed, 3 Feb 2021 11:34:33 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix sytax error
>Mon, 4 Jan 2021 08:25:26 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix SleepPos after set party mode off if sleep pos configure
>Mon, 4 Jan 2021 08:17:09 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### patch from FunkOdyssey2001, problem with absent
>Mon, 4 Jan 2021 07:26:39 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add use HTTP::Date for IsAdv Fn
>Thu, 10 Dec 2020 09:39:30 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add commandref for AdvDate
>Fri, 20 Nov 2020 11:26:16 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add selection Adv Date, FirstAdvent or DeadSunday
>Fri, 20 Nov 2020 11:16:20 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### siehe #90 auf Github
>Tue, 17 Nov 2020 07:55:23 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### condition and log output for bug no name given in readingsBeginUpdate
>Mon, 9 Nov 2020 07:07:15 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix global shading on condition
>Mon, 9 Nov 2020 06:55:35 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add hook file
>Mon, 9 Nov 2020 06:41:31 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version
>Sun, 8 Nov 2020 07:58:38 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix wrong package name for GetAttrValues() fn
>Sun, 8 Nov 2020 07:46:33 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix drive shutter then Roommate Event asleep but down mode is absent
>Sun, 8 Nov 2020 07:29:14 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Meta.pm inclusion
>Wed, 28 Oct 2020 13:15:14 +0100

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change support mail
>Fri, 23 Oct 2020 07:20:34 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add use Meta in package main
>Mon, 19 Oct 2020 09:22:44 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### code style
>Mon, 12 Oct 2020 08:54:28 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix IsDay Fn for weekend condition
>Mon, 12 Oct 2020 07:44:54 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix detected IsDay for Brightness
>Mon, 5 Oct 2020 13:52:38 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fixes: #25
>Mon, 5 Oct 2020 13:40:24 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix typo
>Mon, 5 Oct 2020 12:57:40 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix little typo
>Mon, 5 Oct 2020 12:54:33 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix NotifyFn handling
>Mon, 5 Oct 2020 12:45:00 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add shading deaktivated logic pro shutter
>Mon, 5 Oct 2020 12:29:01 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add set global shading off logic
>Mon, 5 Oct 2020 10:37:50 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change default logic for ASC_BrightnessSensor and Morning, Evening drive value. none = -2 and -1 minimal value
>Mon, 5 Oct 2020 10:00:21 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### move terrace block code in ShuttersControl.pm
>Mon, 14 Sep 2020 08:26:05 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add new function to delete Brightness Average Array
>Mon, 7 Sep 2020 09:17:45 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add feature isNotDay and all condition for shading is true. shutter drive in the morning from ClosedPos to Shading Pos
>Fri, 4 Sep 2020 14:26:24 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change Sunrise drive code to fix SelfDefense
>Fri, 4 Sep 2020 08:31:30 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix bug in call IsAfterShuttersTimeBlocking() wrong Package Kontext
>Thu, 20 Aug 2020 11:32:56 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix numeric eq
>Tue, 18 Aug 2020 08:39:00 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change Version
>Wed, 12 Aug 2020 10:57:16 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change from %k to %H for better compability with Strawberry Perl on Windows
>Wed, 12 Aug 2020 10:55:29 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix Github #82
>Mon, 10 Aug 2020 10:56:50 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix Gifhub #79
>Mon, 10 Aug 2020 09:47:15 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix Github #77
>Mon, 10 Aug 2020 09:28:48 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version
>Thu, 6 Aug 2020 14:30:58 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change logical for drive on shading then shutter pos is closed change code in EventProcessingFunctions to call function ShadingProcessingDriveCommand
>Thu, 6 Aug 2020 09:38:07 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix window closed at night an ModeDown is roommate shutter drive open
>Tue, 4 Aug 2020 08:21:31 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix little typo
>Sun, 26 Jul 2020 17:30:57 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix Global symbol "$getClosedPos" requires explicit package
>Sun, 26 Jul 2020 17:28:39 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change Shading in Code, fix shading drive if Shutters Closed
>Sun, 26 Jul 2020 17:16:59 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix commandref for better understanding
>Thu, 9 Jul 2020 12:51:46 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add new object function to condition between the time then shading in
>Thu, 9 Jul 2020 12:26:52 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix little fn import bug
>Thu, 9 Jul 2020 11:19:47 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add Global symbol $cmdFromAnalyze import
>Thu, 9 Jul 2020 11:13:31 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add new attribut ASC_Shading_BetweenTheTime for Shading In drive only between the Time
>Thu, 9 Jul 2020 11:09:49 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add support for awning control drive by shading out
>Thu, 9 Jul 2020 10:41:21 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix wrong fn call
>Thu, 9 Jul 2020 09:23:44 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix little bug
>Thu, 9 Jul 2020 09:02:20 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add import CheckASC_ConditionsForShadingFn fn from Shading 	geändert:       lib/FHEM/Automation/ShuttersControl.pm
>Thu, 9 Jul 2020 08:56:46 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### remove Shading import fn from lib/FHEM/Automation/ShuttersControl.pm to lib/FHEM/Automation/ShuttersControl/EventProcessingFunctions.pm
>Thu, 9 Jul 2020 08:53:34 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix bug in fn export and import
>Thu, 9 Jul 2020 08:48:01 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix little bug add export for EventProcessingFunctions
>Thu, 9 Jul 2020 08:44:18 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change control file
>Thu, 9 Jul 2020 08:29:41 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add new modul file for EventProcessing functions
>Thu, 9 Jul 2020 08:21:44 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### import fn from main
>Thu, 9 Jul 2020 07:37:36 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change code style
>Wed, 8 Jul 2020 22:24:58 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix little exporter bug
>Wed, 8 Jul 2020 22:13:56 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### remove little helper function to new Helper.pm Modul file
>Wed, 8 Jul 2020 22:05:38 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change code for more shift
>Wed, 8 Jul 2020 22:04:48 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### new module files, change rain and wind code for multisensor 	geändert:       ShuttersControl.pm 	geändert:       ShuttersControl/Dev/Attr.pm 	neue Datei:     ShuttersControl/Helper.pm 	geändert:       ShuttersControl/Shading.pm 	geändert:       ShuttersControl/Shutters.pm
>Wed, 8 Jul 2020 20:46:21 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change condition for multisensor to reading RegEx only 	geändert:       lib/FHEM/Automation/ShuttersControl.pm
>Wed, 8 Jul 2020 11:34:28 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### remove IsAfterShuttersManualBlocking condition for rain-protected 	geändert:       lib/FHEM/Automation/ShuttersControl.pm
>Wed, 8 Jul 2020 10:52:22 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change condition in rain fn 	geändert:       lib/FHEM/Automation/ShuttersControl.pm
>Wed, 8 Jul 2020 10:45:49 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix EventProcessingRain val dry condition 	geändert:       lib/FHEM/Automation/ShuttersControl.pm
>Wed, 8 Jul 2020 10:33:31 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix RegEx Bug
>Wed, 8 Jul 2020 10:27:59 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix return bug in condition
>Wed, 8 Jul 2020 10:16:33 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix RegEx Bug
>Wed, 8 Jul 2020 10:12:05 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix RegEx Bug
>Wed, 8 Jul 2020 10:08:01 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix PERL WARNING: Argument "rain" isn't numeric in multiplication 	geändert:       lib/FHEM/Automation/ShuttersControl/Dev/Attr.pm
>Wed, 8 Jul 2020 10:02:29 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix bug with wrong skalar in condition 	geändert:       lib/FHEM/Automation/ShuttersControl.pm
>Tue, 7 Jul 2020 14:44:20 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version
>Mon, 6 Jul 2020 09:42:01 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version
>Mon, 6 Jul 2020 09:36:34 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add condition in Fn EventProcessingGeneral to differentiate ASC device and other sensor device in NOTIFYDEV
>Mon, 6 Jul 2020 09:32:22 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix drive condition for ASCenable and idleDetection
>Sat, 4 Jul 2020 11:14:14 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix Global symbol "$hash" requires explicit package name 	geändert:       lib/FHEM/Automation/ShuttersControl.pm
>Fri, 3 Jul 2020 13:36:59 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add delete and shutdown Fn need to delete all Shutter timer then ASC delete 	geändert:       FHEM/73_AutoShuttersControl.pm 	geändert:       lib/FHEM/Automation/ShuttersControl.pm
>Fri, 3 Jul 2020 13:27:11 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix shading out drive in open pos then shutter complete closed at night 	geändert:       lib/FHEM/Automation/ShuttersControl/Shading.pm
>Fri, 3 Jul 2020 12:48:43 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change control file
>Fri, 3 Jul 2020 11:35:46 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add shutters->getShadingLastPos for condition drivePos != ShadingLastPos
>Fri, 3 Jul 2020 08:53:23 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix ascAPIset with value 0 bug
>Thu, 2 Jul 2020 18:02:32 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### bugix crash fhem
>Thu, 2 Jul 2020 14:48:46 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix end of file
>Thu, 2 Jul 2020 14:11:23 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version
>Thu, 2 Jul 2020 14:07:59 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### export shading function in seperated file
>Thu, 2 Jul 2020 14:07:20 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix setter table in commandref
>Thu, 2 Jul 2020 12:28:58 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fixes #22 PERL WARNING: Use of uninitialized value $posAssignment
>Tue, 30 Jun 2020 12:41:08 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fixes #21
>Mon, 29 Jun 2020 19:11:29 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version
>Mon, 29 Jun 2020 17:01:33 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### remove ASC_slatDriveCmdInverse and the extended Fn Code
>Mon, 29 Jun 2020 14:06:34 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### check brightness sunset and sunrise change code
>Mon, 29 Jun 2020 13:41:46 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### remove all unless conditions
>Mon, 29 Jun 2020 09:58:53 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change ExternalTriggerState to ExternalTriggerStatus remove getExternalTriggerState from lib/FHEM/Automation/ShuttersControl/Shutters/Attr.pm and add in lib/FHEM/Automation/ShuttersControl/Shutters.pm as getExternalTriggerStatus
>Mon, 29 Jun 2020 09:02:12 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add one more condition to run ShadingProcessingDriveCommand
>Wed, 24 Jun 2020 13:26:02 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change shading info message to warn message
>Wed, 24 Jun 2020 08:11:42 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change version
>Mon, 22 Jun 2020 11:48:18 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix bug in commandref unbalanced td
>Mon, 22 Jun 2020 11:43:18 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add more commandref text change version number, patch release change commandref for rain waiting time, feature not yet implemented 	geändert:       FHEM/73_AutoShuttersControl.pm
>Fri, 19 Jun 2020 14:27:30 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### new mail
>Thu, 18 Jun 2020 08:13:48 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix empty shuttername
>Thu, 18 Jun 2020 08:07:59 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add new commandref 	geändert:       FHEM/73_AutoShuttersControl.pm
>Thu, 18 Jun 2020 07:59:54 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change constrols
>Tue, 9 Jun 2020 14:02:30 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### my
>Tue, 9 Jun 2020 13:57:17 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### create controls
>Tue, 9 Jun 2020 13:22:54 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### create controls
>Tue, 9 Jun 2020 13:22:17 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### add setter for commandref, fix roomate fn if roommate come home and shading active
>Tue, 9 Jun 2020 13:21:16 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change controls
>Fri, 5 Jun 2020 22:26:11 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change controls
>Fri, 5 Jun 2020 22:25:42 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix slat drive bug then set getSlatDriveCmdInverse
>Fri, 5 Jun 2020 22:25:17 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change control file
>Thu, 4 Jun 2020 17:57:04 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### fix Undefined subroutine &main::AutoShuttersControl_ascAPIget
>Thu, 4 Jun 2020 17:56:27 +0200

>Author: Marko Oldenburg (marko.oldenburg@cooltux.net)

>Commiter: Marko Oldenburg (marko.oldenburg@cooltux.net)




### change control file
>Thu, 4 Jun 2020 10:51:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more ascAPIget commands to commandref
>Thu, 4 Jun 2020 10:50:39 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### test
>Thu, 4 Jun 2020 10:17:25 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### more commandref
>Thu, 4 Jun 2020 10:11:08 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### test hook und change commandref
>Thu, 4 Jun 2020 09:50:33 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### test hook und change commandref
>Thu, 4 Jun 2020 09:36:29 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### test hook und change commandref
>Thu, 4 Jun 2020 09:32:07 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change controls
>Thu, 4 Jun 2020 08:22:14 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### new controls
>Thu, 4 Jun 2020 07:26:33 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading drive out of closed Pos
>Thu, 4 Jun 2020 07:21:56 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change execute condition for ShadingProcessingDriveCommand
>Wed, 3 Jun 2020 22:12:34 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading drive out of closed Pos
>Wed, 3 Jun 2020 21:59:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove use Meta in 73_AutoShuttersControl
>Wed, 3 Jun 2020 21:26:36 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add controls file for FHEM update
>Wed, 3 Jun 2020 18:36:40 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix devStateIcon
>Wed, 3 Jun 2020 18:07:16 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Ready for package and object methode
>Wed, 3 Jun 2020 18:00:56 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix diverse Fehlermeldungen
>Wed, 3 Jun 2020 16:31:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change package code in mutiple files
>Wed, 3 Jun 2020 12:59:04 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more commandref entry for asc api
>Wed, 3 Jun 2020 10:22:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add commandref attribut ASC_slatDriveCmdInverse
>Tue, 2 Jun 2020 14:47:59 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add ASC device attribut ASC_slatDriveCmdInverse
>Tue, 2 Jun 2020 14:44:50 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fixes: #17
>Tue, 2 Jun 2020 11:13:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fixes: #15
>Tue, 2 Jun 2020 10:36:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add new function getHomemode
>Sun, 24 May 2020 09:32:07 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix broken modul load
>Sat, 23 May 2020 09:00:39 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then shading out but not drive and timestamp is to old
>Fri, 22 May 2020 15:58:49 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then shading out but not drive and timestamp is to old
>Fri, 22 May 2020 15:58:16 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version number
>Thu, 21 May 2020 11:24:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fixed #11
>Thu, 21 May 2020 11:22:30 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fixes: #12 drive shutters in closePos then is not day and triggerPosInactiv
>Thu, 21 May 2020 09:49:39 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fixes: #12 drive shutters in closePos then is not day and triggerPosInactiv
>Thu, 21 May 2020 09:46:37 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change outTemp condition for shading out
>Thu, 21 May 2020 09:39:39 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change outTemp condition for shading out
>Thu, 21 May 2020 09:38:20 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change outTemp Code in ProcessingShadingBrightness7
>Thu, 21 May 2020 09:17:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change outTemp Code in ProcessingShadingBrightness7
>Thu, 21 May 2020 09:10:58 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading in drive after blocking time
>Thu, 21 May 2020 08:12:13 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shutters closed then windows closed and shutter position is privacydown position
>Fri, 15 May 2020 13:49:41 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shutters closed then windows closed and shutter position is privacydown position
>Fri, 15 May 2020 13:49:07 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix night detection
>Fri, 15 May 2020 11:02:23 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix night detection
>Fri, 15 May 2020 11:01:25 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then privacyDownPos and night drive with window open
>Tue, 12 May 2020 22:40:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then privacyDownPos and night drive with window open
>Tue, 12 May 2020 22:28:05 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### roleback to 0.6.x version
>Mon, 11 May 2020 18:57:22 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### expand commandref
>Mon, 11 May 2020 18:55:12 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug not a scalar reference
>Sat, 9 May 2020 14:50:51 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### expand API documantation
>Sat, 9 May 2020 08:40:58 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Closes: #10, add API commandref, fix Rain unprotected bug
>Fri, 1 May 2020 16:23:09 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### check roommate status then drive in shading pos
>Tue, 21 Apr 2020 23:50:04 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add my Scalar in all loop declaration, more robust for NOTIFYDEV after reboot
>Tue, 21 Apr 2020 23:29:12 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more info for shading information reading
>Tue, 21 Apr 2020 18:42:16 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Eventhandling
>Mon, 20 Apr 2020 15:17:33 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### little fix
>Mon, 20 Apr 2020 14:59:46 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more shading information in reading
>Mon, 20 Apr 2020 14:52:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more shading information at shutters
>Sun, 19 Apr 2020 17:38:43 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more shading information at shutters
>Sun, 19 Apr 2020 16:58:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add first works shadind condition info
>Sun, 19 Apr 2020 15:16:21 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### rolleback ASC_Shading_Mode default to off
>Sun, 19 Apr 2020 13:32:51 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove shutter device tempsensor in AntiFreeze condition, use only ASC device tempsensor
>Sun, 19 Apr 2020 10:10:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Privacy Positions for Slat Support
>Sat, 18 Apr 2020 18:16:06 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix drive in shading then window open
>Sat, 18 Apr 2020 15:38:24 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix ClosedPos bug then SleepPos not set
>Fri, 17 Apr 2020 22:49:22 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add off in Mode_Up Attribut for Shading Condition
>Fri, 17 Apr 2020 20:17:51 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Perlcode use in Position Attributs
>Fri, 17 Apr 2020 16:28:16 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add extra Slat Device and SlatCmd Code, add new Attribut ASC_SlatPosCmd_SlatDevice
>Fri, 17 Apr 2020 12:01:25 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more Positions for Slat Support
>Fri, 17 Apr 2020 08:28:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### first version for slat support
>Wed, 15 Apr 2020 18:23:23 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change default value für ASC_Pos_Cmd
>Wed, 15 Apr 2020 14:02:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### improve shading processing Fn
>Tue, 14 Apr 2020 08:42:39 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then ModeUp and ModeDown absent
>Tue, 14 Apr 2020 08:12:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### rollback Notify Regex, fix Shading routine in reservied out reservied
>Mon, 13 Apr 2020 14:50:06 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix drive up then roommate absent and ASC_Up absent
>Sun, 12 Apr 2020 11:21:18 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add additional condition for shutters drive out of shading
>Sun, 12 Apr 2020 11:01:31 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Fix little Bugs in Shading and Window open with shading state
>Sat, 11 Apr 2020 15:53:21 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading out drive then roommate asleep
>Sat, 11 Apr 2020 14:47:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix ShadingProcessingDriceCommand check windows open condition
>Sat, 11 Apr 2020 10:28:22 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Fri, 10 Apr 2020 15:42:44 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then shading pos drive in
>Fri, 10 Apr 2020 15:40:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading drive if current position under shading position
>Thu, 9 Apr 2020 08:16:13 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix set command in Set Fn and bug in WindowRec shading mode absent fixes: 8
>Sun, 5 Apr 2020 19:20:20 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix default value bug in getAutoAstroModeMorningHorizon AttrVal
>Sat, 4 Apr 2020 15:24:47 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version number
>Sat, 4 Apr 2020 11:46:20 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix _averageBrightness bug
>Sat, 4 Apr 2020 08:53:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little typo and condition code
>Fri, 3 Apr 2020 09:53:14 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Thu, 2 Apr 2020 00:09:50 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove return code in ShadingBrightness Fn
>Wed, 1 Apr 2020 15:15:40 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove is not day detect in shadingbrightness fn
>Wed, 1 Apr 2020 08:40:33 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix return code
>Tue, 31 Mar 2020 22:17:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change log output to level 4 for shadingbrightness fn
>Tue, 31 Mar 2020 20:53:03 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change return 0 to return and fix little shading bug
>Tue, 31 Mar 2020 20:32:02 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add logging for shading
>Tue, 31 Mar 2020 11:47:32 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix ASC_Down roommate and drive down then coming home bug
>Tue, 31 Mar 2020 07:27:49 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix return bug in Fn _getOutTempSensor
>Mon, 30 Mar 2020 17:29:07 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change all foreach statements to for
>Mon, 30 Mar 2020 12:11:21 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### bugfix after code change
>Mon, 30 Mar 2020 08:13:42 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code review and change code to PBP
>Sun, 29 Mar 2020 16:46:26 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix change code in NotifyFn
>Thu, 26 Mar 2020 23:20:21 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code change
>Thu, 26 Mar 2020 21:00:42 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Code to parseParams Fn
>Thu, 26 Mar 2020 12:02:56 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change default value for rain and wind protection, add rain protection to commandref
>Wed, 25 Mar 2020 10:01:18 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### expand Debug Logging for ShadingDriveCommand Fn
>Tue, 24 Mar 2020 18:36:51 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little bug in Brightness Fn
>Tue, 24 Mar 2020 15:06:53 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little bug in Brightness Fn
>Tue, 24 Mar 2020 14:34:32 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change RegEx m# ... # to m{ ... }xms for better formating
>Tue, 24 Mar 2020 11:14:47 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove all prototyps
>Tue, 24 Mar 2020 09:47:27 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove IsWeTomorrow Fn and change IsWe Fn to use tomorrow
>Tue, 24 Mar 2020 09:29:42 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix _IsDay Fn
>Mon, 23 Mar 2020 19:24:45 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add holidayWeekend Support for brightness
>Mon, 23 Mar 2020 12:02:17 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Sun, 22 Mar 2020 16:13:58 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix PrivacyDownStatus in Brightness
>Sun, 22 Mar 2020 16:09:59 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change commandref for ASC_Drive_Delay and ASC_Drive_DelayStart
>Sun, 22 Mar 2020 15:04:28 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add set brightness average max objects in array attribut
>Sat, 21 Mar 2020 14:16:12 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove old Attribut changes, fix little typos
>Sat, 21 Mar 2020 13:03:56 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add additional condition for holidyweekend drive Time
>Thu, 19 Mar 2020 09:46:56 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix SleepPos conditions in residents and roommates Fn
>Sun, 8 Mar 2020 08:29:19 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### bugfix SleepPosition #1
>Fri, 21 Feb 2020 09:54:12 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix AntiFreez bug
>Fri, 7 Feb 2020 09:11:04 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix antifreezeFn
>Mon, 3 Feb 2020 09:01:41 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change commandref
>Mon, 20 Jan 2020 08:40:56 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Meta release_status
>Wed, 15 Jan 2020 07:03:45 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change table summary
>Tue, 14 Jan 2020 13:17:36 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change get ShuttersInformation, add SummaryFn
>Tue, 14 Jan 2020 10:52:17 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix ExternalTrigger Bug
>Sun, 12 Jan 2020 10:29:35 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change commandref
>Sun, 12 Jan 2020 09:49:01 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove old Attributs
>Sun, 12 Jan 2020 09:23:29 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### little bugfix
>Fri, 10 Jan 2020 05:02:39 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Mon, 6 Jan 2020 15:43:24 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix SelfDefense then drive day open
>Mon, 6 Jan 2020 15:37:25 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### make beautiful code
>Sun, 5 Jan 2020 12:59:12 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add adv icon
>Sun, 5 Jan 2020 07:54:12 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix IsDay Bug use PrivacyDown
>Sun, 29 Dec 2019 20:03:52 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change RegEx for devStateIcon roommate
>Mon, 16 Dec 2019 09:01:13 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix devStateIcon for roommate come home
>Wed, 11 Dec 2019 16:31:34 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add delete event-on* and set new devStateIcon
>Wed, 11 Dec 2019 12:23:02 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add devStateIcon Fn
>Tue, 10 Dec 2019 11:22:58 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix selfDefense then coming home at privacy down brightness
>Mon, 9 Dec 2019 15:00:42 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix selfDefense then coming home at night with brightnes
>Mon, 9 Dec 2019 14:18:24 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Commandref, skip ExternalTrigger Drive from adv check
>Fri, 6 Dec 2019 09:41:55 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix close drive after selfdefense drive bug
>Thu, 28 Nov 2019 13:24:16 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix selfdefense bug then residents switch to home
>Thu, 28 Nov 2019 12:43:03 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix time format problem
>Wed, 27 Nov 2019 11:26:14 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix time format problem
>Wed, 27 Nov 2019 11:25:06 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix RegEx for Time format check
>Wed, 27 Nov 2019 10:28:05 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little bug
>Tue, 26 Nov 2019 06:32:10 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix commandref table css options
>Mon, 25 Nov 2019 11:39:10 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix brightness morning drive in with roommate condition
>Mon, 18 Nov 2019 07:22:32 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix incompatibilities with older perl version
>Sat, 16 Nov 2019 14:26:59 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Unbalanced li die zweite
>Fri, 15 Nov 2019 12:47:39 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Unbalanced li
>Fri, 15 Nov 2019 12:42:58 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### stable version 0.8 (tag: v0.8.0)
>Fri, 15 Nov 2019 11:16:48 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add advent support from 1. Advent to 6th january
>Mon, 11 Nov 2019 19:16:47 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add set sunrise/sunset Status add boot time
>Mon, 11 Nov 2019 09:32:28 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix logic bug in brightness Fn
>Sat, 9 Nov 2019 09:08:29 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Winrec Reading for Attribut ASC_WindowRec
>Fri, 8 Nov 2019 09:31:41 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### little bugfix
>Thu, 7 Nov 2019 19:28:01 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Thu, 7 Nov 2019 14:06:47 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add true false Regex for WinRec Fn
>Thu, 7 Nov 2019 13:48:56 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix PrivacyBrightnessDownVal bug
>Tue, 5 Nov 2019 16:40:54 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Commandref for ASC_ExternalTrigger
>Tue, 5 Nov 2019 14:00:40 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Attribut ASC_ExternalTriggerDevice to ASC_ExternalTrigger
>Tue, 5 Nov 2019 13:44:40 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### bugfix windw open at privacy up
>Tue, 5 Nov 2019 13:22:03 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change winrec Fn then PrivacyStatus gleich zwei
>Tue, 5 Nov 2019 10:49:36 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix global symbol error
>Mon, 4 Nov 2019 22:37:12 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading out drive after privacy down
>Mon, 4 Nov 2019 22:14:56 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little bug
>Mon, 4 Nov 2019 14:39:55 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix window close fn then Mode_Up off
>Mon, 4 Nov 2019 08:19:37 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add ExternalTriggerDevice Fn
>Mon, 4 Nov 2019 08:09:46 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code in loop for fix carsten-bug
>Sat, 2 Nov 2019 09:16:32 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add logic for window open in provacy mode
>Fri, 1 Nov 2019 11:18:53 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add commandref for privacy drive
>Fri, 1 Nov 2019 07:39:00 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix privacy time calculation between privacy and last drive
>Thu, 31 Oct 2019 16:35:11 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add privacy night close brightness with timer
>Thu, 31 Oct 2019 07:17:04 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix privacy Up Conditions
>Wed, 30 Oct 2019 15:07:23 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### finish change brightnessUp with time for drive befor last up
>Wed, 30 Oct 2019 12:43:57 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix privacy drive then brightness
>Tue, 29 Oct 2019 17:27:31 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix privacy val condition
>Tue, 29 Oct 2019 09:33:55 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix privacy drives
>Mon, 28 Oct 2019 16:34:13 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change ASC_AttrUpdateChanges Logik
>Fri, 25 Oct 2019 10:47:31 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code Style
>Fri, 25 Oct 2019 10:44:35 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Privacy Mode for Drive Up in the Morning
>Fri, 25 Oct 2019 10:44:08 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix ASC_PrivacyDownValue_befor to ASC_PrivacyDownValue_before
>Thu, 24 Oct 2019 18:27:06 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Notify Regex for ASC_BlockingValue_beforDayOpen
>Thu, 24 Oct 2019 14:07:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Attribut ASC_PrivacyDownTime_beforNightClose to ASC_PrivacyDownValue_beforNightClose, fix shutters drive in the morning if residents state absent
>Thu, 24 Oct 2019 13:53:14 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### chage sunrise and sunset drive then residentsabsent and selfdefense on
>Thu, 24 Oct 2019 10:41:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add condition to attr ASC_autoShuttersControlEvening to window event
>Mon, 7 Oct 2019 07:02:33 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add first code to delay no rain drive
>Fri, 4 Oct 2019 06:14:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add ASC_autoShuttersControl... condition in EventBrightness Fn then drive Morning or Evening
>Tue, 24 Sep 2019 10:17:50 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then ASC_Up and ASC_Down Roommate only
>Mon, 23 Sep 2019 08:11:00 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### move code for better shutter idle detection
>Sun, 22 Sep 2019 09:07:24 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix -residents come home- typo
>Sun, 22 Sep 2019 08:13:34 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix party mode then close window
>Sun, 22 Sep 2019 08:10:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### codestyle
>Fri, 20 Sep 2019 20:45:20 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove developer version
>Fri, 20 Sep 2019 20:40:15 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix partyMode and window open condition
>Fri, 20 Sep 2019 20:38:31 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Fri, 20 Sep 2019 20:36:47 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix partyMode and window open condition
>Fri, 20 Sep 2019 20:35:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change state 'home' to comin home then lastState absent or gone
>Fri, 20 Sep 2019 14:55:52 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then ASC_Up or ASC_Down ist set roommate and roommate goes home from absent or gone
>Fri, 20 Sep 2019 14:23:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more conditions to delaydrive
>Fri, 20 Sep 2019 14:03:13 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add new attributes to commandref
>Fri, 20 Sep 2019 13:52:00 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### bugfix shutter drive detection
>Fri, 20 Sep 2019 13:39:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code in ShuttersCommandSet
>Fri, 20 Sep 2019 12:55:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add code to detect shutter run, change code in ShuttersCommandSet
>Fri, 20 Sep 2019 12:53:52 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change perlCodeCheck to use AnalyzePerlCommand Fn
>Fri, 20 Sep 2019 08:34:04 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove Perlcode from Attribut ClosedPos and OpenPos
>Fri, 20 Sep 2019 06:33:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change renewSetSunriseSunsetTimer to renewAllTimer and add new setter renewTimer with select shutter
>Thu, 19 Sep 2019 14:16:04 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change attribut names and parts of code
>Thu, 19 Sep 2019 13:46:42 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add support for perl value in attributs
>Wed, 18 Sep 2019 14:55:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### commandref Anpassungen, Beschreibung der geänderten getter für das ascAPIget
>Tue, 17 Sep 2019 16:52:19 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### rewrite change Attributs
>Tue, 17 Sep 2019 16:24:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change getOffset.. to getDelay..
>Tue, 17 Sep 2019 14:07:26 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code for getOffset Fn
>Tue, 17 Sep 2019 14:03:36 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change developer tree to 0.6.100 for new version 0.8, change Attribut ASC_shutterDriveOffset #18
>Tue, 17 Sep 2019 13:42:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change commandref
>Tue, 17 Sep 2019 11:37:58 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change timelimit for restart initial frequence
>Tue, 17 Sep 2019 09:55:18 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### redesign code
>Mon, 16 Sep 2019 17:56:34 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add condition to ref ARRAY
>Mon, 16 Sep 2019 17:54:57 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code parts to remove Self_Defense_Exclude Attr
>Mon, 16 Sep 2019 17:15:02 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code to condition in ResidentsFn for absent
>Mon, 16 Sep 2019 13:57:08 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Residents absent code for window open and place terrace
>Mon, 16 Sep 2019 13:47:40 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change selfDefense Code in ResidentsFn
>Mon, 16 Sep 2019 10:12:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add SleepPos to Brightness Fn, change roommate Code for roommate only ASC_Down and ASC_Up
>Mon, 16 Sep 2019 08:49:58 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add sleep position for night close
>Thu, 12 Sep 2019 11:28:51 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add commandref for new ASC_Up/Down value roommate
>Sun, 8 Sep 2019 10:17:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code format
>Fri, 6 Sep 2019 18:40:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add fn to set new values for attributs
>Fri, 6 Sep 2019 18:36:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix privacy drive after night drive
>Thu, 5 Sep 2019 08:33:19 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Average with three Datasets
>Mon, 2 Sep 2019 14:34:42 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add terrace condition in EventWindow Fn
>Mon, 26 Aug 2019 13:11:35 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add mor debug output
>Mon, 26 Aug 2019 10:34:11 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Encode utf8 before writing debug info; fixed typo Rolllo
>Thu, 22 Aug 2019 19:42:46 +0200

>Author: vuffiraa72 (u.mersewsky+github@gmail.com)

>Commiter: vuffiraa72 (u.mersewsky+github@gmail.com)




### add EnOcean TYP support
>Thu, 22 Aug 2019 17:09:50 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove winrec check then privacy drive down
>Thu, 22 Aug 2019 06:19:31 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix selfDefense and Residents home coming then is night
>Tue, 20 Aug 2019 08:52:46 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix #50, fix Roommate absent bug
>Mon, 19 Aug 2019 10:50:34 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### exchange ASC_Down and Up check then condition Roommate and asleep awoken
>Thu, 15 Aug 2019 09:29:15 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug forum #966778
>Wed, 14 Aug 2019 10:06:05 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more condition for roommate and shading
>Mon, 12 Aug 2019 19:51:03 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix brightness morning and evening drive
>Sat, 10 Aug 2019 13:05:33 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### check if SunriseUnixTime is available before using
>Fri, 9 Aug 2019 21:19:02 +0200

>Author: vuffiraa72 (u.mersewsky+github@gmail.com)

>Commiter: vuffiraa72 (u.mersewsky+github@gmail.com)




### use utf8 encoded characters for substitution of German umlauts
>Fri, 9 Aug 2019 19:31:24 +0200

>Author: vuffiraa72 (u.mersewsky+github@gmail.com)

>Commiter: vuffiraa72 (u.mersewsky+github@gmail.com)




### fix #51
>Thu, 8 Aug 2019 13:33:19 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix ShuttersCommandSet( , ,  );
>Mon, 5 Aug 2019 11:33:21 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little typo bugs and logical problems
>Mon, 5 Aug 2019 10:07:44 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add new Dev TYPE in %posSetCmds, remove old commandref text
>Tue, 30 Jul 2019 08:51:46 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little typo
>Mon, 29 Jul 2019 13:53:18 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug in getShuttersPosCmdValueNegate
>Mon, 29 Jul 2019 13:24:49 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add new Attribut ASC_WindowRec_PosAfterDayClosed for Shutter Pos at day after closed window
>Mon, 29 Jul 2019 12:55:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little commandref typo, expand ascAPIget Fn
>Mon, 29 Jul 2019 11:28:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix doubble $ and add condition for brightness morning drive
>Sat, 20 Jul 2019 15:48:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Randomly inserted # deleted
>Tue, 16 Jul 2019 20:56:31 +0200

>Author: Christoph Morrison (post@christoph-jeschke.de)

>Commiter: Christoph Morrison (post@christoph-jeschke.de)




### fix closed strong tag
>Wed, 10 Jul 2019 17:06:04 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Fix for missing closed tag for strong (https://forum.fhem.de/index.php/topic,99980.msg956169.html#msg956169)
>Mon, 8 Jul 2019 08:45:48 +0200

>Author: Christoph Morrison (post@christoph-jeschke.de)

>Commiter: Christoph Morrison (post@christoph-jeschke.de)




### ready to version 0.6.20 (tag: v0.6.20)
>Fri, 5 Jul 2019 11:18:19 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change englisch commandref parts, fix little selfdefense bug
>Thu, 4 Jul 2019 09:48:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Wed, 3 Jul 2019 11:54:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix trigger ASC_ShuttersLastDrive Event
>Wed, 3 Jul 2019 11:54:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change 'set ASCDEVICE hardLockOut' logic
>Tue, 2 Jul 2019 09:25:18 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add getShadingLastStatusTimestamp
>Mon, 1 Jul 2019 19:36:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more condition for shadingManualDriveStatus
>Mon, 1 Jul 2019 19:32:49 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix sunrise drive with self defense and open window
>Mon, 1 Jul 2019 10:14:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix syntax error
>Sun, 30 Jun 2019 18:53:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### more condition for shading manual
>Sun, 30 Jun 2019 09:18:50 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change little Debug output and manual time condition
>Sun, 30 Jun 2019 08:42:21 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add condition for manual drive then shading
>Sat, 29 Jun 2019 19:39:44 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Fri, 28 Jun 2019 22:12:44 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix defined privacyDownStatus condition
>Fri, 28 Jun 2019 22:12:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix undefined  then roommate come home
>Fri, 28 Jun 2019 21:55:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add condition to shading out drive
>Thu, 27 Jun 2019 15:14:56 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add getQueryShuttersPos condition to ShadingDrive Fn
>Thu, 27 Jun 2019 11:18:19 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little bug, lost IsDay condition for shading drive command
>Thu, 27 Jun 2019 10:48:06 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add rain and wind protection to delayDrive condition
>Wed, 26 Jun 2019 14:00:29 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix roommate fn then in shading
>Wed, 26 Jun 2019 13:49:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading routine
>Wed, 26 Jun 2019 12:08:02 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change shading logic
>Wed, 26 Jun 2019 11:20:09 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little shading bug
>Wed, 26 Jun 2019 07:24:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix privacy mode bug, add privacy condition to wind and rain unprotection drive
>Wed, 26 Jun 2019 06:53:32 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bugs
>Tue, 25 Jun 2019 15:28:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix coming home and self defense
>Tue, 25 Jun 2019 15:13:35 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Sunrise drive in shading position
>Tue, 25 Jun 2019 13:40:09 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix undefined  in fhem.pl
>Tue, 25 Jun 2019 13:19:22 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change ASC_Self_Defense_AbsentDelay to 300
>Tue, 25 Jun 2019 12:32:25 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add delay for absent self defense
>Tue, 25 Jun 2019 12:24:25 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change prio in RoommateLastStatus, add selfDefense for absent, fix bugs
>Tue, 25 Jun 2019 09:18:50 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add shutter tempout complete
>Mon, 24 Jun 2019 12:57:52 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little Shading Bug change from aslee to home and device is inShading
>Mon, 24 Jun 2019 09:47:36 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix syntax error
>Sun, 23 Jun 2019 18:35:07 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little shading bugs
>Sun, 23 Jun 2019 18:25:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shutterplace terrace
>Sun, 23 Jun 2019 16:06:32 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix hardLock Mode
>Sun, 23 Jun 2019 15:51:37 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### delete IsDay from ShadingFn
>Sun, 23 Jun 2019 08:30:12 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add seperate temp sensor per shutter, #35
>Fri, 21 Jun 2019 14:20:08 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix #37
>Fri, 21 Jun 2019 09:58:41 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change homemmode condition for shading in shadingDrive Fn
>Fri, 21 Jun 2019 09:19:49 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change DEV_VERSION Hash
>Thu, 20 Jun 2019 13:06:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version for developer branch
>Thu, 20 Jun 2019 12:13:03 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Meta Code for version
>Wed, 19 Jun 2019 21:34:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Wed, 19 Jun 2019 16:56:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change every package code
>Tue, 18 Jun 2019 15:26:41 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Sat, 15 Jun 2019 09:57:33 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add LICENSE
>Fri, 14 Jun 2019 14:04:56 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix commandref typo's
>Fri, 14 Jun 2019 14:02:05 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little bug
>Thu, 13 Jun 2019 17:25:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add ShadingLastStatus to compare shading in and shading out
>Thu, 13 Jun 2019 15:41:03 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Thu, 13 Jun 2019 15:06:30 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change JSON Code
>Tue, 11 Jun 2019 08:05:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### try to use JSON::MaybeXS wrapper for chance of better performance + open code, thanks to Julian
>Mon, 10 Jun 2019 21:52:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix _getBrightnessSensor if no sensor device given
>Mon, 10 Jun 2019 18:42:31 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### expand Winrec Event RegEx for open_from_tilted
>Mon, 10 Jun 2019 17:55:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change more window contact values
>Mon, 10 Jun 2019 16:06:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix default Max Elevation Value
>Mon, 10 Jun 2019 15:36:02 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Just standardised some of the delimiters for attributes with options
>Mon, 10 Jun 2019 15:31:39 +0200

>Author: Christoph Morrison (post@christoph-jeschke.de)

>Commiter: Christoph Morrison (post@christoph-jeschke.de)




### Fixed speling typo in documentation
>Mon, 10 Jun 2019 15:16:38 +0200

>Author: Christoph Morrison (post@christoph-jeschke.de)

>Commiter: Christoph Morrison (post@christoph-jeschke.de)




### fix little bug
>Mon, 10 Jun 2019 14:40:24 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Closed Open to RegEx Windowevent
>Mon, 10 Jun 2019 14:23:00 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little typo bug in code
>Mon, 10 Jun 2019 14:03:03 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add ASC_Shading_MinMax_Elevation, fix bug then ASC_autoShuttersControlMarning/Evening set off
>Mon, 10 Jun 2019 13:41:46 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix window status question
>Sun, 9 Jun 2019 13:45:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix negative tagcount for table
>Sat, 8 Jun 2019 14:52:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change developer version
>Sat, 8 Jun 2019 11:19:36 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add
>Sat, 8 Jun 2019 10:54:21 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Add Date::Parse to META.json
>Fri, 7 Jun 2019 19:49:33 +0200

>Author: Julian Pawlowski (jpawlowski@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### new version
>Thu, 6 Jun 2019 08:08:00 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add text to english commandref (tag: v0.6.16)
>Thu, 6 Jun 2019 08:03:29 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add README.md file
>Tue, 4 Jun 2019 22:11:29 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change english commandref
>Tue, 4 Jun 2019 13:42:03 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add getter getIsDay for ascAPI
>Tue, 4 Jun 2019 10:53:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Fixed bug when in the evening the blind is closed and the blind position is under the window open position
>Tue, 4 Jun 2019 06:37:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add english commandref, big thanks to Christoph Morrison
>Mon, 3 Jun 2019 11:54:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix commandref bugs, delete absolet entrys
>Mon, 3 Jun 2019 11:32:50 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### delete temporary code for rename attributs, fix many commandref and code bugs (thanks to Christoph)
>Mon, 3 Jun 2019 07:44:35 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change manual drive detection code
>Mon, 3 Jun 2019 06:24:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Siro Values
>Fri, 31 May 2019 11:15:42 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix commandref
>Wed, 29 May 2019 22:49:51 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix negative tagcount for table
>Wed, 29 May 2019 22:35:33 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add shading out routine then coming home and shading mode is absent
>Tue, 28 May 2019 15:44:44 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Tue, 28 May 2019 09:27:13 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then add or delete Timer attribut and create new Sunrise/Sunset Timer
>Tue, 28 May 2019 09:23:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then IsWe or IsWeTomorrow
>Tue, 28 May 2019 08:39:52 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Debigmessages
>Mon, 27 May 2019 13:45:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more shading options
>Fri, 24 May 2019 22:24:11 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### split shadingProcessing function into two functions
>Fri, 24 May 2019 19:58:26 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fixed several typos, congruent usage of Rollladen instead of Roll(l)o
>Fri, 24 May 2019 19:56:38 +0200

>Author: Christoph Morrison (post@christoph-jeschke.de)

>Commiter: Christoph Morrison (post@christoph-jeschke.de)




### Self defense - congruent AE style
>Fri, 24 May 2019 18:54:30 +0200

>Author: Christoph Morrison (post@christoph-jeschke.de)

>Commiter: Christoph Morrison (post@christoph-jeschke.de)




### Fixed broken table tags, added tr for the table heading
>Fri, 24 May 2019 18:50:51 +0200

>Author: Christoph Morrison (post@christoph-jeschke.de)

>Commiter: Christoph Morrison (post@christoph-jeschke.de)




### Fixed broken html tag, thanks to Christoph
>Fri, 24 May 2019 13:16:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little bug
>Fri, 24 May 2019 11:49:40 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### patch Julian for more residents events
>Fri, 24 May 2019 11:31:07 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### merge patch from Christoph, expand Events RegEx for Window Events
>Fri, 24 May 2019 11:22:58 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### expand shading out drives, fix commandref ascAPIget
>Wed, 22 May 2019 13:57:04 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change API Referenz
>Mon, 20 May 2019 14:36:49 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add API Reference to Commandref
>Mon, 20 May 2019 14:23:11 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add ascAPIget Interface
>Mon, 20 May 2019 13:52:05 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add drive in shading position then residents home and shading mode home
>Mon, 20 May 2019 09:47:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Fri, 17 May 2019 21:40:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Sync with https://github.com/LeonGaultier/fhem-AutoShuttersControl/commit/5928914e214f6fb8e052f302948bb65003fad4a2#diff-53959a19fa0ce9979980d2eaa219bc1b
>Fri, 17 May 2019 15:42:58 +0200

>Author: Herr.Vorragend (hvorragend@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

CommandRef update for 'add setter so enable/disable ASC control global or shutter'


### add setter so enable/disable ASC control global or shutter
>Fri, 17 May 2019 14:20:57 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then ventilate off and comfort on, fix brightness and weekend in EventBrightness Routine
>Sat, 11 May 2019 09:50:02 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix sunrise and sunset object values
>Fri, 10 May 2019 11:39:07 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### English part of the reference removed
>Thu, 9 May 2019 18:45:30 +0200

>Author: Herr.Vorragend (hvorragend@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### Syncing english and german contents
>Thu, 9 May 2019 18:37:44 +0200

>Author: Herr.Vorragend (hvorragend@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

I've accidentally started with the english part of the reference which still includes german sentences.
There were several changes done in the past just in the english part of the reference, so that I don't know which one was the correct one.
Examples: 
Description of 'ASC_brightnessDriveUpDown', 'ASC_Drive_Offset' and 'ASC_WindProtection'

I hope that I found the correct ones.

---
FYI: Till now - only the english part is the primary part. I will swap the contents soon.


### Some more updates.
>Tue, 7 May 2019 17:37:11 +0200

>Author: Herr.Vorragend (hvorragend@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)

still unfinished


### Streamline html markup und spelling updates
>Tue, 7 May 2019 16:45:39 +0200

>Author: Herr.Vorragend (hvorragend@users.noreply.github.com)

>Commiter: GitHub (noreply@github.com)




### change version, code style
>Tue, 7 May 2019 11:34:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add debug for manual drive routine, change detect manual drive
>Tue, 7 May 2019 11:30:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix IsDay for brightness, fix EventProcessingBrightness Weekend Time
>Tue, 7 May 2019 05:58:59 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove Attribut ASC_autoControlShading and add reading / set command controlShading
>Sat, 4 May 2019 23:01:57 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading with wind and rain protection
>Sat, 4 May 2019 18:46:09 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading bug
>Sat, 4 May 2019 17:42:45 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Version for stable
>Sat, 4 May 2019 09:26:36 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### make part of associatedWith
>Fri, 3 May 2019 13:36:39 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix wrong drive time
>Fri, 3 May 2019 11:23:14 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more logic in sunrise calculation with ModeUp time
>Fri, 3 May 2019 11:03:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Fri, 3 May 2019 08:57:35 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Wind and Rain Protection query for shading
>Thu, 2 May 2019 11:49:22 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix ASC_autoShuttersControl... attributs and expand shading commandref part
>Thu, 2 May 2019 10:37:14 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Wed, 1 May 2019 15:15:41 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Wed, 1 May 2019 11:45:46 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix winrec open and drive to shading position then place is terrace
>Wed, 1 May 2019 10:11:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version and code style
>Tue, 30 Apr 2019 09:56:19 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix window closed after sunset and ModeUp absent, fix other bugs
>Tue, 30 Apr 2019 09:53:45 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Mon, 29 Apr 2019 13:24:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add attribut ASC_RainProtection
>Mon, 29 Apr 2019 13:22:37 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix numerix RegEx and value none for rain
>Mon, 29 Apr 2019 11:04:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Sun, 28 Apr 2019 22:15:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add attribut ASC_WindProtection
>Sun, 28 Apr 2019 22:13:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Sun, 28 Apr 2019 21:08:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Sun, 28 Apr 2019 08:09:47 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add support for associatedWith in shutters devices
>Sun, 28 Apr 2019 08:08:23 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Sunrise drive then We
>Sun, 28 Apr 2019 07:32:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix partyMode drive shutters with partyMode off
>Sat, 27 Apr 2019 20:58:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### ready for 0.6
>Fri, 26 Apr 2019 23:07:30 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### delete aktiv code for Roommate event and IsDay
>Fri, 26 Apr 2019 11:15:16 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix get residentsStatus bug
>Thu, 25 Apr 2019 23:07:18 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code check
>Thu, 25 Apr 2019 21:49:11 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Thu, 25 Apr 2019 21:34:46 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### commandref
>Thu, 25 Apr 2019 17:17:35 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change many code, change complete Attribut rollout
>Thu, 25 Apr 2019 17:15:56 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Wed, 24 Apr 2019 14:00:29 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Code Style
>Tue, 23 Apr 2019 15:26:16 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change windowEvent window closed LastPosition
>Tue, 23 Apr 2019 15:16:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change IsDay Fn
>Tue, 23 Apr 2019 14:53:39 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### bugfix in IsDayFn and add more Debug Messages
>Tue, 23 Apr 2019 12:33:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code
>Sat, 20 Apr 2019 21:53:05 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Sat, 20 Apr 2019 21:40:41 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix IsDay then brightness
>Sat, 20 Apr 2019 21:40:08 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug in brightnessUpDown ASC Attr
>Sat, 20 Apr 2019 18:18:50 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change commandref
>Wed, 17 Apr 2019 16:25:05 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Fri, 12 Apr 2019 13:59:15 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code for shutters drive
>Fri, 12 Apr 2019 13:58:26 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shadingMinMaxTemp comparison
>Tue, 9 Apr 2019 12:47:36 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code style
>Tue, 9 Apr 2019 12:13:46 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix many bugs in Sunrise timer calculation
>Tue, 9 Apr 2019 12:12:13 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### ShuttersSunrise
>Tue, 9 Apr 2019 09:37:34 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug with hm components
>Mon, 8 Apr 2019 10:19:09 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change scalar
>Fri, 5 Apr 2019 08:07:26 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### del unsupported code
>Thu, 4 Apr 2019 19:11:23 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Offset Logic, fix NoOffset Value, change blocking drive then window open and shutter place terrace
>Tue, 2 Apr 2019 19:28:54 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug's in shading logik and sunrise calculating
>Sun, 31 Mar 2019 17:17:56 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add blockAscDrivesAfterManual to commmandref
>Wed, 27 Mar 2019 13:16:35 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add blockAscDrivesAfterManual for complet blocking ASC drive
>Wed, 27 Mar 2019 11:22:06 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change package name and add support for META and Installer
>Wed, 27 Mar 2019 08:41:15 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change intern IsWe to global fhem.pl IsWe Fn
>Mon, 25 Mar 2019 11:23:49 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little Typo
>Mon, 25 Mar 2019 10:25:30 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix wrong Brightness Attributname
>Sun, 24 Mar 2019 16:41:48 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add shading info to shuttersInfo
>Sat, 23 Mar 2019 21:57:19 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix typo in getter
>Sat, 23 Mar 2019 13:15:44 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shading out logic error
>Sat, 23 Mar 2019 12:45:50 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change wind control logic
>Sat, 23 Mar 2019 12:06:21 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change ASC brightness Attribut, fix many Bugs
>Wed, 20 Mar 2019 21:44:00 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change commandref, change default value for ASC britgness
>Tue, 12 Mar 2019 23:50:39 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### rewrite EventProcessingWindoRec, change Attribut logic for BrightnessSensor in Shutter
>Tue, 12 Mar 2019 23:02:02 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### write code for new Attributs rename routine
>Thu, 7 Mar 2019 17:58:30 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change default values for wind parameters
>Thu, 7 Mar 2019 12:46:42 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Attribut names and Value syntax, add new Shutter device Attribut for wind
>Thu, 7 Mar 2019 10:52:23 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Code und Syntax für komplexe Attributsangaben steht, Anpassungen für die Moduleigenen Attribute vorgenommen, Wind Attribute in den Rollläden müssen noch angepasst werden
>Wed, 6 Mar 2019 15:53:48 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Commandref for old ASC Attributes
>Mon, 4 Mar 2019 14:54:51 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change all ASC Attributs for Devices in DEVICE:READING Value Combo
>Mon, 4 Mar 2019 14:02:54 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change all code to split mode
>Mon, 4 Mar 2019 10:57:39 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little bugs
>Mon, 4 Mar 2019 10:40:31 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### code clean to make faster
>Mon, 4 Mar 2019 10:10:53 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change getMode logic
>Mon, 4 Mar 2019 09:42:27 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### use split for device:reading
>Mon, 4 Mar 2019 08:40:58 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Thu, 28 Feb 2019 09:06:36 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix typo in Event RegEx for Twilight Event
>Wed, 27 Feb 2019 21:30:35 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little winrec bug then state opened (max winrec sensors)
>Wed, 27 Feb 2019 10:22:32 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add first code parts for wind
>Tue, 26 Feb 2019 12:04:10 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Codetypo in getFreezeStatus
>Tue, 26 Feb 2019 11:23:43 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Version 0.4.0.7 with WinRecOpenBeforIsDay Patch
>Tue, 26 Feb 2019 09:18:44 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix little bug then not use brightness
>Fri, 22 Feb 2019 10:56:24 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove debug messages
>Fri, 22 Feb 2019 10:16:24 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix #2, fix bug window open befor day
>Fri, 22 Feb 2019 10:02:48 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### remove code for version reload then modul reload
>Thu, 21 Feb 2019 08:24:30 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix typo in shuttersMode
>Wed, 20 Feb 2019 20:28:50 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then create timer, timer set to 1970
>Tue, 19 Feb 2019 21:18:06 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shutters drive in brightness mode then modeUp off
>Tue, 19 Feb 2019 12:00:25 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change shading logging to verbose 4
>Sat, 16 Feb 2019 19:14:25 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add support for Max contact sensor with state opened
>Sat, 16 Feb 2019 18:18:53 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix run partyMode Routine then partyMode Reading Value equevalent partyMode set Command
>Mon, 11 Feb 2019 21:26:42 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix drive down bug then driveDown absent and come window event
>Fri, 8 Feb 2019 08:13:45 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change IsAfterShuttersManualBlocking in WindowRec Routine
>Mon, 28 Jan 2019 18:20:19 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change default value for offsetStart
>Sun, 27 Jan 2019 14:36:52 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change handling then window closed, add eventhandling then change attribut ASC_PrivacyDownTime_beforNightClose
>Sun, 27 Jan 2019 14:19:51 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Loglevel in Shadingprocessing
>Wed, 23 Jan 2019 19:32:48 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add support for privacy drive befor sunset closed
>Wed, 23 Jan 2019 19:01:54 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### bugfix shutters drive then terrace door is open, set Attribut ASC_ShuttersPlace to terrace
>Wed, 23 Jan 2019 10:00:47 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Attribut driveOffsetStart delay in seconds befor Offset Value added to it
>Mon, 21 Jan 2019 12:27:22 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix shhutter drive morning up then roommate sleep and window is closed and selfdefense is on
>Thu, 17 Jan 2019 09:47:53 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix drive then brightness value and window open
>Sun, 13 Jan 2019 07:32:17 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix typo in commandref
>Mon, 7 Jan 2019 07:47:51 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix typo in commandref
>Thu, 3 Jan 2019 07:01:02 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### better logic
>Wed, 2 Jan 2019 09:38:00 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### check blockingTimeAfterManual
>Tue, 1 Jan 2019 18:54:08 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add maxBrightness for morning open
>Fri, 21 Dec 2018 19:40:16 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change loglevel to 3
>Fri, 21 Dec 2018 15:55:56 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bugs
>Fri, 21 Dec 2018 08:45:30 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code for ASC_Shading_Mode
>Fri, 7 Dec 2018 19:57:48 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change ASC_Shading_Mode values
>Fri, 7 Dec 2018 19:53:05 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### first devel version with shading support
>Fri, 7 Dec 2018 13:04:41 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Abfrage für blockiertes fahren der Rollläden nach manueller Fahrt sowie vor Sonnenauf und Sonnenuntergang Fahrten, Attribute für Helligkeitssensor umbenannt, Shading im Wort entfernt
>Fri, 7 Dec 2018 12:57:45 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### finish Shading Code for testing
>Thu, 6 Dec 2018 15:24:16 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add many code for shading
>Wed, 5 Dec 2018 15:39:11 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code style
>Wed, 5 Dec 2018 09:11:45 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix absent Event and ModeDown absent bug
>Wed, 5 Dec 2018 09:09:46 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add gone then ASC_Mode_... absent
>Tue, 4 Dec 2018 13:46:50 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change ReadingsVal to ReadingsNum for read position Reading, add setDriveReading for wiggle
>Thu, 29 Nov 2018 21:33:08 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version and code style
>Wed, 28 Nov 2018 13:11:32 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix syntax bug
>Wed, 28 Nov 2018 13:07:52 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix drive shutters then closed window and winopenpos = openpos
>Wed, 28 Nov 2018 12:14:06 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change hardBlocked code
>Thu, 22 Nov 2018 12:08:47 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change hardLockOut mode code
>Wed, 21 Nov 2018 21:56:29 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change code for lockOut hard Fn
>Wed, 21 Nov 2018 09:52:02 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### bugfix line 623
>Wed, 21 Nov 2018 08:40:17 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add window event lockOut Routine
>Wed, 21 Nov 2018 08:38:32 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version
>Tue, 20 Nov 2018 15:45:35 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change commandref
>Tue, 20 Nov 2018 15:43:07 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add support for lockOut hard protection at Z-Wave
>Tue, 20 Nov 2018 15:31:23 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version (tag: v0.2.0.9)
>Tue, 20 Nov 2018 10:36:49 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### ASC Attribut support for value zero - no creation of the attributes during the first scan or no attention to a drive command
>Tue, 20 Nov 2018 10:35:10 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change version (tag: v0.2.0.8)
>Mon, 19 Nov 2018 22:06:23 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix buf in wiggle Fn
>Mon, 19 Nov 2018 21:58:55 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then holidaywe for sunrise
>Mon, 19 Nov 2018 12:16:54 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### formated
>Mon, 19 Nov 2018 09:06:50 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### drive to LastPos then window closed and IsDay
>Mon, 19 Nov 2018 09:02:41 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change logic in eventwindow sub
>Sun, 18 Nov 2018 16:49:09 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix drive up then sunset but Drive_Mode off
>Sun, 18 Nov 2018 11:56:11 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix object call error
>Sun, 18 Nov 2018 08:13:58 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Attribut ASC_AntifreezePos
>Sat, 17 Nov 2018 22:57:09 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix LastDrive Object value then close window
>Sat, 17 Nov 2018 18:23:10 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix weekendHoliday time then use time for Drive_Up
>Sat, 17 Nov 2018 17:10:45 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### merge Packport from master branch
>Fri, 16 Nov 2018 10:54:00 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix residents bug then last state awoken or asleep and shutters up
>Fri, 16 Nov 2018 10:44:54 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more values for ASC_Antifreeze
>Fri, 16 Nov 2018 09:28:18 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change commandref
>Thu, 15 Nov 2018 22:13:26 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change antifreez attribut and code
>Thu, 15 Nov 2018 21:51:02 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### new devel version
>Thu, 15 Nov 2018 15:05:42 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### backport merge from master
>Thu, 15 Nov 2018 15:03:18 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### frostschutz umgebaut, zusätzliches Attribut AntiFreezePos, aussagekräftigere Fahrtgründe als Readingvalue, bessere Logik in Bezug auf Comfort
>Thu, 15 Nov 2018 15:01:34 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Attribut name Pos_After_Comfort, add more Shading Code
>Thu, 15 Nov 2018 10:15:36 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix add twilight device automatically, change intern structure, delete old temporary Code
>Thu, 15 Nov 2018 00:44:41 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### twilight event handling
>Wed, 14 Nov 2018 15:26:32 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add more drive information for reading ASC_ShuttersLastDrive
>Wed, 14 Nov 2018 05:44:02 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add mor drive informations in ASC_ShuttersLastDrive reading
>Wed, 14 Nov 2018 05:28:53 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add expert Attribut
>Wed, 14 Nov 2018 04:21:52 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### delete UNIRoll Hash entry
>Wed, 14 Nov 2018 03:56:47 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix double NOTIFYDEV entry by multiple scahForShutters action
>Wed, 14 Nov 2018 03:54:30 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add first function's for shading
>Wed, 14 Nov 2018 03:41:38 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Commandref Patch von Tom eingearbietet, erste Objektroutinen für die Beschattung erstellt
>Mon, 12 Nov 2018 12:56:18 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix setPosSetCmd
>Mon, 12 Nov 2018 09:12:04 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### layout
>Mon, 12 Nov 2018 09:09:30 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### style
>Mon, 12 Nov 2018 09:01:52 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix ASC_twilightDevice
>Mon, 12 Nov 2018 08:58:08 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix setPosSetCmd Object
>Sun, 11 Nov 2018 17:54:10 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix typo in commandref
>Sun, 11 Nov 2018 15:49:29 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Attribut ASC_twilightDevice with auto scan
>Sun, 11 Nov 2018 12:31:20 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### HotFix (tag: v0.2.0.1)
>Fri, 9 Nov 2018 09:11:13 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### extend engl. commandref, add first steps for shading (tag: v0.2.0)
>Fri, 9 Nov 2018 08:48:48 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Attribut Twilight nach TYPEN suche setzen
>Fri, 9 Nov 2018 08:11:16 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Modul Attribut antiFreezeTemp to freezTemp
>Thu, 8 Nov 2018 08:32:47 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### automatisches auslesen des Devicetypes vom Rolladen um den set Befehl zu erkennen. neuer Set Befehl wiggle, fix lüften position fahren ohne Offset
>Wed, 7 Nov 2018 08:22:11 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix getLastDrive
>Sun, 4 Nov 2018 21:31:05 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix roommate homecoming
>Sun, 4 Nov 2018 19:17:11 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix more bugs
>Sun, 4 Nov 2018 12:27:46 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### many bugfix and more code
>Sat, 3 Nov 2018 19:01:29 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix multiple rerun
>Fri, 2 Nov 2018 05:52:27 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix roommate bug then Mode_Up always
>Thu, 1 Nov 2018 10:03:29 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### new version
>Wed, 31 Oct 2018 09:58:23 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix IsDay and IsWe at new time calculation
>Wed, 31 Oct 2018 09:55:49 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change drive code
>Tue, 30 Oct 2018 19:10:50 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug then coming home
>Tue, 30 Oct 2018 15:26:04 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug with ASC_Down and ASC_Mode_Dpwn home then coming home after sunset
>Tue, 30 Oct 2018 08:18:09 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix many bugs, add rain sensor support
>Sun, 28 Oct 2018 18:12:40 +0100

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### one or more get, set cmd show with verbose > 3
>Sat, 27 Oct 2018 14:09:02 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add rainsensor support, add trigger all timer attribut events and renew timers
>Sat, 27 Oct 2018 13:36:11 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### new version
>Mon, 22 Oct 2018 08:06:07 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add terrace Attribut for SelfDefence Mode
>Mon, 22 Oct 2018 08:05:19 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add home to atttribut ASC_Mode_, fix bug change attribut value after restart or rescan Shutters
>Fri, 19 Oct 2018 20:13:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add shutters in notidyDev, create shutters event processing routine
>Wed, 17 Oct 2018 15:58:05 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### more OOP and data objects
>Wed, 17 Oct 2018 09:50:11 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### commandref angepasst
>Tue, 16 Oct 2018 14:55:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add get brightness Value from shutters
>Tue, 16 Oct 2018 10:30:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix typo
>Mon, 15 Oct 2018 14:51:04 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add support for resume shutters state in SelfDefense Mode
>Sun, 14 Oct 2018 18:19:23 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix object method bug
>Fri, 12 Oct 2018 06:46:42 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix weekend bug
>Fri, 12 Oct 2018 06:44:20 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix unknow object methode
>Fri, 12 Oct 2018 06:36:13 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### shutters control by brightness
>Fri, 12 Oct 2018 06:32:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix defaults values bug
>Thu, 11 Oct 2018 08:18:31 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### OOP new Design
>Wed, 10 Oct 2018 10:43:42 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add selfDefense
>Tue, 9 Oct 2018 18:05:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change Code to OOP
>Mon, 8 Oct 2018 21:05:47 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix multiple Roommate Bug, add new get and set commands
>Mon, 8 Oct 2018 03:59:51 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### commandref angepasst
>Mon, 1 Oct 2018 09:15:21 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug in roommate function
>Mon, 1 Oct 2018 08:43:59 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add multiple Roommates Support
>Sun, 30 Sep 2018 21:05:30 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### last function without multiple roommates
>Fri, 28 Sep 2018 18:39:25 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add multiple roommates
>Fri, 28 Sep 2018 18:33:24 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix WE bug, change Readingsnames
>Fri, 28 Sep 2018 08:57:25 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### typo fix
>Thu, 27 Sep 2018 12:17:20 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Bugfix bei den Attributnamen
>Thu, 27 Sep 2018 10:31:02 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Präfix von den Attributenamen geändert
>Thu, 27 Sep 2018 10:19:41 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Fix bug calculate WE Time
>Mon, 24 Sep 2018 15:29:39 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### bugfix2
>Fri, 21 Sep 2018 22:12:24 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### bugfix
>Fri, 21 Sep 2018 21:46:17 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### change timeformat, add get command
>Fri, 21 Sep 2018 20:03:02 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug for sunrise Weekend
>Fri, 21 Sep 2018 08:44:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix weekdayTomorrow bug, thanks Beta-User
>Tue, 18 Sep 2018 12:44:58 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Weekend support
>Tue, 18 Sep 2018 09:35:45 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix SetTimer Bug for next day
>Sun, 16 Sep 2018 07:19:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Fix little Bugs, add support für hard lock-out, change value of attribut AutoShuttersControl_lock-out to soft,hard - add support for AutoShuttersControl_Offset_Minutes_Evening, AutoShuttersControl_Offset_Minutes_Morning
>Fri, 14 Sep 2018 20:46:55 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### die Dämmerungsphasen lassen sich nun zur Berechnung auch in den Rolladendevices einstellen. Rolladendevice hat Vorrang vor dem globalen Einstellungen im Moduldevice
>Thu, 13 Sep 2018 15:21:29 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### HotFix Version
>Thu, 13 Sep 2018 10:38:35 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Bugfix für die Astroberechnung
>Thu, 13 Sep 2018 08:11:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bugs
>Mon, 10 Sep 2018 20:12:26 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Change Readingvalue
>Mon, 10 Sep 2018 08:27:11 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### weniger Logausgaben
>Sat, 8 Sep 2018 00:48:13 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### neue Readings für das Moduldevice hinzugefügt
>Fri, 7 Sep 2018 14:10:46 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Code aufgeräumt und Funktionen angepasst
>Fri, 7 Sep 2018 11:02:46 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### kleines bugfix beim berechnen von sunset
>Thu, 6 Sep 2018 23:38:38 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Fix Bug with sam Attributs room or subType
>Thu, 6 Sep 2018 23:01:34 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add Comfort Logik, wenn Fenster auf open und es ist ein Three State Sensor dann auf Comfort Position fahren
>Thu, 6 Sep 2018 14:00:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix Bug additional Timer
>Thu, 6 Sep 2018 11:51:08 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### HotFix gegen Dauerschleife. Bitte unbedingt einspielen
>Thu, 6 Sep 2018 09:03:28 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix bug
>Wed, 5 Sep 2018 21:03:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix typo
>Wed, 5 Sep 2018 20:48:15 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Commandref hinzugefügt und Logik gegen zweimaliges hintereinander schalten bei Anwenden von Astrosteuerung
>Wed, 5 Sep 2018 15:50:14 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### logik ausgebaut, Antifrostschutz integriert, Ausperrschutz integriert
>Tue, 4 Sep 2018 22:53:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix typo
>Tue, 4 Sep 2018 12:20:41 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Partymodus integriert
>Tue, 4 Sep 2018 11:42:47 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Version 0.1.1 bugfixes und aufräumarbeiten
>Tue, 4 Sep 2018 09:14:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### kleinen Bug gefixt
>Mon, 3 Sep 2018 22:26:31 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Define-Konzept komplett umgeschrieben
>Mon, 3 Sep 2018 22:19:25 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Beachtung WindesRec_Subtype hinzugefügt, einige bugfixes
>Mon, 3 Sep 2018 13:01:48 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### HORIZON mit Höhenwert hinzugefügt, Beachtung der Attribute AutoShuttersControl_Mode_Down und AutoShuttersControl_Mode_Up
>Sun, 2 Sep 2018 23:00:40 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### mehre Szenem für Fensterkontakt hinzugefügt
>Sat, 1 Sep 2018 22:14:49 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Codeänderung beim hinzufügen und entfernen von monitored Devices
>Sat, 1 Sep 2018 08:14:42 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### diverse Hilfsfunktionen eingebaut, Code neugeschrieben, für die fhem.pl eine Funktion geschrieben damit alle Attribute die das Modul verteilt wieder löscht und aus dem Attribut userattr entfernt
>Fri, 31 Aug 2018 09:32:16 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Sunrise Sunset Check umgebaut. Jetzt wird der nächste Tag mit eingebunden beim check
>Thu, 30 Aug 2018 10:24:39 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Code kommentiert
>Wed, 29 Aug 2018 14:58:10 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix InternalTimer Bug
>Wed, 29 Aug 2018 08:19:50 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### fix run fn after InternalTimer
>Tue, 28 Aug 2018 20:39:27 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### add WindowRec Events, add Sunrise Sunset Timer
>Tue, 28 Aug 2018 19:49:01 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### Umbau in der Logik beim finden der Rolläden, Rolladen vorerst aus NOTIFYDEV entfernt
>Mon, 27 Aug 2018 11:08:08 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### weitere Features hinzugefügt
>Thu, 16 Aug 2018 10:37:09 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




### first init
>Wed, 15 Aug 2018 10:27:53 +0200

>Author: Marko Oldenburg (leongaultier@gmail.com)

>Commiter: Marko Oldenburg (leongaultier@gmail.com)




