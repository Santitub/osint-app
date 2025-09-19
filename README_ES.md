# 🕵️‍♂️ OSINT-APP 
> Herramienta OSINT en Flutter para geolocalizar cualquier dirección IP y escanear dominios** 🌍🔎

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2.svg?logo=dart)](https://dart.dev)

---

## 🚀 Funcionalidades
* 🔍 **Adaptador universal** – compatible con *cualquier* API REST que devuelva JSON  
* 🧩 **Gestor de proveedores** – añade, edita o elimina endpoints sobre la marcha (tanto para **IPs** como **dominios**)  
* 🌐 **Nuevo módulo «Dominios»**:
  - ✨ **DNS-over-HTTPS** (Google) – consulta registros A, MX, TXT, NS…  
  - 🗂️ **WHOIS gratuito** – datos de registro, expiración, name-servers…  
  - 🛠️ **Editor visual** – crea / modifica / borra tus propias APIs DNS o WHOIS  
* 🔐 **Almacenamiento seguro** – tus APIs personalizadas se cifran mediante **Android Keystore / iOS Keychain**  
* 🗺️ **Mapas con un toque** – abre **Google Maps** (app → Play Store → web como respaldo)  
* 🌓 **Temas oscuro / claro** – diseño adaptativo `Material 3`  
* 📱 **Primero sin conexión** – incluye **proveedores gratuitos** por defecto (sin clave necesaria)  

---

## 🧪 Proveedores pre-cargados
### IPs
| Servicio | Plantilla | Auth |
|----------|-----------|------|
| ip-api.com | `http://ip-api.com/json/{ip}` | ❌ |
| ipinfo.io | `https://ipinfo.io/{ip}/json` | ❌ |
| freeipapi.com | `https://freeipapi.com/api/json/{ip}` | ❌ |

### Dominios
| Servicio | Plantilla | Tipo | Auth |
|----------|-----------|------|------|
| Google DoH | `https://dns.google/resolve?name={domain}&type=A` | DNS | ❌ |
| Whois.vu | `https://api.whois.vu/?q={domain}` | WHOIS | ❌ |

> 🔧 Añade **tus propios** endpoints (pago o privados) insertando claves en **cabeceras JSON**.

---

## 🛠️ Compilar y ejecutar
### Requisitos
* Flutter **3.19+** (`flutter doctor -v`)
* Dart **3.9+**
* Android Studio / Xcode (última estable)
* Git

### Clonar
```bash
git clone https://github.com/Santitub/osint-app.git
cd osint-app
flutter create .
flutter pub get
```

### Ejecutar
```bash
flutter run --debug   # Android / iOS
flutter run -d chrome # Web (sin pantalla completa)
```

### Build APK release
```bash
flutter build apk --release --target-platform android-arm64
```

---

## 🧑‍💻 Formatos de API personalizada
### IPs
| Campo | Ejemplo |
|-------|---------|
| Nombre | `MyIP` |
| URL | `https://api.example.com/{ip}?key=xxx` |
| Headers | `{"X-Token": "abc123"}` |

### Dominios
| Campo | Ejemplo |
|-------|---------|
| Nombre | `MyDoH` |
| URL | `https://dns.google/resolve?name={domain}&type=MX` |
| Headers | `{"Authorization": "Bearer TOKEN"}` |

> 🔍 El marcador **obligatorio** es `{ip}` o `{domain}` según el módulo.  
> La app **adapta automáticamente** la respuesta JSON (insensible a mayúsculas).

---

## 📦 Stack tecnológico
| Capa | Paquete |
|-------|---------|
| Estado | `flutter_riverpod` |
| Navegación | `go_router` |
| HTTP | `dio` |
| Storage seguro | `flutter_secure_storage` |
| Intents / URL | `android_intent_plus`, `url_launcher` |
| UUID | `uuid` |
| Lints | `flutter_lints` |

---

## 🙌 Agradecimientos
* Comunidades de [Flutter](https://flutter.dev) y [Riverpod](https://riverpod.dev)  
* Servicios gratuitos: ip-api.com, Google DoH, Whois.vu  

---

<div align="center">

**⭐ Da una estrella** si te ayudó a **investigar IPs y dominios** más rápido 😉

</div>
