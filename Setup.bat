@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION
  
REM ************************************************
REM *                                              *
REM *       Created by: M.Rakhisi                  *
REM *       Repo: Http://github.com/p9q/art        *
REM *       Email: mrid89@gmail.com                *
REM *       Date: 19/6/2016                        *
REM *                                              *
REM ************************************************


REM Open maximized window
IF NOT "%1" == "max" (
	START /MAX CMD /c %0 max
	EXIT /b
) 

REM Set color inot bright white
COLOR F

REM set color
FOR /F "tokens=1,2 delims=#" %%a IN ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') DO  SET "DEL=%%a"

REM Author
	<NUL > X SET /p ".=."
	CALL :SetColor 03 "Artisan Shortener v0.1 by M.Rakhisi "
	ECHO.
	IF EXIST X DEL X >NUL
	



REM Create var, icon and bin folders if they are not exists
IF NOT EXIST "%APPDATA%\Artisan\var" MKDIR "%APPDATA%\Artisan\var"
IF NOT EXIST "%APPDATA%\Artisan\bin" MKDIR "%APPDATA%\Artisan\bin"
IF NOT EXIST "%APPDATA%\Artisan\icon" MKDIR "%APPDATA%\Artisan\icon"

REM copy icon if they are not exists
IF NOT EXIST "%APPDATA%\Artisan\icon\Laravel.ico" XCOPY "%~dp0icon\Laravel.ico" "%APPDATA%\Artisan\icon" > NUL

REM A line break
ECHO.

REM Check if php.exe is already exists
IF EXIST "%SYSTEMDRIVE%\xampp\php\php.exe" (
	SET PHP_Dir="%SYSTEMDRIVE%\xampp\php\php.exe"
	GOTO SkipGetPhpPath
) ELSE IF EXIST "%APPDATA%\Artisan\var\php.txt" (
	SET /p PHP_Dir=<"%APPDATA%\Artisan\var\php.txt"
	GOTO SkipGetPhpPath
) ELSE (
	<NUL > X SET /p ".=."
	CALL :SetColor 6F "WARNING: If you haven't installed PHP yet, It is recommended to install XAMPP package, You can download it from "
	CALL :SetColor 1F "www.apachefriends.org"
	ECHO.
	ECHO.
	IF EXIST X DEL X >NUL
	:ReTypePHPPath
	SET /p PHP_Dir="Enter the path of PHP(For example: C:\xampp\php\php.exe):"
	FOR %%i IN ("!PHP_Dir!") DO ( 
		SET PHPEXE=%%~di%%~piPHP.exe
	)
	IF EXIST !PHPEXE! (
		ECHO !PHP_Dir!>"%APPDATA%\Artisan\var\php.txt"
		ECHO.
		<NUL > X SET /p ".=."
		CALL :SetColor 2F "SUCCESS: PHP.exe detected successfully."
		IF EXIST X DEL X >NUL
		ECHO.
		ECHO.
	) ELSE (
		ECHO.
		<NUL > X SET /p ".=."
		CALL :SetColor 4F "ERROR: PHP.exe not found, enter the correct path please..."
		ECHO.
		IF EXIST X DEL X >NUL
		ECHO.
		GOTO ReTypePHPPath
	)
	
	GOTO SkipGetPhpPath
) 
:SkipGetPhpPath
REM Get ConEmu.exe path or check if it's already exists
IF EXIST "%APPDATA%\Artisan\var\conemu.txt" (
	SET /p TargetPath=<"%APPDATA%\Artisan\var\conemu.txt"
	IF EXIST !TargetPath! (
		SET CEEXE=!TargetPath!
		GOTO SkipGetConEmuPath
	)
)

<NUL > X SET /p ".=."
	CALL :SetColor 6F "WARNING: Before this step you need to download and install Console Emulator from "
	CALL :SetColor 1F "Http:ConEmu.github.io"
	ECHO.
	IF EXIST X DEL X >NUL
