FROM node:lts-alpine as build-stage

ARG VITE_BACKEND_URL=http://localhost:4000

COPY . /var/www
WORKDIR /var/www
RUN npm install
RUN npm run build

FROM nginx:stable-alpine as production-stage
RUN mkdir -p /usr/share/nginx/static
RUN rm -r /etc/nginx/conf.d/default.conf
COPY --from=build-stage /var/www/dist /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf 