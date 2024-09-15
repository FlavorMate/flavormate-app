#!/bin/sh

echo "Setting backend url to $BACKEND_URL"
echo "$BACKEND_URL" > /usr/share/nginx/html/assets/assets/web/backend_url.txt
nginx -g 'daemon off;'