:ReTypeTargetPath
ECHO.
SET /p TargetPath="Enter the path of Console Emulator(For example: C:\ConEmuPack.160416\ConEmu.exe):"
FOR %%i IN ("!TargetPath!") DO ( 
		SET CEEXE=%%~di%%~piConEmu.exe
	)
IF NOT EXIST !CEEXE! (
	ECHO.
	<NUL > X SET /p ".=."
	CALL :SetColor 4F "ERROR: ConEmu.exe not found, enter the correct path please..."
	ECHO.
	IF EXIST X DEL X >NUL
	GOTO ReTypeTargetPath
) ELSE ( 
	ECHO !CEEXE!>"%APPDATA%\Artisan\var\conemu.txt"
	ECHO.
	<NUL > X SET /p ".=."
	CALL :SetColor 2F "SUCCESS: PHP.exe detected successfully."
	IF EXIST X DEL X >NUL
	ECHO.
	ECHO.
)
:SkipGetConEmuPath

REM Create art.bat if it's not already exists
IF NOT EXIST "%APPDATA%\Artisan\bin\art.bat" (
	ECHO ^@ECHO off > "%APPDATA%\Artisan\bin\art.bat" & ECHO. !PHP_Dir! artisan %%* >> "%APPDATA%\Artisan\bin\art.bat"
	<NUL > X SET /p ".=."
		CALL :SetColor 3F "INFO: From now on use 'art' instead of 'php artisan', For example: art route:list "
		ECHO.
		ECHO.
		IF EXIST X DEL X >NUL
	
) 

REM Create environment variable
SET pathVars=%path%
SET artPath=%SYSTEMDRIVE%\Users\Bisiv\AppData\Roaming\Artisan\bin
IF "x!pathVars:%artPath%=!"=="x%pathVars%" (
	FLTMC >nul 2>&1 && (
		REM REG add HKCU\Environment /v PATH /d "C:\Users\Bisiv\AppData\Roaming\Artisan\bin;%path%" /f
		SETX PATH "%artPath%" /m >NUL 2>&1
	) || (
		<NUL > X SET /p ".=."
		CALL :SetColor 4F "ERROR: Access is denied, Can't add environment variable, Please right click on Setup file and select Run as administrator..."
		ECHO.
		IF EXIST X DEL X >NUL
		PAUSE
		EXIT /b
	)
)
FOR %%i IN ("!TargetPath!") DO ( 
		SET CEXML=%%~di%%~piConEmu.xml
		SET CXPath=%%~di%%~pi
	)
