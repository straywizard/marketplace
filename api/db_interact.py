import asyncpg

async def init_database(DATABASE_URL: str):
    db = await asyncpg.connect(DATABASE_URL)
    try:
        query = """ CREATE TABLE IF NOT EXISTS clients (
            id SERIAL PRIMARY KEY,
            name TEXT,
            lastname TEXT,
            phone TEXT,
            password TEXT
        );
        CREATE TABLE IF NOT EXISTS refresh_tokens (
            phone TEXT,
            token TEXT
        ); """
        await db.execute(query)
    finally:
        await db.close()
