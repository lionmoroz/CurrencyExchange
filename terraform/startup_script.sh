#!/bin/bash
apt update
apt install -y nginx


mkdir /var/www/currency 

git clone https://github.com/lionmoroz/CurrencyExchange /var/www/currency/

touch /etc/nginx/sites-available/currency.conf

ln /etc/nginx/sites-available/currency.conf /etc/nginx/sites-enabled/currency.conf

public_dns=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)

tee /etc/nginx/conf.d/currency.conf > /dev/null <<EOF
server {
    listen 80;
    server_name $public_dns;
    
    location /page/ {
        alias /var/www/currency/CurrencyExchange;
        try_files $uri $uri/ =404;
        index index.html;
    }

    location / {
        root /var/www/html;
        index index.nginx-debian.html;
        try_files $uri $uri/ =404;
    }
}
server_names_hash_bucket_size 164;

EOF

sudo chown -R www-data:www-data /var/www/currency/CurrencyExchange
sudo chmod -R 755 /var/www/currency/CurrencyExchange

service nginx restart