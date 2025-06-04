FROM nginx:latest

# Copy Nginx config
COPY conf.d/default.conf /etc/nginx/conf.d/default.conf

# Create cache directory with proper permissions
RUN mkdir -p /var/cache/nginx && \
    chown -R nginx:nginx /var/cache/nginx

# Copy static content if you have any
COPY static /usr/share/nginx/static

# Set cache directory volume
VOLUME /var/cache/nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
