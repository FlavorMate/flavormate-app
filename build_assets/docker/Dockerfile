FROM nginxinc/nginx-unprivileged

COPY build/web /usr/share/nginx/html/

RUN rm /etc/nginx/conf.d/*.conf
COPY build_assets/docker/nginx.conf /etc/nginx/conf.d/default.conf

# Access permissions to the nginx user because it needs to write at runtime to this file
USER root
RUN chown nginx:nginx /usr/share/nginx/html/assets/assets/web/backend_url.txt
USER nginx

COPY build_assets/docker/entrypoint.sh /

EXPOSE 8080

SHELL ["/bin/bash", "-c"]
ENTRYPOINT exec sh /entrypoint.sh
