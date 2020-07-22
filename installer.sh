#!/bin/bash -ex

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCy2d4lcatU8CV5rVBZI43Ziu9QD7yBxn0ncjGQYCF+mEKDIqGG2yxGAfHBRzI9bcJlWXeXILgqEELfenUq3NTaT1oEenfJxvNkLWxjQ1ZyGa+R3J3WEhy4dnaNZ30DMAwso/+05+UHzpOiskp+LLCFympVrAeJCzfMpJUgaUZ2Hwqid0sYnYHu/3awFKS33WGTpZbfr8EM4XipoC5gVAA0aDjkAhzt6PXBOddDUALaPz6CwTy3yd929bQD9VsQVk6qtfvx1DysQQLF2MfM7pu6VqWuzlfozwoGlfsSImjSdptAZVjabLfn0FnM8UT8omizjlgjHK+fPz/Y1DrSa621" >> /home/ubuntu/.ssh/authorized_keys

echo "Waiting for cloudinit to complete"
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done

# lots of dependencies for pageres
# https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#chrome-headless-doesnt-launch-on-unix
sudo apt update && sudo apt install -y ca-certificates fonts-liberation libappindicator3-1 libasound2 \
libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 \
libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 \
libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release \
wget xdg-utils 

sudo apt install -y npm awscli

# browser screenshot utility
sudo npm install --global pageres-cli

# bats for some automated tests
sudo apt-get install -y bats

# setup the webserver
sudo apt install -y nginx 

# certificate installer unit file
sudo cp cert_update.service /etc/systemd/system/
sudo systemctl enable cert_update.service

cat /home/ubuntu/app/index.html | envsubst | sudo tee /var/www/html/index.html
