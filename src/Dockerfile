
FROM michaeldim/alpine-nginx-php

RUN apk update &&\
    apk add bash &&\
    rm -f /etc/nginx/conf.d/default.conf &&\
    rm -f /var/www/index.php

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY event.php /var/www/

EXPOSE 80
