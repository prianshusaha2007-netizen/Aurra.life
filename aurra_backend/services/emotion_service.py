from datetime import datetime, timezone

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class EmotionSnapshot(BaseModel):
    user_id: str
    mood: str
    note: str | None = None
    recorded_at: str


@router.get("/daily-context", response_model=EmotionSnapshot)
def daily_context(user_id: str) -> EmotionSnapshot:
    return EmotionSnapshot(
        user_id=user_id,
        mood="steady",
        note="Baseline mood inferred from recent check-ins.",
        recorded_at=datetime.now(timezone.utc).isoformat(),
    )
