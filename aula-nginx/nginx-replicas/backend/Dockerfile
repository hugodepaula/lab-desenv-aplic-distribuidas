FROM node:20-alpine

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 5050

CMD [ "node", "index.js" ]