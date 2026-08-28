# Web server setup with apache2
This lab demonstrates the setup of Apache on ubuntu, including system updates, firewalls, virtual host configuration for HTTP and HTTPS, and self signed ssl-certificate

### 1. Preparation
Update the system packages and install apache2:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 -y
```
check and activate the service
```bash
sudo systemctl status apache2
sudo systemctl enable apache2
sudo systemctl start apache2
```

### 2. Configure the firewall
Grant HTTP port 80 and HTTPS port 443 traffic access:
```bash
sudo ufw allow 'Apache Full'
sudo ufw enable
sudo ufw status
```
Expected: Apache full listed as allow 

### 3. Create a dummy website
Create a directory for your website and set permissions:
```bash
sudo mkdir -p /var/www/mywebsite
sudo chown -R $USER:$USER /var/www/mywebsite
```
Create a simple index.html file to test the website:
```bash
echo "<h1>My first website with HTTPS</h1>" > /var/www/mywebsite/index.html
```
inspect the file:
```bash
cat /var/www/mywebsite/index.html
```
Expected: Html to display

### 4. Configure a virtual host
Define the virtual host configuration:
```bash
sudo nano /etc/apache2/sites-available/mywebsite.conf
```
insert the following
```apache
<VirtualHost *:80>
    ServerAdmin
    ServerName mywebsite.com
    DocumentRoot /var/www/mywebsite
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
deativate the default and activate the site and reload:
```bash
sudo a2dissite 000-default.conf
sudo a2ensite mywebsite.conf
sudo systemctl reload apache2
```
Map the domain locally by editing the host file
```bash
sudo nano /etc/hosts
#append the your iP and site name
198.XX.XX.XX mywebsite.local
```
test the site
```bash
curl http://mywebsite.local
```

### 5. Enable HTTPS with signed-self certificate
install and Generate a self-signed SSL certificate:
```bash
sudo apt install openssl -y
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/mywebsite.key -out /etc/ssl/certs/mywebsite.crt
```
provide the details:
- Country Name: GH
- State: kumasi
- Locality: Some-two
- Organization: MyLab
- Organizational Unit: IT
- Common Name: mywebsite.local
- Email Address: admin@example.com

configure the HTTPs virtual host:
```bash
sudo nano /etc/apache2/sites-available/mywebsite-ssl.conf
```
Insert the following:
```apache
<VirtualHost *:80>
    ServerAdmin admin@example.com
    ServerName mywebsite.local
    DocumentRoot /var/www/mywebsite
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/mywebsite.crt
    SSLCertificateKeyFile /etc/ssl/private/mywebsite.key
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
Enable the SSL module and site, restart apache to apply the configs
```bash
sudo a2enmod ssl
sudo a2ensite mywebsite-ssl.conf
sudo systemctl restart apache2
```

Test HTTPs access
```bash
curl -k https://mywebsite.local
```
Expected: Error

Solution: change the virtual host config from Virtualhost *:80 to Virtualhost *:443

Test HTTPs access again
```bash
curl -k https://mywebsite.local
```
Expected: Success