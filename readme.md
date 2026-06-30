# Claude Multi-Profile Manager 🚀

**Claude Multi-Profile Manager** es una herramienta automatizada para Windows diseñada para maximizar el uso de Claude.ai a través de múltiples perfiles de Google Chrome de forma fluida. Centraliza la gestión de tus cuentas, monitorea el consumo de límites de mensajes en segundo plano y te muestra en tiempo real desde la consola qué perfiles están listos (**Disponibles**) o bloqueados temporalmente (**Bloqueados con su hora de reinicio**).

---

## ✨ Características Principales
* [cite_start]**Ejecución Invisible:** El servidor backend en Python se levanta automáticamente en segundo plano sin interrumpir tu terminal.
* **Detección Dinámica de Estados:** Gracias a un UserScript ligero inyectado mediante Tampermonkey, la herramienta detecta si una cuenta ha alcanzado el límite de mensajes gratuitos.
* [cite_start]**Asistente de Configuración Integrado:** Automatiza la creación masiva de perfiles y la apertura de extensiones para ahorrar tiempo de configuración manual[cite: 9, 10, 11].
* [cite_start]**Modo Debug Integrado:** Monitorea de forma reactiva y en tiempo real el archivo de estados entrantes.

---

## 🛠️ Requisitos Previos
* **Windows OS**
* **Python 3.x** instalado y añadido al `PATH`.
* [cite_start]**Google Chrome** instalado[cite: 6].

---

## 📦 Instalación y Configuración Rápida

1. **Clona o descarga este proyecto** en una carpeta de tu preferencia.
2. *(Opcional)* Añade la ruta de la carpeta a las **Variables de Entorno (PATH)** de Windows para poder invocar la herramienta usando el comando `claude` (renombrando el archivo a `claude.bat`) desde cualquier terminal.
3. [cite_start]Ejecuta el archivo interactivo `configurar_chrome.bat` [cite: 17] y sigue los pasos en pantalla:
   * [cite_start]**Paso 1:** Instalará la extensión **Tampermonkey** en todos tus perfiles existentes de Chrome con un solo clic[cite: 18, 19].
   * [cite_start]**Paso 2:** Inyectará el script de rastreo automático (`claude_detector.user.js`)[cite: 18, 20].
   * [cite_start]**Paso 3 (¡Obligatorio para versiones recientes de Chrome!):** Abre `chrome://extensions/` en tus perfiles, activa el **Modo de desarrollador** (esquina superior derecha) y, dentro de los detalles de Tampermonkey, asegúrate de activar la opción **"Permitir secuencias de comandos del usuario"**[cite: 21].

---

## 🚀 Modo de Uso

Abre tu terminal favorita (CMD o PowerShell) y ejecuta los siguientes comandos según lo que necesites:

### 1. Panel de Control Principal
```bash
claude