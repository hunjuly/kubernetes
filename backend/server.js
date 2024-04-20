const express = require('express');
const redis = require('redis');
const { Client } = require('pg');
const { MongoClient } = require('mongodb');
const fs = require('fs');

const app = express();
const port = 3000;

app.get('/redis', async (req, res) => {
    try {
        const url = `redis://${process.env['redis-host']}:6379`
        const redisClient = redis.createClient({ url });

        await redisClient.connect();
        redisClient.set('somekey', Date.now() % 1000)
        const redisData = await redisClient.get('somekey');

        await redisClient.disconnect()

        res.json({ redis: redisData, });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.get('/psql', async (req, res) => {
    try {
        const client = new Client({
            user: process.env.POSTGRES_USER,
            host: process.env["psql-host"],
            database: process.env.POSTGRES_DB,
            password: process.env.POSTGRES_PASSWORD,
            port: 5432,
        });

        await client.connect()

        await client.query('INSERT INTO example (name, value) VALUES ($1, $2)', ['item', Date.now() % 1000]);
        const pgData = await client.query('SELECT * FROM example');

        await client.end()

        res.json({ postgres: pgData.rows });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.get('/mongo', async (req, res) => {
    try {
        const mongoClient = new MongoClient('mongodb://localhost:27017');

        const client = await mongoClient.connect();
        const mongodb = client.db('yourdatabase');
        const mongoData = await mongodb.collection('yourcollection').findOne({});
        await client.close();

        res.json({ mongo: mongoData });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

fs.writeFile('/storage/logs.txt', 'Hello', (err) => {
    if (err) {
        console.error('파일 쓰기 오류:', err);
    }
});
