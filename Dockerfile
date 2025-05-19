
FROM node:19-alpine3.15 AS dev-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --frozen-lockfile


FROM node:19-alpine3.15 AS builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN yarn test
RUN yarn build

# Si hay carpeta de distribucion no requerimos instalar las dependencias de produccion, pues ya van en dist
# FROM nginx:1.23.3 AS prod-deps
# WORKDIR /app
# COPY package.json package.json
# RUN yarn install --prod --frozen-lockfile


FROM nginx:1.23.3 AS prod

COPY --from=builder /app/dist /usr/share/nginx/html/
COPY --from=builder /app/assets/heroes/ /usr/share/nginx/html/assets/heroes/
EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]









