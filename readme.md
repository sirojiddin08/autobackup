# PostgreSQL Backup Scripts

This repository contains two bash scripts for backing up a PostgreSQL database and transferring the backup file.

## Scripts

### backup.sh

This script performs the following:

- Connects to the PostgreSQL database using the provided credentials
- Creates a database backup by dumping the database to a SQL file
- Sends the backup file to a Telegram bot
- Deletes the local backup file after sending

It requires setting the following environment variables:

- PGHOST - PostgreSQL host
- PGPORT - PostgreSQL port
- PGUSER - PostgreSQL user  
- PGPASSWORD - PostgreSQL password
- DATABASE_NAME - Database name to backup
- BACKUP_DIR - Local backup directory
- TELEGRAM_BOT_TOKEN - Telegram bot API token
- CHAT_ID - Telegram chat ID to send file to

### scp.sh

This script performs the following:

- Creates a PostgreSQL database backup like backup.sh
- Copies the backup file to a remote server via SCP using sshpass
- Deletes the local backup after copying

It requires setting the following environment variables:

- PGHOST - PostgreSQL host
- PGPORT - PostgreSQL port  
- PGUSER - PostgreSQL user
- PGPASSWORD - PostgreSQL password
- DATABASE_NAME - Database name to backup   
- BACKUP_DIR - Local backup directory
- REMOTE_USER - Remote server username
- REMOTE_HOST - Remote server IP/hostname
- REMOTE_DIR - Remote server backup directory
- SSHPASS - Remote server password

## Usage 

These scripts can be executed manually or via cron to schedule automatic database backups.

Some examples of running them on a schedule via cron:

Daily at midnight:

0 0 * * * /path/to/backup.sh

Weekly on Mondays: 

0 0 * * 1 /path/to/scp.sh

## Requirements

- PostgreSQL
- sshpass (for scp.sh)
- Access to a Telegram bot (for backup.sh)

## License

MIT