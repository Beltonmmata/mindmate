# Use lightweight Node image
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy only package.json and package-lock.json first
COPY package*.json ./

# Install production deps only
RUN npm install --omit=dev

# Copy the rest of the backend source code
COPY . .

# Expose the port Railway will map automatically
EXPOSE 8080

# Railway will inject PORT, so force the app to use it
ENV PORT=8080

# Start the app
CMD ["npm", "start"]
