server {
    listen 80;
    listen [::]:80;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name domain.com www.domain.com;

    location /files {
        alias /files/;
        gzip_static on;
        expires max;
        add_header Cache-Control private;
    }

    location /subscriptions {
        proxy_pass http://server:3000/subscriptions;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location /graphql {
        proxy_pass http://server:3000/graphql;
        proxy_set_header X-Real-IP $remote_addr;
    }



    location ~ /.well-known/acme-challenge {
        allow all;
        root /var/www/certbot;
    }

    location / {
        rewrite ^ https://$host$request_uri? permanent;
    }
}


server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name domain.com www.domain.com;

        server_tokens off;

        ssl_certificate /etc/letsencrypt/live/domain.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/domain.com/privkey.pem;


        include /etc/letsencrypt/options-ssl-nginx.conf;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

        location /files {
            alias /files/;
            gzip_static on;
            expires max;
            add_header Cache-Control private;
        }

        location /subscriptions {
            proxy_pass http://server:3000/subscriptions;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
        }

        location /graphql {
            proxy_pass http://server:3000/graphql;
            proxy_set_header X-Real-IP $remote_addr;
        }
}

        