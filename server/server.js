const http = require('http');

const server = http.createServer((req, res) => {
    let body = 'v2, ';
    req.on('data', chunk => {
        body += chunk.toString();
    });

    req.on('end', () => {
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end(body);
        console.log(body)
    });
});

const port = 3000;
server.listen(port, () => {
    console.log(`서버가 http://localhost:${port} 에서 실행 중입니다.`);
    console.log(process.env.hostname, process.env.username, process.env.password)
    console.log( process.env.USERNAME, process.env.PASSWORD)
});

// curl -d Hello http://localhost:3000
