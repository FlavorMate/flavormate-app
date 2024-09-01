FROM nginxinc/nginx-unprivileged

COPY build/web/ /usr/share/nginx/html/
