# Claude Multi-Profile Manager 🚀

**Claude Multi-Profile Manager** es una solución automatizada para Windows diseñada para optimizar y maximizar el uso de Claude.ai a través de múltiples cuentas y perfiles de Google Chrome de forma centralizada. 

El sistema consta de un backend ligero en Python, un UserScript para Tampermonkey que monitorea el estado de la cuota de mensajes en tiempo real, y un panel de control interactivo basado en CLI (`.bat`) para alternar rápidamente entre perfiles disponibles.

---

## ✨ Características Principales

* 🎛️ **Panel de Control Dinámico:** Detecta automáticamente tus perfiles existentes de Chrome (`Default` y `Profile X`) y los mapea a un menú interactivo.
* 🕵️‍♂️ **Ejecución 100% Invisible:** El servidor backend en Python se inicia automáticamente en segundo plano (ocultando la ventana de la consola) al arrancar el panel principal.
* 📊 **Monitoreo de Estado en Tiempo Real:** Detecta automáticamente si un perfil está **Disponible** o **Bloqueado** (extrayendo e informando la hora exacta de restablecimiento si la página la muestra).
* ⚡ **Asistente de Configuración Integrado:** * Creación masiva y automática de perfiles de Chrome en ráfaga.
  * Apertura masiva de la Chrome Web Store para instalar Tampermonkey con un solo clic.
  * Copia inteligente y automatizada del UserScript para una instalación rápida.
* 🔍 **Modo Debug Integrado:** Monitoreo reactivo en tiempo real desde la consola para auditar los cambios en el archivo de estados (`claude_profiles_status.txt`).

---

## 🛠️ Requisitos Previos

Antes de comenzar, asegúrate de tener instalado lo siguiente en tu sistema operativo Windows:

1. **Google Chrome**.
2. **Python 3.x** (Asegúrate de marcar la casilla **"Add Python to PATH"** durante la instalación).

---

## 📦 Estructura del Proyecto

* `claude.bat`: Panel de control interactivo principal y lanzador invisible del servidor.
* `configurar_chrome.bat`: Utilidad auxiliar independiente para la configuración inicial de perfiles y extensiones.
* `claude_server.py`: Servidor HTTP local (Puerto `1915`) encargado de recibir y centralizar los estados enviados por los perfiles.
* `claude_detector.user.js`: Script de Tampermonkey (JavaScript) que se ejecuta en Claude.ai para leer el DOM y reportar cuotas.

---

## 🚀 Instalación y Configuración Inicial

Sigue estos sencillos pasos para dejar el entorno listo:

### Paso 1: Configurar Perfiles y Extensiones
1. Ejecuta el archivo `configurar_chrome.bat`.
2. Selecciona la **Opción 1** para abrir la tienda de extensiones en todos tus perfiles e instala **Tampermonkey**.
3. Selecciona la **Opción 2** para preparar la inyección del script detector local.
4. *(Opcional)* Si necesitas más cuentas, usa la **Opción 3** para generar perfiles limpios en ráfaga de forma automática.

### Paso 2: Configuración Obligatoria de Seguridad en Chrome
Debido a las políticas de seguridad recientes de Chromium, debes habilitar la ejecución de scripts locales:
1. En cada perfil de Chrome, navega a `chrome://extensions/`.
2. Activa el **Modo de desarrollador** (esquina superior derecha).
3. Busca la extensión **Tampermonkey**, haz clic en **Detalles**.
4. Desplázate hacia abajo y activa el interruptor **"Permitir secuencias de comandos del usuario"** (Allow webpage access / User scripts).

### Paso 3: Instalar el UserScript en Tampermonkey
El asistente facilita este proceso copiando el código al portapapeles:
1. Al usar la opción correspondiente en el script, se abrirá el editor de scripts de Tampermonkey en cada perfil de Chrome.
2. **Borra** cualquier código preexistente en el editor.
3. **Pega** (`Ctrl + V`) el script que ya se encuentra copiado en tu portapapeles.
4. **Guarda** los cambios (`Ctrl + S`).

---

## 💻 Modo de Uso

Una vez configurado, puedes iniciar el ecosistema abriendo una terminal (CMD o PowerShell) en la carpeta del proyecto.

### Menú Principal
Para abrir el panel interactivo y levantar el servidor invisible, simplemente ejecuta:
```bash
claude.bat