FROM node:14-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm cache clean --force
RUN npm install --verbose
COPY . .
RUN npm run build

FROM nginx:stable-alpine AS production-stage
COPY --from=build-stage /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]