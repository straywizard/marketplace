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
        CREATE TABLE IF NOT EXISTS products (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL,
            price NUMERIC NOT NULL,
            description TEXT,
            image_url TEXT
        );

        INSERT INTO products (name, price, description, image_url) VALUES
        ('Ноутбук ASUS VivoBook', 74990.00, 'Лёгкий и быстрый ноутбук для повседневной работы', 'http://0.0.0.0:8000/static/images/tmp.jpg'),
        ('Наушники Sony WH-1000XM4', 29990.00, 'Беспроводные наушники с шумоподавлением', 'http://0.0.0.0:8000/static/images/tmp.jpg'),
        ('Смартфон IPhone 14', 99990.00, 'Флагман Apple с мощным процессором и отличной камерой', 'http://0.0.0.0:8000/static/images/tmp.jpg')
        ON CONFLICT DO NOTHING;

        CREATE TABLE IF NOT EXISTS refresh_tokens (
            phone TEXT,
            token TEXT
        ); """
        await db.execute(query)
    finally:
        await db.close()
