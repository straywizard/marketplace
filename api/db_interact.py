import asyncpg

async def init_database(path_to_database: str):
    db = await asyncpg.connect(path_to_database)
    try:
        query = """ CREATE TABLE IF NOT EXISTS clients (
            id SERIAL PRIMARY KEY,
            name TEXT,
            lastname TEXT,
            phone TEXT,
            password TEXT
        ) """
        await db.execute(query)
    finally:
        await db.close()
