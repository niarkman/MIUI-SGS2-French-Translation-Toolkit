@echo off
Set /P ver= Version a compiler : 

:: Variables
Set home=%CD%
set workdir=%home%\workdir
set base=%home%\Base_ROM
set out=%home%\Output_ROM
set tools=%home%\Tools
set apktools=%tools%\apktool
set sign=%tools%\sign
set common=%tools%\Common
set zip=%tools%\7zip
set translationdir=%home%\Translation
set rom_prefix=miui-SGS2


:: Verification du nombre de fichiers dans la Base_Rom
:Debut
cls
cd %base%
dir /a-d %rom_prefix%*.zip | find /c ".zip" > NUMfiles.###
set /p count=<NUMfiles.###
cd %home%
if "%count%"=="0" GOTO NoFile
if "%count%" GTR "1" GOTO TooMuchFiles


:: Décompression de la rom d'origine
cls
echo ## Decompression de la rom origine
rmdir /S /Q %workdir%\Rom_Decompressed
mkdir %workdir%\Rom_Decompressed
cd %workdir%\Rom_Decompressed
for /r %base%\ %%i in (%rom_prefix%*.zip) DO (
set romarchive=%%i 
echo ## %romarchive%
cmd /c "%zip%\7z.exe" x %%i)

:: Récupération des fichiers à traduire / modifier
cls
echo ## Recuperation des fichiers a traduire ou modifier
echo ## %romarchive%
rmdir /S /Q %workdir%\Origin
mkdir %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\framework\framework-res.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\AccountAndSyncSettings.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\AntiSpam.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\AppShare.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\ApplicationsProvider.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Backup.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Bluetooth.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Browser.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Calculator.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Calendar.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\CalendarProvider.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\CertInstaller.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\CloudService.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Contacts.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\ContactsProvider.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\DeskClock.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\DownloadProvider.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\DownloadProviderUi.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\DrmProvider.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\DSPManager.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Email.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\FileExplorer.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\FM.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Gallery.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\LatinIME.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Launcher2.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\MiuiCamera.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\MiuiMusic.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Mms.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Monitor.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Notes.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\PackageInstaller.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Phone.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Protips.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Settings.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\SettingsProvider.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\SideKick.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\SoundRecorder.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\SuperMarket.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Superuser.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\SystemUI.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\TelephonyProvider.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\ThemeManager.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Torch.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\Updater.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\VoiceDialer.apk %workdir%\Origin
copy %workdir%\Rom_Decompressed\system\app\VpnServices.apk %workdir%\Origin

:: APKTOOL IF framework-res.apk
cls
cmd /c %tools%\apktool\apktool if %workdir%\Origin\framework-res.apk

:: Décompilation
echo ## Decompilation des APK
rmdir /S /Q %workdir%\Decoded
mkdir %workdir%\Decoded
FOR /r %workdir%\Origin\ %%i IN (*.apk) DO (
echo ## %%~ni ##
cmd /c %tools%\apktool\apktool d %%i %workdir%\Decoded\%%~nxi)
FOR /r %workdir%\Origin\ %%i IN (*.jar) DO (
echo ## %%~ni ##
cmd /c %tools%\apktool\apktool d %%i %workdir%\Decoded\%%~nxi)

:: Correction SMALI
echo ## Correction des smali
%tools%\smali.vbs %workdir%
::cmd /c %tools%\Notepad2\notepad2 %workdir%\Decoded\Mms.apk\smali\com\android\mms\ui\MmsTabActivity.smali
pause

:: Intégration de la traduction
cls 
echo ## Intégration de la traduction
FOR /r %workdir%\Origin\ %%i in (*.apk) DO (
xcopy /SY %translationdir%\%%~ni %workdir%\Decoded\%%~nxi)

:: Intégration des éléments de traduction spécifiques
FOR /r %workdir%\Origin\ %%i in (*.apk) DO (
xcopy /SY %tools%\Common\SGS2\Translation\%%~ni %workdir%\Decoded\%%~nxi)

:: Edition du fichier integers.xml pour modificaiton des valeurs animation
cls
echo ## Edition integers.xml
cmd /c %tools%\Notepad2\notepad2 %workdir%\Decoded\framework-res.apk\res\values\integers.xml

:: Compilation
cls
echo ## Compilation des APK
rmdir /S /Q %workdir%\Out
mkdir %workdir%\Out
cd %tools%\apktool
FOR /r %workdir%\Origin\ %%i IN (*.apk) DO (
echo ## %%~ni ##
cmd /c apktool b %workdir%\Decoded\%%~nxi %workdir%\Out\%%~nxi)
cd %home%

