@echo off
setlocal DisableDelayedExpansion
chcp 65001 > nul

set "ACTIVE_FILE=%~dp0https_strategies\active"

if not exist "%ACTIVE_FILE%" (
    echo Ошибка: active отсутствует!
    exit /b 1
)

set "ZAPRET_ARGS="

for /f "usebackq delims=" %%a in ("%ACTIVE_FILE%") do (
    call set "ZAPRET_ARGS=%%a"
)

endlocal & set "ZAPRET_ARGS=%ZAPRET_ARGS%"