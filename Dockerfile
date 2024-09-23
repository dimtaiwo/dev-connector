# Stage 1: Build React application
FROM node:16-alpine AS build

# Set working directory for React app
WORKDIR /client

# Copy client/package.json and client/package-lock.json
COPY package*.json .

# Install dependencies for React
RUN npm install

# Copy the entire client folder to the container
COPY . /client/.

# Build the React app for production
RUN npm run build

# Stage 2: Build the Node.js server
FROM node:16-alpine

# Set the working directory for the server
WORKDIR /

# Copy server-side package.json and package-lock.json
COPY package*.json ./

# Install server-side dependencies
RUN npm install

# Copy the server-side code to the container
COPY . .

# Copy the built React app from the previous stage to the public folder in server
COPY --from=build /client/build ./client/build

# Expose the port your Node.js app runs on
EXPOSE 5000

# Start the server
CMD ["npm", "start"]
