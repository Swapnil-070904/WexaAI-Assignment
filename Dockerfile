FROM node:18-alpine AS b1
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent || npm install --silent

FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=b1 /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
EXPOSE 3000
USER node
CMD ["npm", "run", "start"]
