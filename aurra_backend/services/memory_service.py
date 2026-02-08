from datetime import datetime, timezone
from typing import Any
from uuid import uuid4

from fastapi import APIRouter
from pydantic import BaseModel, Field

router = APIRouter()

_MEMORY_STORE: dict[str, list[dict[str, Any]]] = {}


class MemoryRecord(BaseModel):
    memory_id: str = Field(default_factory=lambda: f"mem-{uuid4().hex[:8]}")
    summary: str
    created_at: str = Field(
        default_factory=lambda: datetime.now(timezone.utc).isoformat()
    )


class StoreMemoryRequest(BaseModel):
    user_id: str
    summary: str


class StoreMemoryResponse(BaseModel):
    record: MemoryRecord


class RetrieveMemoryResponse(BaseModel):
    records: list[MemoryRecord]


@router.post("/store-memory", response_model=StoreMemoryResponse)
def store_memory(payload: StoreMemoryRequest) -> StoreMemoryResponse:
    record = MemoryRecord(summary=payload.summary)
    _MEMORY_STORE.setdefault(payload.user_id, []).append(record.model_dump())
    return StoreMemoryResponse(record=record)


@router.get("/retrieve-memory", response_model=RetrieveMemoryResponse)
def retrieve_memory(user_id: str) -> RetrieveMemoryResponse:
    records = [MemoryRecord(**item) for item in _MEMORY_STORE.get(user_id, [])]
    return RetrieveMemoryResponse(records=records)


def remember_message(user_id: str, message: str) -> None:
    _MEMORY_STORE.setdefault(user_id, []).append(
        MemoryRecord(summary=message).model_dump()
    )
