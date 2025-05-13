# Use Node.js LTS image
FROM node:18

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the code
COPY . .

# Expose Vite dev server port
EXPOSE 5173

# Start Vite dev server
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]