Dim cd
Dim fileName
cd  = wscript.arguments(0)

' Updater.apk
Const Lecture = 1, Ecriture = 2
Dim fso, f
Set fso = CreateObject("Scripting.FileSystemObject")

fileName = ""& cd & "\Decoded\Updater.apk\smali\com\android\updater\utils\SysUtils.smali"
Set f = fso.OpenTextFile(fileName, Lecture)
readalltextfile = f.ReadAll
newtextfile = Replace(readalltextfile, "http://update.miuirom.com/updates/update.json", "http://niarkman.com/projects/miui/official/ota/update.php")
Set f = fso.OpenTextFile(fileName, Ecriture, True)
f.Write newtextfile

