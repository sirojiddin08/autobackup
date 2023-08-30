#!/bin/bash

# Install sshpass if not installed
# sudo apt-get install sshpass

# Check if sshpass is installed
#which sshpass

#Give permission to folder 
#sudo chmod -R 777 /var/www/backup

# Set the script as executable
#chmod +x backup.sh

# Replace this code in your crontab file

#Every 1 minute
#*/1 * * * * /path/to/your/script.sh

# Every Day (Midnight):
#0 0 * * * /path/to/your/script.sh

# Every 3 Days (Midnight):
#0 0 */3 * * /path/to/your/script.sh

# Every Week (Monday Midnight):
#0 0 * * 1 /path/to/your/script.sh

# Every 14 Days (Midnight):
#0 0 */14 * * /path/to/your/script.sh

# Every Month (1st Day, Midnight):
#0 0 1 * * /path/to/your/script.sh

# Every Year (January 1st, Midnight):
#0 0 1 1 * /path/to/your/script.sh



# Define PostgreSQL connection variables
PGHOST="localhost" # Set the host where your PostgreSQL server is running
PGPORT="5432"      # Set the port number of your PostgreSQL server
PGUSER="postgres" # Replace with your PostgreSQL username
PGPASSWORD="postgres"  # Replace with your PostgreSQL password

# Define other script variables
DATABASE_NAME="database_name" # Replace with your database name
BACKUP_DIR="/var/www/backup" # Replace with your backup directory
BACKUP_FILE="$BACKUP_DIR/database_name_backup_$(date +\%Y\%m\%d).sql" # Replace with your backup file name

# Set the PGPASSWORD environment variable
export PGPASSWORD="$PGPASSWORD" # Use export to pass the variable to the environment of the child process

# Create a database backup without being prompted for the password
pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" "$DATABASE_NAME" > "$BACKUP_FILE"

# Define SSH connection variables for the remote server
REMOTE_USER="user" # Replace with your remote server username
REMOTE_HOST="0.0.0.0" # Replace with your remote server IP address or hostname
REMOTE_DIR="C:\Users\user\Documents" # Replace with your remote server backup directory
SSHPASS='password'  # Replace with your password

#Select the backup file to transfer to the remote server SCP is secure but RSYNC is faster

# Use sshpass to copy the backup file to the remote server
/usr/bin/sshpass -p "$SSHPASS" scp "$BACKUP_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/" # Replace with your command

# Use rsync to copy the backup file to the remote server
# /usr/bin/rsync -e "sshpass -p $SSHPASS ssh -o StrictHostKeyChecking=no -l $REMOTE_USER" "$BACKUP_FILE" "$REMOTE_HOST:$REMOTE_DIR/"


# Check if the file was copied successfully
if [ $? -eq 0 ]; then
    echo "Backup file copied to remote server."
else
    echo "Failed to copy the backup file to remote server."
    exit 1
fi

# Clean up: Delete the local backup file
rm -f "$BACKUP_FILE"

# Check if the file was deleted successfully
if [ $? -eq 0 ]; then
    echo "Local backup file deleted."
else
    echo "Failed to delete the local backup file."
    exit 1
fi

echo "Backup and transfer process completed successfully." 
