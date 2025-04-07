import asyncpg
import asyncio
import bcrypt
from dotenv import load_dotenv
import uvicorn
from fastapi import FastAPI, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer
from db_interact import init_database
from models import User, UserLogin
from jwt_config import create_access_token, verify_token
import os

load_dotenv()

app = FastAPI()
path_to_database = os.getenv("DATABASE_URL")
asyncio.run(init_database(path_to_database))
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

@app.post('/register')
async def register(user: User):
    db = await asyncpg.connect(path_to_database)
    try:
        query = f""" SELECT phone FROM clients WHERE phone = $1 """
        row = await db.fetchrow(query, user.phone)
        if not row:
            hashed_password = bcrypt.hashpw(user.password.encode('utf-8'), bcrypt.gensalt())
            query = f""" INSERT INTO clients (phone, name, lastname, password) VALUES ($1, $2, $3, $4) """
            await db.execute(query, user.phone, user.name, user.lastname, hashed_password.decode('utf-8'))
            return {'message': 'User registered successfully'}
        else:
            raise HTTPException(status_code=409, detail='A user with this phone number already exists')
    finally:
        await db.close()

@app.post("/login")
async def login(user: UserLogin):
    db = await asyncpg.connect(path_to_database)
    try:
        query = "SELECT * FROM clients WHERE phone = $1"
        row = await db.fetchrow(query, user.phone)
        if not row:
            raise HTTPException(status_code=401, detail="Invalid phone or password")

        stored_password = row["password"]
        if not bcrypt.checkpw(user.password.encode(), stored_password.encode()):
            raise HTTPException(status_code=401, detail="Invalid phone or password")

        token = create_access_token({"sub": row["phone"]})
        return {"access_token": token, "token_type": "bearer"}
    finally:
        await db.close()

async def get_current_user(token: str=Depends(oauth2_scheme)):
    payload = verify_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    return payload["sub"]

@app.get("/me")
async def read_current_user(user_phone: str = Depends(get_current_user)):
    return {"message": f"Hello, user with phone {user_phone}!"}

uvicorn.run(app, host = '0.0.0.0', port = 8000)
