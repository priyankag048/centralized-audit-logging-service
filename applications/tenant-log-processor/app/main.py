import json
import asyncio
from contextlib import asynccontextmanager
from fastapi import FastAPI
from kafka import AIOKafkaConsumer
import asyncpg

from config import *

app = FastAPI()

@asynccontextmanager
async def lifespan():
  app.state.consumer = AIOKafkaConsumer(
    KAFKA_TOPICS,
    bootstrap_servers=KAFKA_BOOTSTRAP_SERVERS,
    group_id="tenant-logs-consumer",
  )
  app.state.db_pool = await asyncpg.create_pool(
    host=POSTGRES_HOST,
    port=POSTGRES_PORT,
    user=POSTGRES_USER,
    password=POSTGRES_PASSWORD,
    database=POSTGRES_DB,
    max_size=10,
  )
  await app.state.consumer.start();
  task = asyncio.create_task(process_messages())
  try:
        yield
  finally:
      await app.state.db_pool.close()
      await app.state.consumer.stop()
      task.cancel()
      print("Shutting down consumer and database connection")
        

app.router.lifespan_context = lifespan

async def process_messages():
    try:
        async for message in app.state.consumer:
            try:
                record = json.loads(message.value.decode('utf-8'))
                await insert_to_db(record)
            except Exception as e:
                print(f"Error processing message: {e} ")
                continue
    except Exception as e:
        print(f"Consumer loop error: {e} ")

async def insert_to_db(record):
    try:
        async with app.state.db_pool.acquire() as conn:
            await conn.execute("""
                    INSERT INTO tenant_logs (timestamp, tenant_id, service, log_level, message, user)
                    VALUES($1, $2, $3, $4, $5, $6)
                """,
                record["timestamp"],
                record["tenant_id"],
                record["service"],
                record["log_level"],
                record["message"],
            )
    except Exception as e:
        print(f"Error inserting to DB: {e} ")


@app.get("/health")
async def health():
    return {"status": "OK"}

