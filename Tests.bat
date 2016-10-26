@echo off

::Uninstalling already installed GPII,If any
msiexec /qn /x gpii.msi

ECHO Silent GPII installation Batch script With different Parameter values Starts

ECHO Test1:Installation with verbose log
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII  /lv "c:\gpii\log1.log"
set str1=Verbose logging started
set str2=Windows Installer installed the product. Product Name: GPII
type log1.log > log.txt
CALL :Findstr

::It is observed that the verbose log file does not override the values with Parameter selection from command line and hence few tests in this
::script fail.To make all tests "PASS" uncomment uninstall command and run the script.
msiexec /qn /x gpii.msi


ECHO Test2:Installation that does not include listeners
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII ADDLOCAL=GPIIFeature,VCRedist  /lv "c:\gpii\log2.log" 
set str1=USBListenerFeature; Installed: Absent
set str2=RFIDListenerFeature; Installed: Absent
type log2.log > log.txt 
CALL :Findstr


ECHO Test3:Installation With no listeners and Auto start on windows sign in
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII ADDLOCAL=GPIIFeature,VCRedist  /lv "c:\gpii\log3.log" GPII_AUTOSTART=1
set str1=USBListenerFeature; Installed: Absent
set str2=Modifying GPII_AUTOSTART property. Its current value is '0'. Its new value: '1'.
type log3.log > log.txt
CALL :Findstr


ECHO Test 4:Installation with no listeners and no Desktop Shortcuts
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII ADDLOCAL=GPIIFeature,VCRedist DESKTOP_SHORTCUTS=0 /lv "c:\gpii\log4.log"
set str1=USBListenerFeature; Installed: Absent
set str2=Modifying DESKTOP_SHORTCUTS property. Its current value is '1'. Its new value: '0'.
type log4.log > log.txt
CALL :Findstr

::msiexec /qn /x gpii.msi

ECHO Test 5:Installation with listeners and no Desktop shortcuts and start menu shortcuts
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII SHORTCUTS=0 /lv "c:\gpii\log5.log"
set str1=USBListenerFeature; Installed: Local
set str2=Modifying SHORTCUTS property. Its current value is '1'. Its new value: '0'.
type log5.log > log.txt
CALL :Findstr

::msiexec /qn /x gpii.msi

ECHO Test 6:Installation with listeners  and no USB listener Shortcuts
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII USB_LISTENER_SHORTCUTS=0 /lv "c:\gpii\log6.log"
set str1=USBListenerFeature; Installed: Local
set str2=USBListenerShortcuts; Installed: Absent
type log6.log > log.txt
CALL :Findstr

ECHO Test 7:Installation that Includes listeners with no RFID listener shortcuts
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII RFID_LISTENER_SHORTCUTS=0 /lv "c:\gpii\log7.log"
set str1=RFIDListenerFeature; Installed: Local
set str2=RFIDListenerShortcuts; Installed: Absent;
type log7.log > log.txt
CALL :Findstr

ECHO Test 8:Installation with Auto Start GPII on windows sign in
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII GPII_AUTOSTART=1 /lv "c:\gpii\log8.log"
set str1=Modifying GPII_AUTOSTART property. Its current value is '0'. Its new value: '1'.
set str2=USBListenerFeature; Installed: Local
type log8.log > log.txt
CALL :Findstr

ECHO Test 9:Instalation with Auto Start USB Listener on Windows sign in
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII USB_LISTENER_AUTOSTART=1 /lv "c:\gpii\log9.log"
set str1=Modifying USB_LISTENER_AUTOSTART property. Its current value is '0'. Its new value: '1'.
set str2=RFIDListenerFeature; Installed: Local
type log9.log > log.txt
CALL :Findstr


ECHO Test 10:Installation with Auto start RFID listener on Windows sign in
msiexec /qn /i GPII.msi INSTALLFOLDER=C:\GPII RFID_LISTENER_AUTOSTART=1 /lv "c:\gpii\log10.log"
set str1=Modifying RFID_LISTENER_AUTOSTART property. Its current value is '0'. Its new value: '1'.
set str2=USBListenerFeature; Installed: Local
type log10.log > log.txt
CALL :Findstr
GOTO:EOF

:Findstr
findstr /c:"%str1%"  log.txt >nul
IF %errorlevel% equ 0 (
	findstr  /c:"%str2%" log.txt >nul
		IF %errorlevel% equ 0 (echo pass) ELSE (echo Fail))
IF %errorlevel% equ 1 ( echo fail )

EXIT /B