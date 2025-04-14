from pydantic import BaseModel, Field, field_validator
import re

class UserLogin(BaseModel):
    phone: str
    password: str

    @field_validator("phone")
    @classmethod
    def validate_phone(cls, value):
        if not re.fullmatch(r"\d{11}", value):
            raise ValueError("Phone number must be exactly 11 digits")
        return value

class User(UserLogin):
    phone: str = Field(..., example="79998887766")
    name: str
    lastname: str
    password: str = Field(..., min_length=8)
