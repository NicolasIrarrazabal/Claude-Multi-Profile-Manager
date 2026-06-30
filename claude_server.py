import http.server
import json
import os

PORT = 1915
STATUS_FILE = os.path.expandvars(r"%APPDATA%\claude_profiles_status.txt")
SCRIPT_FILE = os.path.join(os.path.dirname(__file__), "claude_detector.user.js")

# Inicializa el archivo de estados vacío si no existe (Sin perfiles fantasma)
if not os.path.exists(STATUS_FILE):
    with open(STATUS_FILE, "w", encoding="utf-8") as f:
        f.write("")

class ClaudeHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith("/script"):
            if os.path.exists(SCRIPT_FILE):
                self.send_response(200)
                self.send_header('Content-Type', 'text/javascript; charset=utf-8')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                with open(SCRIPT_FILE, "rb") as f:
                    self.wfile.write(f.read())
                return
            else:
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"Script no encontrado")
                return
        
        self.send_response(404)
        self.end_headers()

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        data = json.loads(post_data.decode('utf-8'))
        
        profile = data.get("profile")
        status = data.get("status")
        
        estados = {}
        if os.path.exists(STATUS_FILE):
            with open(STATUS_FILE, "r", encoding="utf-8") as f:
                for line in f:
                    if "=" in line:
                        k, v = line.strip().split("=", 1)
                        estados[k] = v

        # Actualizar o insertar el perfil real que está reportando
        estados[profile] = status

        with open(STATUS_FILE, "w", encoding="utf-8") as f:
            for k, v in estados.items():
                f.write(f"{k}={v}\n")

        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(b"OK")

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

if __name__ == "__main__":
    server = http.server.HTTPServer(('0.0.0.0', PORT), ClaudeHandler)
    print(f"Servidor Claude escuchando en todas las interfaces en el puerto {PORT}...")
    server.serve_forever()