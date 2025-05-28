import redis

r = redis.Redis(host='localhost', port=6379, decode_responses=True)

r.hset('user-session:123', mapping={
    "name": "Hugo",
    "surname": "de Paula",
    "company": "PUC Minas",
    "age": 48,
    "looks": "great"
})
# True

print(r.hgetall('user-session:123'))
# {'surname': 'de Paula', 'name': 'Hugo', 'company': 'PUC Minas', 'age': '48', 'looks': 'great'}


# Transactions (Multi/Exec)
# python.exe -m asyncio

import asyncio
import redis.asyncio as redis_async

async def run_transaction():
    r = await redis_async.from_url("redis://localhost")

    async with r.pipeline(transaction=True) as pipe:
        ok1, ok2 = await (pipe.set("op1", "start").set("op2", "end").execute())

    assert ok1
    assert ok2

# Run the async function
asyncio.run(run_transaction())
print(r.get("op1"))
print(r.get("op2"))