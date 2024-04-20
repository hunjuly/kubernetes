FROM node:lts-alpine

WORKDIR /app

COPY . .

RUN npm ci
EXPOSE 3000

CMD ["node","server.js"]
