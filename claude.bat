@echo off
setlocal enabledelayedexpansion
cls

:: Detecta automaticamente la ruta de los scripts y datos de Chrome
set "PYTHON_SCRIPT=%~dp0claude_server.py"
set "SCRIPT_PATH=%~dp0claude_detector.user.js"
set "STATUS_FILE=%APPDATA%\claude_profiles_status.txt"
set "CHROME_DATA=%LocalAppData%\Google\Chrome\User Data"
set "STORE_URL=https://chromewebstore.google.com/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo?hl=es"

:: REGLA DE RUTAS: Redirecciona segun el parametro que ponga el usuario
if "%1"=="setup" goto menu_setup
if "%1"=="debug" goto modo_debug

:: =======================================================
:: DETECTOR DE PRIMER USO
:: =======================================================
if not exist "%STATUS_FILE%" (
    echo =======================================================
    echo  [Primer Uso] No se detecto una configuracion previa.
    echo  Redireccionando al Asistente de Configuracion...
    echo =======================================================
    timeout /t 3 /nobreak >nul
    goto menu_setup
)

:: CÓDIGO MODIFICADO (Ejecución 100% invisible)
netstat -ano | findstr :1915 >nul
if !errorlevel! neq 0 (
    if exist "%PYTHON_SCRIPT%" (
        powershell -WindowStyle Hidden -Command "Start-Process python -ArgumentList '\"%PYTHON_SCRIPT%\"' -WindowStyle Hidden"
        timeout /t 2 /nobreak >nul
    )
)

:menu_principal
cls
echo =======================================================
echo         PANEL DE CONTROL - MULTI-PERFIL (DINAMICO)
echo =======================================================

:: Limpiar entornos de mapeo previos de forma segura
for /f "tokens=1 delims==" %%v in ('set MENU_ 2^>nul') do set "%%v="
for /f "tokens=1 delims==" %%v in ('set ST_ 2^>nul') do set "%%v="

:: Cargar estados del archivo de texto
if exist "%STATUS_FILE%" (
    for /f "usebackq tokens=1,2 delims==" %%a in ("%STATUS_FILE%") do (
        set "ST_%%a=%%b"
    )
)

:: 1. Renderizar Perfil Principal (Asignado obligatoriamente a la tecla 'D')
set "S_VAL=No Configurado"
if defined ST_Default set "S_VAL=!ST_Default!"
set "MENU_D=Default"
echo  [D] Perfil Principal (Default) - !S_VAL!
echo -------------------------------------------------------

:: 2. Renderizar Perfiles Numericos correlativos de carpetas reales
set /a NUM_INDEX=0
for /d %%i in ("%CHROME_DATA%\Profile *") do (
    :: Llamamos a una subrutina externa para procesar el perfil de forma segura
    call :procesar_perfil "%%~nxi"
)

echo =======================================================
echo  [R] Refrescar Estados actuales (Sincronizacion)
echo  [Tip] Escribe 'setup' para configuraciones avanzadas
echo  [Tip] Escribe 'debug' para monitorear logs en tiempo real
echo =======================================================
echo.
set "OPCION="
set /p OPCION="Elige una opcion (D, 1-%NUM_INDEX%, R): "

if "%OPCION%"=="" goto menu_principal

:: Convertir entrada a Mayuscula por si escriben en minuscula ('r' o 'd')
if /i "%OPCION%"=="R" goto menu_principal
if /i "%OPCION%"=="D" set "OPCION=D"
if "%OPCION%"=="setup" goto menu_setup
if "%OPCION%"=="debug" goto modo_debug

:: Recuperar el perfil usando el mapeo de tecla directo
set "PERFIL="
for /f "tokens=2 delims==" %%v in ('set MENU_%OPCION% 2^>nul') do set "PERFIL=%%v"

if "%PERFIL%"=="" (
    echo.
    echo [!] Opcion invalida o perfil no existente en el disco: "%OPCION%"
    timeout /t 2 >nul
    goto menu_principal
)

:: Definir ruta limpia de Google Chrome
set "CHROME_BIN=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME_BIN%" set "CHROME_BIN=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME_BIN%" set "CHROME_BIN=chrome.exe"

echo.
echo [OK] Abriendo entorno real de Chrome: %PERFIL%
echo -------------------------------------------------------

start "" "%CHROME_BIN%" --profile-directory="%PERFIL%" "https://claude.ai/?profile=%PERFIL%"

:: Espera breve y refresca automaticamente la pantalla del menu
timeout /t 2 /nobreak >nul
goto menu_principal


:: =======================================================
:: SUBRUTINA: PROCESAMIENTO SEGURO DE PERFILES
:: =======================================================
:procesar_perfil
set "P_FOLDER=%~1"
set "S_STATE=No Configurado"

:: Extraer el numero usando una tecnica que no colapsa
set "P_NUM=%P_FOLDER:Profile =%"

:: Generar variantes de clave limpianado espacios de forma segura
set "P_KEY_UNDER=%P_FOLDER: =_%"
set "P_KEY_NONE=%P_FOLDER: =%"

