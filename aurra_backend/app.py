from datetime import datetime, timezone
from typing import Any

from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware

from aurra_backend.services import (
    auth_service,
    conversation_service,
    device_sync_service,
    emotion_service,
    future_wearable_interface,
    memory_service,
)


app = FastAPI(title="aurra.life backend", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_service.router, prefix="/auth", tags=["auth"])
app.include_router(conversation_service.router, tags=["conversation"])
app.include_router(memory_service.router, tags=["memory"])
app.include_router(emotion_service.router, tags=["emotion"])
app.include_router(device_sync_service.router, tags=["devices"])
app.include_router(future_wearable_interface.router, tags=["wearables"])


@app.get("/health")
def health() -> dict[str, Any]:
    return {"status": "ok", "time": datetime.now(timezone.utc).isoformat()}


@app.websocket("/sync-state")
async def sync_state(websocket: WebSocket) -> None:
    await device_sync_service.handle_sync_socket(websocket)
