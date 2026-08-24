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