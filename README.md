# 🕵️‍♂️ OSINT-APP 
> Flutter-powered OSINT tool to geolocate any IP address using multiple configurable providers 🌍

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2.svg?logo=dart)](https://dart.dev)

---

## 🚀 Features
* 🔍 **Universal adapter** – works with *any* REST API that returns JSON (just plug the URL)  
* 🧩 **Provider manager** – add, edit or delete endpoints on-the-fly  
* 🔐 **Secure storage** – your custom APIs are encrypted via **Android Keystore / iOS Keychain**  
* 🗺️ **One-tap maps** – opens **Google Maps** (app → Play Store → web fallback)  
* 🌓 **Dark / Light themes** – adaptive `Material 3` design  
* 📱 **Offline-first** – defaults ship with **3 free providers** (no key required)  

---

## 🧪 Supported Providers (pre-loaded)
| Provider | URL-Template | Auth needed |
|----------|--------------|-------------|
| [ip-api.com](http://ip-api.com) | `http://ip-api.com/json/{ip}` | ❌ |
| [ipinfo.io](https://ipinfo.io) | `https://ipinfo.io/{ip}/json` | ❌ |
| [freeipapi.com](https://freeipapi.com) | `https://freeipapi.com/api/json/{ip}` | ❌ |

> 🔧 You can add **paid services** (IPStack, IPRegistry, MaxMind, etc.) by inserting your key in the headers.

---

## 🛠️ Build & Run

### Prerequisites
* Flutter **3.19+** (`flutter doctor -v`)
* Dart **3.9+**
* Android Studio / Xcode (latest stable)
* Git

### Clone & Install
```bash
git clone https://github.com/Santitub/osint-app.git
cd osint-app
flutter create .
flutter pub get
```

### Run (debug)
```bash
flutter run --debug
```

### Build release APK
```bash
flutter build apk --release --target-platform android-arm64
```

---

## 🧑‍💻 Custom API Format
When adding a provider you **must** include the placeholder `{ip}` in the URL.

| Field | Example |
|-------|---------|
| Name | `MyIPService` |
| URL | `https://api.example.com/{ip}?key=xxx` |
| Headers (JSON) | `{"Authorization": "Bearer YOUR_TOKEN"}` |

The JSON response **must** contain **at least one** of the following keys (case-insensitive):
```
ip, query, ipAddress → mapped to `IpInfo.ip`
city, cityName → `IpInfo.city`
country, countryName → `IpInfo.country`
isp, org, asnOrganization → `IpInfo.isp / org`
loc, latitude+longitude → `IpInfo.lat / lon`
```
> ✨ Everything else is gracefully ignored.

---

## 📦 Tech Stack
| Layer | Package |
|-------|---------|
| State-Management | `flutter_riverpod` |
| Navigation | `go_router` |
| HTTP Client | `dio` |
| Secure Storage | `flutter_secure_storage` |
| Device Intents | `android_intent_plus`, `url_launcher` |
| UUID | `uuid` |
| Linting | `flutter_lints` |

---

## 🙌 Acknowledgements
* [ip-api.com](https://ip-api.com) for the generous free tier  
* [Flutter](https://flutter.dev) & [Riverpod](https://riverpod.dev) communities for awesome docs  

---

<div align="center">

**⭐ Star** this repo if it helped you **gather intel** faster!

</div>
