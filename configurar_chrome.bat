@echo off
setlocal enabledelayedexpansion
cls

set "CHROME_DATA=%LocalAppData%\Google\Chrome\User Data"
set "STORE_URL=https://chromewebstore.google.com/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo"
set "SCRIPT_PATH=%~dp0claude_detector.user.js"

if not exist "%CHROME_DATA%" (
    echo [Error] No se encontro la carpeta de datos de Google Chrome.
    pause
    exit
)

:menu
cls
echo =======================================================
echo          CONFIGURADOR AUTOMATICO DE CHROME
echo =======================================================
echo  1. Instalar Extension Tampermonkey (En todos los perfiles)
echo  2. Instalar Script Detector Local  (En todos los perfiles)
echo  3. Crear nuevos perfiles de Chrome en rafaga
echo  4. Salir
echo =======================================================
echo.
set /p OPT="Elige una opcion (1-4): "

if "%OPT%"=="1" goto paso1
if "%OPT%"=="2" goto paso2
if "%OPT%"=="3" goto paso3
if "%OPT%"=="4" exit
goto menu

:paso1
cls
echo [Progreso] Abriendo Chrome Web Store en cada perfil detectado...
set /a C1=0
if exist "%CHROME_DATA%\Default" (
    set /a C1+=1
    start chrome.exe --profile-directory="Default" "%STORE_URL%"
)
for /d %%i in ("%CHROME_DATA%\Profile *") do (
    set "PERF=%%~nxi"
    set /a C1+=1
    start chrome.exe --profile-directory="!PERF!" "%STORE_URL%"
)
echo [Listo] Se abrieron %C1% ventanas. Haz clic en "Anadir a Chrome" en cada una.
pause
goto menu

:paso2
cls
if not exist "%SCRIPT_PATH%" (
    echo [Error] No se encontro 'claude_detector.user.js' en esta carpeta.
    pause
    goto menu
)
echo [Progreso] Inyectando script de Tampermonkey en cada perfil...
set /a C2=0
if exist "%CHROME_DATA%\Default" (
    set /a C2+=1
    start chrome.exe --profile-directory="Default" "%SCRIPT_PATH%"
)
for /d %%i in ("%CHROME_DATA%\Profile *") do (
    set "PERF=%%~nxi"
    set /a C2+=1
    start chrome.exe --profile-directory="!PERF!" "%SCRIPT_PATH%"
)
echo [Listo] Se abrieron %C2% ventanas. Haz clic en el boton "Instalar" en cada una.
echo.
echo ==============================================================================
echo ⚠️  PASO 3 (¡Obligatorio para Chrome nuevo!):
echo ==============================================================================
echo  Activa el Modo de desarrollador ve a chrome://extensions y activa modo 
echo  desarrollador (esquina superior derecha) -- Detalles en extension tampermonkey 
echo  -- Permitir secuencias de comandos del usuario activar
echo ==============================================================================
pause
goto menu

:paso3
cls
echo =======================================================
echo          CREADOR AUTOMATICO DE PERFILES CHROME
echo =======================================================
echo.
set /p CANTIDAD="¿Cuantos perfiles nuevos quieres crear? (Ej: 3): "

echo.
echo [Progreso] Generando nuevos entornos...
echo -------------------------------------------------------

set /a START_NUM=1
:loop_check
if exist "%CHROME_DATA%\Profile %START_NUM%" (
    set /a START_NUM+=1
    goto loop_check
)

set /a FINISH_NUM=START_NUM + CANTIDAD - 1

for /l %%x in (%START_NUM%, 1, %FINISH_NUM%) do (
    echo [OK] Creando y registrando: Profile %%x
    start chrome.exe --profile-directory="Profile %%x" "https://claude.ai"
    timeout /t 2 /nobreak >nul
)

echo -------------------------------------------------------
echo [Listo] Se han creado %CANTIDAD% perfiles nuevos (Del Profile %START_NUM% al %FINISH_NUM%).
echo =======================================================
pause
goto menu