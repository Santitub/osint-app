# 🕵️‍♂️ OSINT-APP 
> Herramienta OSINT en Flutter para geolocalizar cualquier dirección IP usando múltiples proveedores configurables 🌍

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2.svg?logo=dart)](https://dart.dev)

---

## 🚀 Funcionalidades
* 🔍 **Adaptador universal** – funciona con *cualquier* API REST que devuelva JSON (solo inserta la URL)  
* 🧩 **Gestor de proveedores** – añade, edita o elimina endpoints sobre la marcha  
* 🔐 **Almacenamiento seguro** – tus APIs personalizadas se cifran mediante **Android Keystore / iOS Keychain**  
* 🗺️ **Mapas con un toque** – abre **Google Maps** (app → Play Store → web como respaldo)  
* 🌓 **Temas oscuro / claro** – diseño adaptativo `Material 3`  
* 📱 **Primero sin conexión** – incluye **3 proveedores gratuitos** por defecto (sin clave necesaria)  

---

## 🧪 Proveedores soportados (pre-cargados)
| Proveedor | Plantilla-URL | ¿Requiere autenticación? |
|----------|--------------|--------------------------|
| [ip-api.com](http://ip-api.com) | `http://ip-api.com/json/{ip}` | ❌ |
| [ipinfo.io](https://ipinfo.io) | `https://ipinfo.io/{ip}/json` | ❌ |
| [freeipapi.com](https://freeipapi.com) | `https://freeipapi.com/api/json/{ip}` | ❌ |

> 🔧 Puedes añadir **servicios de pago** (IPStack, IPRegistry, MaxMind, etc.) insertando tu clave en las cabeceras.

---

## 🛠️ Compilar y ejecutar

### Requisitos previos
* Flutter **3.19+** (`flutter doctor -v`)
* Dart **3.9+`
* Android Studio / Xcode (última versión estable)
* Git

### Clonar e instalar
```bash
git clone https://github.com/Santitub/osint-app.git
cd osint-app
flutter create .
flutter pub get
```

### Ejecutar (debug)
```bash
flutter run --debug
```

### Construir APK en release
```bash
flutter build apk --release --target-platform android-arm64
```

---

## 🧑‍💻 Formato de API personalizada
Al añadir un proveedor **debes** incluir el marcador `{ip}` en la URL.

| Campo | Ejemplo |
|-------|---------|
| Nombre | `MyIPService` |
| URL | `https://api.example.com/{ip}?key=xxx` |
| Cabeceras (JSON) | `{"Authorization": "Bearer YOUR_TOKEN"}` |

La respuesta JSON **debe** contener **al menos una** de las siguientes claves (insensible a mayúsculas):
```
ip, query, ipAddress → mapeado a `IpInfo.ip`
city, cityName → `IpInfo.city`
country, countryName → `IpInfo.country`
isp, org, asnOrganization → `IpInfo.isp / org`
loc, latitude+longitude → `IpInfo.lat / lon`
```
> ✨ Todo lo demás se ignora sin problemas.

---

## 📦 Stack tecnológico
| Capa | Paquete |
|-------|---------|
| Gestión de estado | `flutter_riverpod` |
| Navegación | `go_router` |
| Cliente HTTP | `dio` |
| Almacenamiento seguro | `flutter_secure_storage` |
| Intenciones del dispositivo | `android_intent_plus`, `url_launcher` |
| UUID | `uuid` |
| Análisis estático | `flutter_lints` |

---

## 🙌 Agradecimientos
* [ip-api.com](https://ip-api.com) por su generoso plan gratuito  
* Las comunidades de [Flutter](https://flutter.dev) y [Riverpod](https://riverpod.dev) por su excelente documentación  

---

<div align="center">

**⭐ Da una estrella** a este repo si te ayudó a **recopilar inteligencia** más rápido!

</div>
