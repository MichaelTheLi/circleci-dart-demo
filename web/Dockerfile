FROM nginx:latest

COPY containers/web/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY containers/web/nginx.conf /etc/nginx/nginx.conf

COPY /web/ /usr/share/nginx/html/

CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'