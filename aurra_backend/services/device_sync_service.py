from datetime import datetime, timezone
from typing import Any

from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from pydantic import BaseModel

router = APIRouter()


class DeviceLinkRequest(BaseModel):
    user_id: str
    device_name: str


class DeviceLinkResponse(BaseModel):
    device_id: str
    linked_at: str


@router.post("/link-device", response_model=DeviceLinkResponse)
def link_device(payload: DeviceLinkRequest) -> DeviceLinkResponse:
    device_id = f"device-{hash(payload.device_name) % 10_000:04d}"
    return DeviceLinkResponse(
        device_id=device_id,
        linked_at=datetime.now(timezone.utc).isoformat(),
    )


async def handle_sync_socket(websocket: WebSocket) -> None:
    await websocket.accept()
    await websocket.send_json(
        {
            "event": "connected",
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }
    )
    try:
        while True:
            payload: dict[str, Any] = await websocket.receive_json()
            await websocket.send_json(
                {
                    "event": "sync",
                    "payload": payload,
                    "timestamp": datetime.now(timezone.utc).isoformat(),
                }
            )
    except WebSocketDisconnect:
        return
