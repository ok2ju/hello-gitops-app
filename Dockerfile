# Real FE app: add a build stage first, e.g.
#   FROM node:22-alpine AS build
#   WORKDIR /app
#   COPY . .
#   RUN npm ci && npm run build
# then COPY --from=build /app/dist/ /usr/share/nginx/html/
FROM nginx:1.27-alpine

ARG VERSION=dev
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
RUN sed -i "s/__VERSION__/${VERSION}/" /usr/share/nginx/html/index.html
