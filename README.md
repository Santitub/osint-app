# 🕵️‍♂️ OSINT-APP  
> Flutter OSINT tool to geolocate any IP address and scan domains** 🌍🔎

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue.svg?logo=flutter)](https://flutter.dev)  
[![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2.svg?logo=dart)](https://dart.dev)

---

## 🚀 Features  
* 🔍 **Universal adapter** – works with *any* JSON-returning REST API  
* 🧩 **Provider manager** – add, edit or delete endpoints on the fly (for both **IPs** & **domains**)  
* 🌐 **New «Domains» module**:
  - ✨ **DNS-over-HTTPS** (Google) – query A, MX, TXT, NS… records  
  - 🗂️ **Free WHOIS** – registration data, expiry, name-servers…  
  - 🛠️ **Visual editor** – create / modify / delete your own DNS or WHOIS APIs  
* 🔐 **Secure storage** – custom APIs are encrypted with **Android Keystore / iOS Keychain**  
* 🗺️ **Maps one-tap away** – opens **Google Maps** (app → Play Store → web fallback)  
* 🌓 **Dark / light themes** – adaptive `Material 3` design  
* 📱 **Offline-first** – includes **free providers** by default (no key required)  

---

## 🧪 Pre-loaded providers  
### IPs  
| Service | Template | Auth |
|---------|----------|------|
| ip-api.com | `http://ip-api.com/json/{ip}` | ❌ |
| ipinfo.io | `https://ipinfo.io/{ip}/json` | ❌ |
| freeipapi.com | `https://freeipapi.com/api/json/{ip}` | ❌ |

### Domains  
| Service | Template | Type | Auth |
|---------|----------|------|------|
| Google DoH | `https://dns.google/resolve?name={domain}&type=A` | DNS | ❌ |
| Whois.vu | `https://api.whois.vu/?q={domain}` | WHOIS | ❌ |

> 🔧 Add **your own** endpoints (paid or private) by inserting keys in **JSON headers**.

---

## 🛠️ Build & Run  
### Requirements  
* Flutter **3.19+** (`flutter doctor -v`)  
* Dart **3.9+**  
* Android Studio / Xcode (latest stable)  
* Git  

### Clone  
```bash
git clone https://github.com/Santitub/osint-app.git
cd osint-app
flutter create .
flutter pub get
```

### Run  
```bash
flutter run --debug   # Android / iOS
flutter run -d chrome # Web (non-fullscreen)
```

### Build release APK  
```bash
flutter build apk --release --target-platform android-arm64
```

---

## 🧑‍💻 Custom API formats  
### IPs  
| Field | Example |
|-------|---------|
| Name | `MyIP` |
| URL | `https://api.example.com/{ip}?key=xxx` |
| Headers | `{"X-Token": "abc123"}` |

### Domains  
| Field | Example |
|-------|---------|
| Name | `MyDoH` |
| URL | `https://dns.google/resolve?name={domain}&type=MX` |
| Headers | `{"Authorization": "Bearer TOKEN"}` |

> 🔍 The **mandatory** placeholder is `{ip}` or `{domain}` depending on the module.  
> The app **auto-adapts** to any JSON response (case-insensitive).

---

## 📦 Tech stack  
| Layer | Package |
|-------|---------|
| State | `flutter_riverpod` |
| Navigation | `go_router` |
| HTTP | `dio` |
| Secure storage | `flutter_secure_storage` |
| Intents / URL | `android_intent_plus`, `url_launcher` |
| UUID | `uuid` |
| Lints | `flutter_lints` |

---

## 🙌 Credits  
* [Flutter](https://flutter.dev) & [Riverpod](https://riverpod.dev) communities  
* Free services: ip-api.com, Google DoH, Whois.vu  

---

<div align="center">

**⭐ Star the repo** if it helped you investigate IPs & domains faster 😉

</div
