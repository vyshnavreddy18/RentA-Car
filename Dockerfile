# ---------- Stage 1: Build Angular app ----------
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files first (for caching)
COPY package*.json ./

# Install dependencies (clean + reliable)
RUN npm ci --legacy-peer-deps

# Copy full project
COPY . .

# Build Angular app (modern syntax)
RUN npm run build --configuration=production

# ---------- Stage 2: Nginx Server ----------
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built Angular files
# ⚠️ Replace with your actual Angular output folder name if different
COPY --from=build /app/dist/RentACar-FrontEnd /usr/share/nginx/html

# Optional: custom nginx config (for Angular routing)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
