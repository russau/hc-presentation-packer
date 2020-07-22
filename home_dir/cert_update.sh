#!/bin/bash
# put scripts in place for nginx
cd /home/ubuntu

# check we have all the cert files
if [ ! -e web_issuer.pem ] || \
   [ ! -e web_certificate.pem ] || \
   [ ! -e web_cert_private_key_ciphertext.bin ] 
   then
     echo "Certificate files not present"
     exit 1
fi

cat web_certificate.pem web_issuer.pem | sudo tee /etc/nginx/conf.d/fullchain.pem
echo "Wrote fullchain cert"

# decrypt the encrypted cert from terraform
region=$(curl -s 169.254.169.254/latest/meta-data/placement/region)
aws kms decrypt \
--ciphertext-blob fileb://web_cert_private_key_ciphertext.bin \
--region $region  \
--query Plaintext --output text | base64 -d  \
| sudo tee /etc/nginx/conf.d/privkey.pem
echo "Decrypted cert privatekey"

# update nginx config to point to SSL certs
cat <<EOF | sudo tee /etc/nginx/sites-enabled/default
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  listen 443 ssl default_server;
  listen [::]:443 ssl default_server;
  ssl_certificate /etc/nginx/conf.d/fullchain.pem;
  ssl_certificate_key /etc/nginx/conf.d/privkey.pem;
  root /var/www/html;
  index index.html index.htm index.nginx-debian.html;
  server_name _;
  location / {
    try_files \$uri \$uri/ =404;
  }
}
EOF
echo "Configured nginx"
