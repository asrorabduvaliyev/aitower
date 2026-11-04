# AI Smart Tourism

O'zbekiston bo'ylab sayohat qiluvchi turistlar uchun Android ilova (Flutter).
Ilova **serversiz ishlaydi**: 27 ta joy va barcha algoritmlar APK ichida.

An Android app (Flutter) for tourists travelling around Uzbekistan. It **works without a server**:
the 27 places and all the algorithms are built into the APK.

## Imkoniyatlar / Features
- 3 til: o'zbekcha, English, русский (ilova ichida almashtiriladi)
- Qiziqish va shahar bo'yicha tavsiyalar — kontentga asoslangan filtrlash (kosinus o'xshashlik + reyting + GPS yaqinlik)
- Joy sahifasi: tavsif, xarita, narx, vaqt, "Google Xaritada ochish"
- Optimal marshrut: **genetik algoritm** (TSP) tashrif tartibini, **A\*** har bir bo'g'in yo'lini topadi,
  marshrut kuniga 8 soatdan oshmaydigan kunlarga bo'linadi; har bir kunni Google Maps'da yo'l bilan ochish

## Tuzilma / Structure
| Papka | Nima bor |
|---|---|
| `mobile/` | Flutter ilova (APK). `lib/algorithms/` — Dart'dagi algoritmlar, `assets/attractions.json` — joylar (3 tilda) |
| `backend/` | Xuddi shu algoritmlarning Python/FastAPI versiyasi (ixtiyoriy REST API, ilovaga shart emas) |
| `data/attractions.csv` | Backend uchun joylar ro'yxati |
| `database/schema.sql` | PostgreSQL/PostGIS sxemasi (backend uchun) |

## APK yig'ish / Build the APK
    cd mobile
    flutter pub get
    flutter build apk --release
    # APK: mobile/build/app/outputs/flutter-apk/app-release.apk


## Backend (ixtiyoriy)
    docker compose up --build        # API: http://localhost:8000/docs
    # yoki Docker'siz:
    cd backend && pip install -r requirements.txt && uvicorn app.main:app --reload
