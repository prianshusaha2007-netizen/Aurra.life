from datetime import datetime, timezone
from uuid import uuid4

from fastapi import APIRouter
from pydantic import BaseModel

from aurra_backend.services.memory_service import remember_message

router = APIRouter()


class ChatRequest(BaseModel):
    user_id: str
    message: str
    permission_to_remember: bool = False


class ChatResponse(BaseModel):
    response_id: str
    message: str
    timestamp: str


@router.post("/chat", response_model=ChatResponse)
def chat(payload: ChatRequest) -> ChatResponse:
    if payload.permission_to_remember:
        remember_message(payload.user_id, payload.message)
    response_text = (
        "I'm here with you. I'm tracking context and will build on what matters most."
    )
    return ChatResponse(
        response_id=f"resp-{uuid4().hex[:8]}",
        message=response_text,
        timestamp=datetime.now(timezone.utc).isoformat(),
    )