:: Buscar el estado usando IF DEFINED sin expansiones raras de nombres
if defined ST_%P_KEY_UNDER% (
    for /f "delims=" %%x in ('echo !ST_%P_KEY_UNDER%!') do set "S_STATE=%%x"
) else if defined ST_%P_KEY_NONE% (
    for /f "delims=" %%x in ('echo !ST_%P_KEY_NONE%!') do set "S_STATE=%%x"
)

:: Guardar mapeo de la tecla numerica
set "MENU_%P_NUM%=%P_FOLDER%"
echo  [%P_NUM%] Perfil Numerico (%P_FOLDER%) - %S_STATE%

:: Incrementar el indice global
set /a NUM_INDEX+=1
goto :eof


:: =======================================================
:: MENUS SECUNDARIOS Y CONFIGURACIONES
:: =======================================================
:menu_setup
cls
echo =======================================================
echo           ASISTENTE DE CONFIGURACION INTEGRADO
echo =======================================================
echo  1. Crear nuevos perfiles de Chrome en rafaga
echo  2. Instalar Tampermonkey en TODOS los perfiles
echo  3. Instalar Script Detector Local (En todos los perfiles)
echo  4. Abrir Administrator de Extensiones (En todos los perfiles)
echo  5. Volver al Panel Principal
echo =======================================================
echo.
set /p OPT="Elige una opcion (1-5): "

if "%OPT%"=="1" goto crear_perfiles
if "%OPT%"=="2" goto instalar_tampermonkey
if "%OPT%"=="3" goto instalar_script_local
if "%OPT%"=="4" goto abrir_extensiones
if "%OPT%"=="5" goto menu_principal
goto menu_setup

:crear_perfiles
cls
echo =======================================================
echo           CREADOR AUTOMATICO DE PERFILES CHROME
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
    start chrome.exe --profile-directory="Profile %%x" "https://claude.ai/?profile=Profile %%x"
    timeout /t 2 /nobreak >nul
)
echo -------------------------------------------------------
echo [Listo] Se han creado %CANTIDAD% perfiles nuevos.
pause
goto menu_setup

:instalar_tampermonkey
cls
echo [Progreso] Abriendo la tienda de Tampermonkey en TODOS los perfiles...
echo -------------------------------------------------------
set /a C1=0
set "CHROME_BIN=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME_BIN%" set "CHROME_BIN=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME_BIN%" set "CHROME_BIN=chrome.exe"

if exist "%CHROME_DATA%\Default" (
    set /a C1+=1
    echo [OK] Abriendo tienda para: Default
    start "" "%CHROME_BIN%" --profile-directory="Default" "%STORE_URL%"
    timeout /t 1 >nul
)
for /d %%i in ("%CHROME_DATA%\Profile *") do (
    set /a C1+=1
    echo [OK] Abriendo tienda para: %%~nxi
    start "" "%CHROME_BIN%" --profile-directory="%%~nxi" "%STORE_URL%"
    timeout /t 1 >nul
)
echo -------------------------------------------------------
echo [Listo] Se abrieron %C1% ventanas de Chrome con la tienda de Tampermonkey.
pause
goto menu_setup

:instalar_script_local
cls
echo [Progreso] Preparando entorno y copiando script al portapapeles...
echo -------------------------------------------------------
if not exist "%SCRIPT_PATH%" (
    echo [ERROR] No se encontro claude_detector.user.js en: %~dp0
    pause
    goto menu_setup
)
type "%SCRIPT_PATH%" | clip
echo [OK] Codigo fuente copiado al portapapeles.
set "TM_EDITOR_URL=chrome-extension://dhdgffkkebhmkfjojejmpbldmpobfkfo/options.html#nav=new-user-script+editor"

set /a C2=0
if exist "%CHROME_DATA%\Default" set /a C2+=1
for /d %%i in ("%CHROME_DATA%\Profile *") do set /a C2+=1

echo -------------------------------------------------------
powershell -Command "$wshell = New-Object -ComObject Wscript.Shell; $wshell.Popup('Listo. Se abriran %C2% ventanas de Chrome en el editor de Tampermonkey.' + [char]10 + [char]10 + '1. Borra todo el texto.' + [char]10 + '2. Pega (Ctrl + V) y guarda (Ctrl + S).', 0, 'Asistente Multi-Perfil', 64)"

if exist "%CHROME_DATA%\Default" (
    start chrome.exe --profile-directory="Default" "%TM_EDITOR_URL%"
    timeout /t 1 >nul
)
for /d %%i in ("%CHROME_DATA%\Profile *") do (
    start chrome.exe --profile-directory="%%~nxi" "%TM_EDITOR_URL%"
    timeout /t 1 >nul
)
pause
goto menu_setup

:abrir_extensiones
cls
for /d %%i in ("%CHROME_DATA%\Profile *") do (
    start chrome.exe --profile-directory="%%~nxi" "chrome://extensions/"
    timeout /t 1 >nul
)
pause
goto menu_setup

:modo_debug
cls
echo =======================================================
echo           MODO DEBUG: MONITOREO EN TIEMPO REAL
echo =======================================================
echo Presiona Ctrl+C para salir de este modo.
:loop_debug
if exist "%STATUS_FILE%" (
    echo [%time:~0,8%] Estados actuales:
    type "%STATUS_FILE%"
    echo -------------------------------------------------------
)
timeout /t 5 /nobreak >nul
goto loop_debug