FROM node:10

COPY package*.json ./
COPY node_modules /
COPY . .
EXPOSE 8080
CMD [ "node", "app.js" ]