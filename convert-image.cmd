@echo off
:: ============================================
:: Image Format Converter
:: Version: 1.0.0
:: Author: Usef Farahmand
:: GitHub: https://github.com/UsefFarahmand
:: ============================================
setlocal enabledelayedexpansion

set "scriptdir=%~dp0"
set "appversion=1.0.0"

:menu
echo ============================================
echo    Image Format Converter (No Software Needed)
echo    v%appversion%
echo ============================================
echo.

:: Get the source image path from the user
set /p "srcfile=Enter the image file path (or drag and drop the file here): "

:: Strip surrounding quotes if the file was dragged in
set "srcfile=%srcfile:"=%"

if not exist "%srcfile%" (
    echo Error: No file found at that path.
    echo.
    goto ask_continue
)

:: Get the target format from the user
echo.
echo Supported formats: jpg , png , bmp , gif , tiff , ico
echo (Note: svg is NOT supported - it is a vector format and requires a dedicated tool such as Inkscape)
set /p "targetfmt=Enter the target format: "

:: Extract the folder and filename without extension
for %%F in ("%srcfile%") do (
    set "dir=%%~dpF"
    set "name=%%~nF"
)

set "outfile=!dir!!name!.%targetfmt%"

echo.
echo Converting...

powershell -NoProfile -ExecutionPolicy Bypass -File "%scriptdir%convert-image.ps1" -SourcePath "%srcfile%" -TargetFormat "%targetfmt%" -OutputPath "%outfile%"

if errorlevel 1 (
    echo.
    echo Conversion failed. Please check the format you entered.
) else (
    echo.
    echo Conversion completed successfully.
    echo Output file: !outfile!
    echo.
    echo Opening output folder...
    explorer /select,"!outfile!"
)

:ask_continue
echo.
choice /c CX /n /m "Press [C] to convert another image, or [X] to exit: "

if errorlevel 2 goto end
if errorlevel 1 (
    echo.
    cls
    goto menu
)

:end
echo.
echo Goodbye!
exit /b 0
