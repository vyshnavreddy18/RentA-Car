# Stage 1: Build Angular app
FROM node:16-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build --configuration=production

# ✅ DEBUG: LIST FILES AFTER BUILD
RUN echo "---- DIST OUTPUT ----" && ls -R dist

# Stage 2: Serve with nginx
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

# ✅ TEMP copy (we will fix after seeing logs)
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
``
