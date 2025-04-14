import asyncpg
import asyncio
import bcrypt
from dotenv import load_dotenv
import uvicorn
from fastapi import FastAPI, HTTPException, Body, Depends, Query
from fastapi.security import OAuth2PasswordBearer
from fastapi.staticfiles import StaticFiles
from db_interact import init_database
from models import User, UserLogin
from jwt_config import create_access_token, create_refresh_token, decode_token
import os

load_dotenv()

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
DATABASE_URL = os.getenv("DATABASE_URL")
asyncio.run(init_database(DATABASE_URL))
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

async def get_current_user(token: str=Depends(oauth2_scheme)):
    payload = decode_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    return payload["sub"]

@app.get("/")
async def cron_handler():
    return {"message": "Welcome to my API"}

@app.get("/me")
async def read_current_user(user_phone: str=Depends(get_current_user)):
    return {"message": f"Hello, user with phone {user_phone}!"}

@app.post('/register')
async def register(user: User):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = "SELECT phone FROM clients WHERE phone = $1"
        row = await db.fetchrow(query, user.phone)
        if not row:
            hashed_password = bcrypt.hashpw(user.password.encode('utf-8'), bcrypt.gensalt())
            query = "INSERT INTO clients (phone, name, lastname, password) VALUES ($1, $2, $3, $4)"
            await db.execute(query, user.phone, user.name, user.lastname, hashed_password.decode('utf-8'))
            return {'message': 'User registered successfully'}
        else:
            raise HTTPException(status_code=409, detail='A user with this phone number already exists')
    finally:
        await db.close()

@app.post("/login")
async def login(user: UserLogin):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = "SELECT * FROM clients WHERE phone = $1"
        row = await db.fetchrow(query, user.phone)
        if not row:
            raise HTTPException(status_code=401, detail="Invalid phone or password")

        stored_password = row["password"]
        if not bcrypt.checkpw(user.password.encode(), stored_password.encode()):
            raise HTTPException(status_code=401, detail="Invalid phone or password")

        access_token = create_access_token({"sub": row["phone"]})
        refresh_token = create_refresh_token({"sub": row["phone"]})

        query = "INSERT INTO refresh_tokens (phone, token) VALUES ($1, $2)"
        await db.execute(query, row["phone"], refresh_token)

        return {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "bearer"
        }
    finally:
        await db.close()

@app.post("/refresh")
async def refresh_token(refresh_token: str=Body(..., embed=True)):
    payload = decode_token(refresh_token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token")

    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = "SELECT * FROM refresh_tokens WHERE phone = $1 AND token = $2"
        result = await db.fetchrow(query, payload["sub"], refresh_token)
        if not result:
            raise HTTPException(status_code=401, detail="Refresh token is not valid")

        new_access_token = create_access_token({"sub": payload["sub"]})
        return {
            "access_token": new_access_token,
            "token_type": "bearer"
        }
    finally:
        await db.close()

@app.post("/logout")
async def logout(refresh_token: str=Body(..., embed=True)):
    payload = decode_token(refresh_token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")

    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = "DELETE FROM refresh_tokens WHERE phone = $1 AND token = $2"
        await db.execute(query, payload["sub"], refresh_token)
        return {"detail": "Successfully logged out"}
    finally:
        await db.close()

@app.get("/products")
async def get_products(
    limit: int = Query(5, gt=0),
    offset: int = Query(0, ge=0),
    user_phone: str = Depends(get_current_user)
):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = "SELECT * FROM products LIMIT $1 OFFSET $2"
        rows = await db.fetch(query, limit, offset)
        products = []

        for row in rows:
            in_cart = await db.fetchval("SELECT 1 FROM cart WHERE user_phone = $1 AND product_id = $2", user_phone, row["id"])
            in_fav = await db.fetchval("SELECT 1 FROM favourite WHERE user_phone = $1 AND product_id = $2", user_phone, row["id"])

            products.append({
                "id": row["id"],
                "name": row["name"],
                "price": row["price"],
                "image": row["image_url"],
                "description": row["description"],
                "isInCart": bool(in_cart),
                "isFavourite": bool(in_fav)
            })

        total_count_query = "SELECT COUNT(*) FROM products"
        total_count_result = await db.fetchval(total_count_query)

        return {
            "products": products,
            "total_count": total_count_result,
            "limit": limit,
            "offset": offset
        }
    finally:
        await db.close()

@app.post("/cart/add")
async def add_to_cart(
    product_id: int,
    user_phone: str = Depends(get_current_user)
):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = "INSERT INTO cart (user_phone, product_id) VALUES ($1, $2) ON CONFLICT DO NOTHING"
        await db.execute(query, user_phone, product_id)
        return {"detail": "Product added to cart"}
    finally:
        await db.close()

@app.delete("/cart/remove")
async def remove_from_cart(
    product_id: int,
    user_phone: str = Depends(get_current_user)
):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = "DELETE FROM cart WHERE user_phone = $1 AND product_id = $2"
        await db.execute(query, user_phone, product_id)
        return {"detail": "Product removed from cart"}
    finally:
        await db.close()


@app.post("/favourite/add")
async def add_to_favourite(
    product_id: int,
    user_phone: str = Depends(get_current_user)
):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = "INSERT INTO favourite (user_phone, product_id) VALUES ($1, $2) ON CONFLICT DO NOTHING"
        await db.execute(query, user_phone, product_id)
        return {"detail": "Product added to favourites"}
    finally:
        await db.close()

@app.delete("/favourite/remove")
async def remove_from_favourite(
    product_id: int,
    user_phone: str = Depends(get_current_user)
):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = "DELETE FROM favourite WHERE user_phone = $1 AND product_id = $2"
        await db.execute(query, user_phone, product_id)
        return {"detail": "Product removed from favourites"}
    finally:
        await db.close()

@app.get("/cart")
async def get_cart(user_phone: str = Depends(get_current_user)):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = """
            SELECT p.*, TRUE AS isInCart, 
                   (SELECT TRUE FROM favourite f WHERE f.product_id = p.id AND f.user_phone = $1) AS isFavourite
            FROM products p
            JOIN cart c ON p.id = c.product_id
            WHERE c.user_phone = $1
        """
        rows = await db.fetch(query, user_phone)
        return [dict(row) for row in rows]
    finally:
        await db.close()

@app.get("/favourite")
async def get_favourites(user_phone: str = Depends(get_current_user)):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = """
            SELECT p.*, 
                   (SELECT TRUE FROM cart ct WHERE ct.product_id = p.id AND ct.user_phone = $1) AS isInCart,
                   TRUE AS isFavourite
            FROM products p
            JOIN favourite f ON p.id = f.product_id
            WHERE f.user_phone = $1
        """
        rows = await db.fetch(query, user_phone)
        return [dict(row) for row in rows]
    finally:
        await db.close()

uvicorn.run(app, host = '0.0.0.0', port = 8000)
