#!/bin/bash

# Usage: ./restore_odoo_db.sh <backup_archive> <new_database_name>
# Supports: .zip, .gz, .tar, .tar.gz, .tgz

if [ $# -ne 2 ]; then
  echo "Usage: rdb <backup_file.{zip,tar,tar.gz,tgz,sql.gz}> <new_database_name>"
  exit 1
fi

BACKUP_FILE="$1"
NEW_DB_NAME="$2"
OWNER="min" #db_user
TEMP_DIR=$(mktemp -d -p $HOME/.db_restores)

# Extract the backup based on file type
echo "Extracting $BACKUP_FILE to $TEMP_DIR..."
case "$BACKUP_FILE" in
  *.zip)
    unzip -q "$BACKUP_FILE" -d "$TEMP_DIR"
    ;;
  *.tar.gz|*.tgz)
    tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"
    ;;
  *.tar)
    tar -xf "$BACKUP_FILE" -C "$TEMP_DIR"
    ;;
  *.gz)
    # For .sql.gz file
    cp "$BACKUP_FILE" "$TEMP_DIR"
    gunzip "$TEMP_DIR/$(basename "$BACKUP_FILE")"
    ;;
  *)
    echo "Unsupported file format: $BACKUP_FILE"
    rm -rf "$TEMP_DIR"
    exit 1
    ;;
esac

# Find the .sql file inside the extracted contents
SQL_FILE=$(find "$TEMP_DIR" -name '*.sql' | head -n 1)

if [ ! -f "$SQL_FILE" ]; then
  echo "Error: No .sql file found after extracting."
  rm -rf "$TEMP_DIR"
  exit 1
fi

echo "Creating database: $NEW_DB_NAME with owner $OWNER..."
psql -U min postgres -c "CREATE DATABASE \"$NEW_DB_NAME\" WITH OWNER $OWNER;"

echo "Restoring database from $SQL_FILE..."
psql -U min postgres -d "$NEW_DB_NAME" -f "$SQL_FILE"

echo "Resetting admin password to 'admin'..."
psql -U postgres -d "$NEW_DB_NAME" -c \
"UPDATE res_users SET login = 'admin', password='admin', active=True WHERE id = 2;"

echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "✅ Database '$NEW_DB_NAME' restored successfully with admin/admin login."
