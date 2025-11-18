@echo off
setlocal enabledelayedexpansion
chcp 65001

set "BASE=%~dp0"
set "STRAT_DIR=%BASE%files\https_strategies"
set "ACTIVE_FILE=%BASE%files\https_strategies\active"

echo.
echo Доступные стратегии:
echo ------------------

set i=0
for %%f in ("%STRAT_DIR%\*.strat") do (
    set /a i+=1
    set "STRAT_!i!=%%~nxf"
    echo !i!. %%~nxf
)

echo.
set /p CHOICE=Введите номер стратегии: 

if not defined STRAT_%CHOICE% (
    echo Неверный выбор.
    exit /b
)

set "FILE_NAME=!STRAT_%CHOICE%!"
echo Выбрано: !FILE_NAME!

:: Скопировать содержимое выбранного файла напрямую
type "%STRAT_DIR%\!FILE_NAME!" > "%ACTIVE_FILE%"

echo Стратегия активирована