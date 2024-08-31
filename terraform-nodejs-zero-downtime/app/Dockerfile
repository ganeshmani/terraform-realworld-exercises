FROM --platform=linux/amd64 node:lts-alpine as builder
# Create app directory
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production image
FROM --platform=linux/amd64 node:lts-alpine
ENV NODE_ENV=production
USER node
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY --from=builder /app/build ./build
ENV PORT=8080
EXPOSE 8080
CMD [ "node", "build/main.js" ]