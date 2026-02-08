from datetime import datetime
from typing import Dict, List, Optional

from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI(title="aurra.life backend")


class ChatRequest(BaseModel):
    user_id: str
    message: str
    context: Optional[Dict[str, str]] = None


class ChatResponse(BaseModel):
    reply: str
    memory_hint: Optional[str] = None
    timestamp: str


class MemoryItem(BaseModel):
    user_id: str
    category: str = Field(..., examples=["short", "mid", "long"])
    summary: str
    expires_at: Optional[str] = None


class MemoryQuery(BaseModel):
    user_id: str
    category: Optional[str] = None


class DeviceLinkRequest(BaseModel):
    user_id: str
    device_id: str
    device_type: str


class VoiceInputRequest(BaseModel):
    user_id: str
    transcript: str


class SyncStateResponse(BaseModel):
    user_id: str
    linked_devices: List[str]
    last_sync: str


MEMORY_STORE: Dict[str, List[MemoryItem]] = {}
DEVICE_LINKS: Dict[str, List[str]] = {}


@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest) -> ChatResponse:
    memory_hint = _summarize_memory(request.user_id)
    response = (
        "I hear you. I will keep this in context and check in when it is helpful. "
        "Would you like me to set a reminder or just remember this?"
    )
    if request.context:
        response = f"Got it. Based on your context, {response.lower()}"

    return ChatResponse(
        reply=response,
        memory_hint=memory_hint,
        timestamp=datetime.utcnow().isoformat(),
    )


@app.post("/voice-input", response_model=ChatResponse)
async def voice_input(request: VoiceInputRequest) -> ChatResponse:
    return await chat(ChatRequest(user_id=request.user_id, message=request.transcript))


@app.get("/daily-context")
async def daily_context(user_id: str) -> Dict[str, str]:
    memory_hint = _summarize_memory(user_id)
    return {
        "user_id": user_id,
        "mood": "focused",
        "energy": "calm",
        "next_event": "Design sync at 4pm",
        "memory_hint": memory_hint or "No saved highlights yet.",
    }


@app.post("/store-memory")
async def store_memory(item: MemoryItem) -> Dict[str, str]:
    MEMORY_STORE.setdefault(item.user_id, []).append(item)
    return {"status": "stored", "items": str(len(MEMORY_STORE[item.user_id]))}


@app.post("/retrieve-memory")
async def retrieve_memory(query: MemoryQuery) -> Dict[str, List[MemoryItem]]:
    items = MEMORY_STORE.get(query.user_id, [])
    if query.category:
        items = [item for item in items if item.category == query.category]
    return {"items": items}


@app.post("/link-device")
async def link_device(request: DeviceLinkRequest) -> Dict[str, str]:
    DEVICE_LINKS.setdefault(request.user_id, []).append(request.device_id)
    return {"status": "linked", "device_id": request.device_id}


@app.get("/sync-state", response_model=SyncStateResponse)
async def sync_state(user_id: str) -> SyncStateResponse:
    return SyncStateResponse(
        user_id=user_id,
        linked_devices=DEVICE_LINKS.get(user_id, []),
        last_sync=datetime.utcnow().isoformat(),
    )


def _summarize_memory(user_id: str) -> Optional[str]:
    items = MEMORY_STORE.get(user_id, [])
    if not items:
        return None
    latest = items[-1]
    return f"Latest memory ({latest.category}): {latest.summary}"
