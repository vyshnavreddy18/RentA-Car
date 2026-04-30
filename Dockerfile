# ---------- Stage 1: Build Angular app ----------
FROM node:16-alpine AS build

WORKDIR /app

COPY package*.json ./

# Use install instead of ci (more tolerant)
RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build --configuration=production

# ---------- Stage 2: Nginx ----------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

# ✅ IMPORTANT: update folder name if needed
COPY --from=build /app/dist/RentACar-FrontEnd /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
