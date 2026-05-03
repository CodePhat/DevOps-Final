# Stage 1: Build
FROM node:20-alpine AS builder
RUN apk add --no-cache curl
WORKDIR /app
COPY package*.json ./
# Upgrade packages to patch OS vulnerabilities
RUN apk update && apk upgrade
RUN npm install

# Stage 2: Production
FROM node:20-alpine
WORKDIR /app
# Upgrade packages here too for the final image
RUN apk update && apk upgrade
COPY --from=builder /app/node_modules ./node_modules
COPY . .

EXPOSE 3000
CMD ["node", "index.js"]