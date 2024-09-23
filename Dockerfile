
# Stage 1: Build the application
FROM node:18-alpine as builder

WORKDIR /app/dev-connector

COPY package.json package-lock.json ./

RUN npm install --legacy-peer-deps --network-timeout=1000000

COPY . .

RUN npm run build

# Stage 2: Serve the application
FROM node:18-alpine as runner

ENV HOST 0.0.0.0

WORKDIR /app/dev-connector

COPY --from=builder /app/dev-connector ./

# Set environment variables for Next.js
ENV NEXT_PUBLIC_HOST=0.0.0.0
ENV NEXT_PUBLIC_PORT=8080

# Run the Next.js application with npm
CMD ["npm", "start", "--", "-p", "8080"]