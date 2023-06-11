rm -rf bin patch Scripts W10UI.ini *.cmd
git clone https://github.com/adavak/Win_ISO_Patching_Scripts_zhCN.git tmp
cd tmp/bin
rm -rf *.Appx *.xml *.cab
cd ../
mv Scripts/script_17763_x64.txt script_17763_x64.txt
rm -rf Scripts/*.txt W10UI.*
mv script_17763_x64.txt Scripts/

wget https://raw.githubusercontent.com/abbodi1406/BatUtil/master/W10UI/W10UI.cmd
wget https://raw.githubusercontent.com/abbodi1406/BatUtil/master/W10UI/W10UI.ini
sed -e 's/set "Target="/set "Target=%cd%\\ISO"/g' -e 's/set "Repo="/set "Repo=%cd%\\patch"/g' -e 's/set "Net35Source="/set "Net35Source=%cd%\\ISO\\sources\\sxs"/g' -e 's/set Cleanup=0/set Cleanup=1/g' -e 's/set ResetBase=0/set ResetBase=1/g' -e 's/set LCUwinre=0/set LCUwinre=1/g' -e 's/set UpdtBootFiles=0/set UpdtBootFiles=1/g' -e 's/set SkipEdge=0/set SkipEdge=1/g' -e 's/set AutoStart=0/set AutoStart=1/g' W10UI.cmd > ../W10UI.cmd
sed -e 's/Target        =/Target        =%cd%\\ISO/g' -e 's/Repo          =/Repo          =%cd%\\patch/g' -e 's/Net35Source   =/Net35Source   =%cd%\\ISO\\sources\\sxs/g' -e 's/Cleanup       =0/Cleanup       =1/g' -e 's/ResetBase     =0/ResetBase     =1/g' -e 's/LCUwinre      =0/LCUwinre      =1/g' -e 's/UpdtBootFiles =0/UpdtBootFiles =1/g' -e 's/SkipEdge      =0/SkipEdge      =1/g' -e 's/AutoStart     =0/AutoStart     =1/g' W10UI.ini > ../W10UI.ini
mv bin Scripts ../
cd ../
rm -rf tmp

aria2c --no-conf --check-certificate=false -x16 -s16 -j5 -c -R -d ./patch -i ./Scripts/script_17763_x64.txt

echo "@ECHO OFF&(CD /D \"%~DP0\")&(FLTMC>NUL)||(mshta vbscript:CreateObject^(\"Shell.Application\"^).ShellExecute^(\"%~snx0\",\" %*\",\"\",\"runas\",1^)^(window.close^)&&exit /b)" > ExtractingISO.cmd 
echo "set \"a7z=bin\\7z.exe\"" >> ExtractingISO.cmd
echo "set \"ISODir=ISO\"" >> ExtractingISO.cmd
echo "::dir /b /a:-d *.iso 1>nul 2>nul && (for /f \"delims=\" %%# in ('dir /b /a:-d *.iso') do set \"isofile=%%#\")" >> ExtractingISO.cmd
echo "dir /b /a:-d %USERPROFILE%\desktop\*.iso 1>nul 2>nul && (for /f \"delims=\" %%# in ('dir /b /a:-d %USERPROFILE%\desktop\*.iso') do set \"isofile=%%#\")" >> ExtractingISO.cmd
echo "%a7z% x \"%USERPROFILE%\\desktop\\%isofile%\" -o\"%~dp0%ISODir%\" -r" >> ExtractingISO.cmd