:: Intégration des éléments compilés
cls
echo ## Integration des elements compiles
cd %home%
rmdir /S /Q %workdir%\Tmp
rmdir /S /Q %workdir%\Final
mkdir %workdir%\Tmp
mkdir %workdir%\Final
mkdir %workdir%\Final\Apk
FOR /r %workdir%\Out\ %%i IN (*.apk) DO (
echo.
echo ## %%~nxi ##
mkdir %workdir%\Tmp\%%~ni
cd %workdir%\Tmp\%%~ni
cmd /c "%zip%\7z.exe x %%i"
cd %tools%
copy listfile.txt %workdir%\Tmp\%%~ni\listfile.txt
cd %workdir%\Tmp\%%~ni
copy  %workdir%\Origin\%%~nxi %workdir%\Final\Apk\%%~ni.zip
cd %workdir%\Tmp\%ver%\%%~ni\
cmd /c "%zip%\7z.exe u  %workdir%\Final\Apk\%%~ni.zip @listfile.txt"
ren %workdir%\Final\Apk\%%~ni.zip %%~nxi 
cd %home%)

:: Construction de la rom finale
cls
echo ## Construction de la rom finale
mkdir %workdir%\Final\Tmp
cd %workdir%\Final\Tmp
cmd /c "%zip%\7z.exe x %romarchive%"
cd %workdir%

xcopy /SQY %tools%\Common\All\Rom\META-INF %workdir%\Final\Tmp\META-INF\
xcopy /SQY %tools%\Common\All\Rom\boot.img %workdir%\Final\Tmp\
xcopy /SQY %tools%\Common\All\Rom\system\*.* %workdir%\Final\Tmp\system\

xcopy /SQY %tools%\Common\SGS2\Rom\META-INF %workdir%\Final\Tmp\META-INF\
xcopy /SQY %tools%\Common\SGS2\Rom\boot.img %workdir%\Final\Tmp\
xcopy /SQY %tools%\Common\SGS2\Rom\system\*.* %workdir%\Final\Tmp\system\

xcopy /SQY %workdir%\Final\Apk\*.apk %workdir%\Final\Tmp\system\app\
xcopy /SQY %workdir%\Final\Apk\framework-res.apk %workdir%\Final\Tmp\system\framework\
xcopy /SQY %workdir%\Final\Apk\*.jar %workdir%\Final\Tmp\system\framework\
del /Q %workdir%\Final\Tmp\system\app\framework-res.apk
::del /Q %workdir%\Final\Tmp\system\app\AppShare.*

:: Edition des fichiers finaux updater-script et build.prop pour modificaiton
cmd /c %tools%\Notepad2\notepad2 %workdir%\Final\Tmp\META-INF\com\google\android\updater-script
cmd /c %tools%\Notepad2\notepad2 %workdir%\Final\Tmp\system\build.prop

:: Finalisation
mkdir %out%
cd %out%
cmd /c "%zip%\7z.exe a %ver%.zip %workdir%\Final\Tmp\*"

:: SIGN
@echo ########## Signe Update ##########
echo Veuillez patienter...
java -jar %sign%\signapk.jar -w %sign%\testkey.x509.pem %sign%\testkey.pk8 %ver%.zip %ver%-signed.zip

:: FIN
cls
echo Traitement termine
cd %home%

:: Suppression des éléments temporaires
cls
echo Suppression des dossiers temporaires, veuillez patienter...
rmdir /S /Q %workdir%\Rom_Decompressed
rmdir /S /Q %workdir%\Origin
rmdir /S /Q %workdir%\Decoded
rmdir /S /Q %workdir%\Out
rmdir /S /Q %workdir%\Tmp
rmdir /S /Q %workdir%\Final


cls
set /P choix= Voulez-vous supprimer la rom de base (O/N) ?
if "%choix%"=="o" GOTO SupRomBase
if "%choix%"=="O" GOTO SupRomBase
GOTO Fin

:SupRomBase
del /Q %base%\*.zip 

:TooMuchFiles
cls
echo Le repertoire %base% ne doit contenir qu'un seul fichier zip !
echo Supprimez les fichiers inutiles et gardez uniquement la rom de base
echo.
echo. 
set /P choix= Voulez-vous recommencez le traitement (O/N) ?
if "%choix%"=="o" GOTO Debut
if "%choix%"=="O" GOTO Debut
GOTO Fin

:NoFile
cls
echo Le repertoire %base% ne contient aucun fichier zip !
echo Veuillez copier une rom de base dans le répertoire %base%...
echo.
echo. 
set /P choix= Voulez-vous recommencez le traitement (O/N) ?
if "%choix%"=="o" GOTO Debut
if "%choix%"=="O" GOTO Debut
GOTO Fin

:Fin
cd %home%