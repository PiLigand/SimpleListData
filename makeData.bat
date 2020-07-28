:: Thomas McOscar July 26/2020
:: Creates fake listfile data in csv form

:: Creates a sub-directory where it is activated if one doesn't already exist
:: Every minute creates a new data file therein
:: continues until ctrl-C

@echo off

::Sets up a sub directory in the same dir in which to store files
set myPath=%~dp0
if not exist "%myPath%Data Files" mkdir "%myPath%Data Files"

::Runs until ctrl-C'd
:whileRunning
	::Gets datetime for file and tags and stores in dateTime
	for /F "tokens=2" %%i in ('date /t') do set mydate=%%i
	set mydate=%mydate:/=%
	set mytime=%time::=%
	set mytime=%mytime:~0,6%
	set dateTime=%mydate%_%mytime%

	::Creates the new data file with a header
	set fileName=Data-%dateTime%
	echo %fileName%
	echo DateTime; Tag; Value > "%myPath%Data Files\%fileName%.txt"

	::Creates 5 tag values for output. first gets some seed, then makes values
	set myMin=%myTime:~2,2%
	set myDay=%myDate:~2,2%
	set /a value1=%RANDOM%/32768 * %myMin% + 15
	set /a value2=%RANDOM%/32768 * %myDay%*7 + %myDay%
	set /a value3=%RANDOM%/32768 * %myDay%*2 + %myMin%
	if "%RANDOM%" GEQ "8000" (set value4=Open) Else (set value4=Closed)
	if "%RANDOM%" GEQ "16000" (set value5=On) Else (set value5=Off)

	::Spits those values into the file created above
	echo %dateTime%; Tag1; %value1% >> "%myPath%Data Files\%fileName%.txt"
	echo %dateTime%; Tag2; %value2% >> "%myPath%Data Files\%fileName%.txt"
	echo %dateTime%; Tag3; %value3% >> "%myPath%Data Files\%fileName%.txt"
	echo %dateTime%; Tag4; %value4% >> "%myPath%Data Files\%fileName%.txt"
	echo %dateTime%; Tag5; %value5% >> "%myPath%Data Files\%fileName%.txt"

	::Pauses for a minute
	timeout 60

goto :whileRunning
