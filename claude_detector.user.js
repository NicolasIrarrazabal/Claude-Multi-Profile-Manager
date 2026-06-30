// ==UserScript==
// @name         Claude CMD Status Sync Auto
// @namespace    http://tampermonkey.net/
// @version      2.6
// @description  Envío de estados en texto plano sin emojis para compatibilidad nativa con Windows CLI
// @match        *://*.claude.ai/*
// @match        *://claude.ai/*
// @run-at       document-start
// @grant        GM_xmlhttpRequest
// ==/UserScript==

(function() {
    'use strict';

    let PERFIL_ACTUAL = localStorage.getItem("CHROME_PROFILE_ID_FIXED");
    const urlParams = new URLSearchParams(window.location.search);
    const perfilUrl = urlParams.get('profile');

    if (perfilUrl) {
        PERFIL_ACTUAL = perfilUrl;
        localStorage.setItem("CHROME_PROFILE_ID_FIXED", PERFIL_ACTUAL);
    } else if (!PERFIL_ACTUAL) {
        PERFIL_ACTUAL = "Default";
    }

    let ultimoEstado = "";

    function enviarEstado(status) {
        if (status === ultimoEstado) return;
        ultimoEstado = status;

        let perfilFormateado = PERFIL_ACTUAL.replace(/ /g, "_");

        GM_xmlhttpRequest({
            method: "POST",
            url: "http://127.0.0.1:1915",
            data: JSON.stringify({ profile: perfilFormateado, status: status }),
            headers: { "Content-Type": "application/json" },
            onerror: function(err) { console.log("Servidor Python apagado."); }
        });
    }

    function checkLimit() {
        if (!document.body) return;

        const pageText = document.body.innerText || "";
        const fullHTML = document.body.innerHTML || "";

        const detectaMensajesGratis = pageText.includes("Se ha quedado sin mensajes gratuitos");
        const detectaLimiteMensajes = pageText.includes("Has alcanzado tu límite de mensajes");
        const detectaRestablece = pageText.includes("Se restablece a las");

        // 🚨 CONTROL DE BLOQUEOS (Prioridad absoluta - Texto Plano)
        if (detectaMensajesGratis || detectaLimiteMensajes || detectaRestablece || pageText.includes("Actualiza para seguir chateando")) {
            const timeMatch = pageText.match(/(\d{1,2}:\d{2})\s*(AM|PM)?/i);
            const hora = timeMatch ? ` a las ${timeMatch[0]}` : "";
            enviarEstado(`Bloqueado${hora}`);
            return;
        } 

        // 🍏 CONTROL DE DISPONIBILIDAD (Texto Plano)
        const isAvailable = 
            document.querySelector('div[contenteditable="true"]') || 
            pageText.includes("Message Claude") || 
            pageText.includes("Escribe / para habilidades") ||
            document.querySelector('nav') || 
            document.querySelector('[data-testid="user-profile-button"]');

        if (isAvailable) {
            enviarEstado("Disponible");
        }
    }

    window.addEventListener('DOMContentLoaded', () => {
        checkLimit();

        const observer = new MutationObserver(() => {
            checkLimit();
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    });

    setInterval(checkLimit, 3000);
})();