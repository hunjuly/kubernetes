const express = require('express');
const redis = require('redis');
const { Pool } = require('pg');
const { MongoClient } = require('mongodb');


const app = express();
const port = 3000;

// // PostgreSQL 설정
// const pool = new Pool({
//     user: 'yourusername',
//     host: 'localhost',
//     database: 'yourdatabase',
//     password: 'yourpassword',
//     port: 5432,
// });

// // MongoDB 설정
// const mongoClient = new MongoClient('mongodb://localhost:27017');
// let mongodb;

// mongoClient.connect().then(client => {
//     mongodb = client.db('yourdatabase');
// });

console.log(process.env.USERNAME, process.env.PASSWORD)

app.get('/redis', async (req, res) => {
    try {
        console.log('start redis', process.env)
        const url = `redis://${process.env['redis-host']}:6379`
        console.log(url)
        const redisClient = redis.createClient({ url  });

        await redisClient.connect();
        redisClient.set('somekey','value1234')
        const redisData = await redisClient.get('somekey');

        await redisClient.disconnect()

        res.json({ redis: redisData, });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.get('/data', async (req, res) => {
    try {
        // Redis에서 데이터 조회
        // const redisData = await redisClient.get('somekey');

        // // PostgreSQL에서 데이터 조회
        // const pgData = await pool.query('SELECT * FROM yourtable');

        // // MongoDB에서 데이터 조회
        // const mongoData = await mongodb.collection('yourcollection').findOne({});

        res.json({
            // redis: redisData,
            // postgres: pgData.rows,
            // mongo: mongoData,
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
