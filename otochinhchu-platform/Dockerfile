# ---- Build stage ----
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install --no-audit --no-fund

COPY tsconfig.json nest-cli.json ./
COPY src ./src
RUN npx nest build

# ---- Runtime stage ----
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund && npm rebuild bcrypt

COPY --from=build /app/dist ./dist
COPY public ./public
RUN mkdir -p public/uploads

EXPOSE 3000
CMD ["node", "dist/main.js"]