IF EXIST !CEEXE! (
	IF EXIST !CEXML! (
		SET commentTemp=*       Created by: M.Rakhisi                  *
		FOR /f "skip=4 tokens=* delims=" %%G IN (!CEXML!) DO IF NOT DEFINED cmt SET "cmt=%%G"
		IF !cmt!==!commentTemp! ( 
			GOTO SkipCopyConEmuXML 
		) ELSE (
			<NUL > X SET /p ".=."
			CALL :SetColor 0F "Your Console Emulator doesn't have custom settings, May I copy them [Y,N]?"
			IF EXIST X DEL X >NUL
			CHOICE /N /M ""
			IF ERRORLEVEL 2 GOTO CopyNotConfirmed
			IF ERRORLEVEL 1 GOTO CopyConfirmed
	
			:CopyConfirmed
			REN "!CEXML!" "ConEmu.xml.bak"
			IF NOT ERRORLEVEL 1 ( 
				XCOPY "%~dp0settings\ConEmu.xml" "!CXPath!" > NUL 
				ECHO.
				<NUL > X SET /p ".=."
				CALL :SetColor 2F "SUCCESS: The Settings have been copied successfully."
				IF EXIST X DEL X >NUL
				ECHO.
				ECHO.
			)
			GOTO SkipCopyConEmuXML
			:CopyNotConfirmed
			ECHO.
			<NUL > X SET /p ".=."
			CALL :SetColor 4F "Nothing copied."
			IF EXIST X DEL X >NUL
			ECHO.
			ECHO.
			GOTO SkipCopyConEmuXML
		)
	) ELSE ( 
		IF NOT ERRORLEVEL 1 ( 
			XCOPY "%~dp0settings\ConEmu.xml" "!CXPath!" > NUL
			<NUL > X SET /p ".=."
			CALL :SetColor 2F "SUCCESS: The settings file has been copied successfully."
			IF EXIST X DEL X >NUL
			ECHO.
			ECHO.
		)
	)
)
:SkipCopyConEmuXML
REG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Source Code Pro Semibold (TrueType)" >NUL 2>&1
IF %ERRORLEVEL% == 1 (
	FLTMC >NUL 2>&1 && (
		REM Install font
		IF NOT EXIST "%WINDIR%\Fonts\SourceCodePro-Semibold.ttf" (
			XCOPY "%~dp0font\SourceCodePro-Semibold.ttf" "%WINDIR%\Fonts" > NUL
		)
		REM Set font in Registry
		REG add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Source Code Pro Semibold (TrueType)" /t REG_SZ /d SourceCodePro-Semibold.ttf /f >NUL 2>&1
		
		IF NOT ERRORLEVEL 1 ( 
			<NUL > X SET /p ".=."
			CALL :SetColor 2F "SUCCESS: The Font has been copied successfully."
			IF EXIST X DEL X >NUL
			ECHO.
			ECHO.
		)
		
	) || (
		<NUL > X SET /p ".=."
		CALL :SetColor 4F "ERROR: Access is denied, Can't set font in Registry, Please right click on Setup file and select Run as administrator..."
		ECHO.
		ECHO.
		IF EXIST X DEL X >NUL
		PAUSE
		EXIT /b
	)
) 
SET /p LinkName="Enter the name of your Laravel project(For example: Blog):"
ECHO.
:ReTypeProjectPath
SET /p projectPath="Enter the path of your Laravel project(For example: C:\xampp\htdocs\Blog):"
ECHO.
IF NOT EXIST !projectPath!\artisan (
	<NUL > X SET /p ".=."
	CALL :SetColor 4F "ERROR:The Laravel project not found, Enter the correct Path please..."
	ECHO.
	ECHO.
	IF EXIST X DEL X >NUL
	GOTO ReTypeProjectPath
)

SET linkDest=%%HOMEDRIVE%%%%HOMEPATH%%\Desktop\!LinkName!.lnk
SET linkArgs=-Max -Title ""!LinkName! ^<Artisan^>"" -Icon ""%APPDATA%\Artisan\icon\laravel.ico"" -cmd cmd -cur_console:C:""%APPDATA%\Artisan\icon\laravel.ico"" /k cd ""!projectPath!"" ^& prompt $G$G
SET linkIconLoc=%APPDATA%\Artisan\icon\laravel.ico
SET CS=CreateShortcut.vbs
(
	(
		ECHO Set WS = WScript.CreateObject^("WScript.Shell"^) 
		ECHO lnkFile = WS.ExpandEnvironmentStrings^("!linkDest!"^)
		ECHO Set lnk = WS.CreateShortcut^(lnkFile^) 
		ECHO lnk.TargetPath = WS.ExpandEnvironmentStrings^("!CEEXE!"^)
		ECHO lnk.Arguments = WS.ExpandEnvironmentStrings^("!linkArgs!"^)
		ECHO lnk.IconLocation = WS.ExpandEnvironmentStrings^("!linkIconLoc!"^)
		ECHO lnk.Save
	)1>!CS!
	CSCRIPT //nologo .\!CS!
	DEL !CS! /f /q
)
IF NOT ERRORLEVEL 1 ( 
	<NUL > X SET /p ".=."
		CALL :SetColor 2F "SUCCESS: A link to Artisan of "!LinkName!" project has been successfully copied on the Desktop."
		IF EXIST X DEL X >NUL
		ECHO.
		ECHO.
		PAUSE
)		
:SetColor
SET "param=^%~2" !
SET "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\X" NUL
<NUL SET /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"

ENDLOCAL