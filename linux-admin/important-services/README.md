# Essential Services Configuration #: SSH, Cron Jobs, Firewall, and Systemd Services

## Objective
This lab covers setting up and verifying the core Ubuntu Server Services: secure SSH for remote access, cron for scheduled tasks, firewall for access control and systemd customised with dependencies .. All are done on an Ubuntu VirtualBox VM


### SSH Configuration
Verify if SSH server is installed and configured on it
```bash
dpkg -l | openssh-server
```
Expected: Openssh listed as install else install 
```bash
 sudo apt install openssh-server
```

Check Service Status
```bash
sudo systemctl status ssh
```
Expected: Active running and enable.. if not
```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```
Test local connection from host
```bash
ssh user@10.0.2.16
```
VM IP: 10.0.2.16 username:User



### Cron Jobs
install crontab if not installed
```bash
sudo apt install crontab
```
Check exiting jobs for daily backup execution
```bash
crontab -l
```
Expected: No crontab for user if none

Entry:*** "0 2 * * * /homw/user/Desktop/logs.txt" ***

Add test job for minute-by-minute logging:
```bash
crontab -e
```
Append: * * * * * echo "Test cron $(date)" >> /home/user/desktop/cron_test.log

add monitoring
```bash
tail -f /home/user/desktop/cron_test.log
```

### Firewall Configuration
install firewall(ufw) if not installed
```bash
sudo apt install ufw
```

Set default policies to deny incoming and allow outgoing traffic
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

Permit SSH:
```bash
sudo ufw allow ssh
sudo ufw allow 22/tcp
```

Activate logging:
```bash
sudo ufw logging on
```
Enable and inspect status
```bash
sudo ufw enable
sudo ufw status numbered
```
Expected: ONly port 22/tcp and ssh allowed

other traffic disabled only ssh works

### Systemd Services
Create own service 
```bash
sudo nano /etc/systemd/system/my_service.service
```

insert code

```ini
[Unit]
Description=My Custom Service
After=ufw
[Service]
Type=simple
ExecStart=/bin/bash -c 'while true; do echo "My Service is running"; sleep 60; done >> /home/user/Desktop'
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
Reload daemon, enable, start and check status
```bash
sudo systemctl daemon-reload
sudo systemctl enable my_service
sudo systemctl start my_service
sudo systemctl status my_service
```
