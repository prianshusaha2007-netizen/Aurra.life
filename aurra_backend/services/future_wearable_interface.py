from datetime import datetime, timezone

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class WearablePing(BaseModel):
    device_id: str
    status: str
    last_seen: str


@router.get("/wearable-status", response_model=WearablePing)
def wearable_status(device_id: str) -> WearablePing:
    return WearablePing(
        device_id=device_id,
        status="ready",
        last_seen=datetime.now(timezone.utc).isoformat(),
    )
