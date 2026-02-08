# Aurra.life

Draft implementation for the aurra.life technical plan, including:

- `aurra_backend/`: FastAPI "central brain" stub with memory, context, and device APIs.
- `aurra_app/`: Flutter starter UI with the conversation-first shell.

## Backend quick start

```bash
cd aurra_backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn aurra_backend.app:app --reload
```

## Frontend quick start

```bash
cd aurra_app
flutter pub get
flutter run
```
