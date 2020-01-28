FROM node:alpine as build

LABEL maintainer="Tobias Rös - <roes@amicaldo.de>"

WORKDIR /usr/src/app
COPY . /usr/src/app

RUN yarn install

FROM openresty/openresty:alpine

ENV CRONJOB_ITERATION=15

WORKDIR /var/www/html

COPY --from=build /usr/src/app /var/www/html
RUN cp /var/www/html/config/vhost.conf /etc/nginx/conf.d/default.conf

RUN apk update && apk add \
  nginx-mod-http-lua \
  python3 \
  py-pip \
  && rm -rf /var/lib/apt/lists/*

RUN pip install speedtest-cli

RUN chmod +x /var/www/html/config/run.sh && \
    chown -R nginx:nginx /var/www/html

USER nginx

CMD [ "config/run.sh" ]