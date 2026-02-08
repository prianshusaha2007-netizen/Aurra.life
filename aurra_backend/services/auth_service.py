from uuid import uuid4

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class LoginRequest(BaseModel):
    email: str
    device_name: str


class LoginResponse(BaseModel):
    user_id: str
    session_token: str


@router.post("/login", response_model=LoginResponse)
def login(payload: LoginRequest) -> LoginResponse:
    user_id = f"user-{uuid4().hex[:8]}"
    session_token = uuid4().hex
    return LoginResponse(user_id=user_id, session_token=session_token)
