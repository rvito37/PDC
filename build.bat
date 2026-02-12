@echo off
REM PDC Build Script for Harbour 3.0.0
REM Usage: build.bat [clean]

set HB_PATH=C:\hb30
set PATH=%HB_PATH%\bin;%HB_PATH%\comp\mingw\bin;%PATH%

if "%1"=="clean" (
    echo Cleaning...
    del /q *.o *.exe *.c 2>nul
    echo Done.
    goto :end
)

echo ========================================
echo  Building PDC - Harbour 3.0.0
echo ========================================
echo.

hbmk2 pdc.hbp -trace

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo  BUILD SUCCESSFUL: pdc.exe
    echo ========================================
) else (
    echo.
    echo ========================================
    echo  BUILD FAILED - check errors above
    echo ========================================
)

:end
pause
