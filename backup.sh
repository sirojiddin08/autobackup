#!/bin/bash

# Define variables
PGHOST="localhost"  # Set the host where your PostgreSQL server is running
PGPORT="5432"       # Set the port number of your PostgreSQL server
PGUSER="postgres"  # Replace with your PostgreSQL username
PGPASSWORD="postgres"  # Replace with your PostgreSQL password
DATABASE_NAME="database_name" # Replace with your database name

BACKUP_DIR="/var/www/backup" # Replace with your backup directory
BACKUP_FILE="$BACKUP_DIR/database_name_backup_$(date +\%Y\%m\%d).sql" # Replace with your backup file name
TELEGRAM_BOT_TOKEN="1111111111111:AAGczfBv-EWkPzqHigTOhsdfsdpoaaHhphPhp" # Replace with your bot token
CHAT_ID="111111111" # Replace with your chat ID


# Set the PGPASSWORD environment variable
export PGPASSWORD="$PGPASSWORD"

# Create a database backup without being prompted for the password
pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" "$DATABASE_NAME" > "$BACKUP_FILE"


# Check if the backup file was created successfully
if [ $? -eq 0 ]; then
    echo "Database backup created successfully: $BACKUP_FILE"
else
    echo "Failed to create the database backup."
    exit 1
fi

# Send the backup file to Telegram
curl -F chat_id="$CHAT_ID" -F document=@"$BACKUP_FILE" "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument"

# Check if the file was sent successfully
if [ $? -eq 0 ]; then
    echo "Backup file sent to Telegram."
else
    echo "Failed to send the backup file to Telegram."
    exit 1
fi

# Delete the backup file
rm -f "$BACKUP_FILE"

# Check if the file was deleted successfully
if [ $? -eq 0 ]; then
    echo "Backup file deleted."
else
    echo "Failed to delete the backup file."
    exit 1
fi

echo "Backup and sending process completed successfully."


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
