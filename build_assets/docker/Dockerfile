FROM nginxinc/nginx-unprivileged

COPY build/web /usr/share/nginx/html/

USER root

RUN chown 101:101 /usr/share/nginx/html/assets/assets/web/backend_url.txt

USER 101

COPY build_assets/docker/entrypoint.sh /

SHELL ["/bin/bash", "-c"]
ENTRYPOINT sh /entrypoint.sh
