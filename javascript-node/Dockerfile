FROM node:20-bookworm-slim
LABEL description="JavaScript Node benchmark"
WORKDIR /app

COPY package*.json .
RUN npm install

COPY . .

EXPOSE 2000
CMD ["node", "src/main.js"]

