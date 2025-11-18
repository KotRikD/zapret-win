@echo off
setlocal enabledelayedexpansion
chcp 65001

set "ACTIVE_FILE=%~dp0https_strategies\active"

if not exist "%ACTIVE_FILE%" (
    echo Ошибка: active отсутствует!
    exit /b 1
)

set "ZAPRET_ARGS="

for /f "delims=" %%a in ('type "%ACTIVE_FILE%"') do (
    if defined ZAPRET_ARGS (
        call set "ZAPRET_ARGS=%%ZAPRET_ARGS%% %%a"
    ) else (
        call set "ZAPRET_ARGS=%%a"
    )
)

endlocal & set "ZAPRET_ARGS=%ZAPRET_ARGS%"