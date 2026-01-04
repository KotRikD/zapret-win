@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

:: Защита от повторного elevation
if defined __ELEVATED (
    set "ALREADY_ELEVATED=1"
)

:: Проверка TCP timestamps
netsh interface tcp show global | findstr /i "timestamps" | findstr /i "enabled" >nul
if !errorlevel! equ 0 (
    echo TCP временные метки уже включены
    goto :EOF
)

echo TCP временные метки выключены. Пробуем включить...

:: Попытка включения без прав
netsh interface tcp set global timestamps=enabled >nul 2>&1
if !errorlevel! equ 0 (
    echo TCP временные метки успешно включены
    goto :EOF
)

:: Если уже elevated - дальше не идём
if defined ALREADY_ELEVATED (
    echo [X] Не удалось включить TCP временные метки даже с правами администратора
    goto :EOF
)

:: Запрос прав администратора
echo Недостаточно прав. Запрашиваем права...
set "__ELEVATED=1"
"%BASE%\bin\elevator" "%~f0"

goto :EOF