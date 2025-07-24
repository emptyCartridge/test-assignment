from sqlalchemy import create_engine

DB_URL = "postgresql+psycopg2://user1:password2@localhost:5432/user1"

engine = create_engine(DB_URL)
