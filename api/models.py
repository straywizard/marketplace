from pydantic import BaseModel

class User(BaseModel):
    phone: str
    name: str
    lastname: str
    password: str

class UserLogin(BaseModel):
    phone: str
    password: str