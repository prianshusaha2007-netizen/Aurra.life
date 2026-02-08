# Aurra.life

This repository contains a focused technical starter for aurra.life:

- `aurra_app/` → Flutter UI for the companion experience.
- `aurra_backend/` → FastAPI service for conversational memory + device sync.

## Flutter app

```bash
cd aurra_app
flutter pub get
flutter run
```

## Backend

```bash
cd aurra_backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
```

## Example backend requests

```bash
curl -X POST http://127.0.0.1:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"user_id":"demo","message":"Remember I like calm mornings"}'
```
