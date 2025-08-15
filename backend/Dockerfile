# Imagem Node.js
FROM node:20-alpine

# Pasta de trabalho
WORKDIR /app

# Copia arquivos de dependências e instala
COPY package.json ./
RUN npm install

# Copia o resto do código
COPY . .

# Porta de exposição, porém não libera para acesso externo
EXPOSE 3000

CMD ["node", "index.js"]
