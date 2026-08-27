# Bash Automation Lab: Log Backup and Rotation
This lab implements automated log backups on Ubuntu server using a bash script, including compression, file rotation to retain only the last 7 backups, and scheduling via cron for daily maintenance

### 1. Preparation
Set up the backup directory structure and set ownership:
```bash
sudo mkdir -p /var/backups/logs
sudo chown -R $USER:$USER /var/backups/logs
```
Creates the var/backups/logs and assigns ownership to the current user

### 2. Bash Script
Create a bash script named `backup_logs.sh` in your home directory:
```bash
nano backup_logs.sh
#!/bin/bash
BACKUP_DIR='/var/backups/logs'
LOG_DIR='/var/log'
DATE=$(date +'%Y-%m-%d')
BACKUP_FILE="logs-$DATE.tar.gz"
# Create compressed backup
tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$LOG_DIR"
# Keep only last 7 backups
cd "$BACKUP_DIR"
ls -tp | grep -v '/$' | tail -n +8 | xargs -I {} rm -- {}
# Log activity
echo "$(date '+%Y-%m-%d %H:%M:%S') Backup created: $BACKUP_FILE" >> "$BACKUP_DIR/backup.log"
```
Save and exit from Nano with CTRL+S and CTRL+X
