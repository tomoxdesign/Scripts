#!/usr/bin/env python3
import mysql.connector
from datetime import datetime

#  Function to get current timestamp 
def now():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

print(f"Start deletion: {now()}")

#  Database connection configuration 
db_config = {
    "host": "localhost",
    "user": "root",
    "password": "example_password123",
    "database": "MyDatabase"
}

conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

#  Batch deletion settings 
batch_size = 100000
deleted_rows = batch_size  # initialize to enter the loop
total_deleted = 0  # total number of deleted rows

#  Loop to delete data in batches 
while deleted_rows == batch_size:
    cursor.execute("""
        DELETE FROM device_input_digital
        WHERE DT >= '2025-06-01'
        ORDER BY DT
        LIMIT %s
    """, (batch_size,))
    
    deleted_rows = cursor.rowcount
    total_deleted += deleted_rows
    conn.commit()
    
    print(f"[{now()}] Deleted rows in this batch: {deleted_rows}, total deleted: {total_deleted}")

print(f"[{now()}] Deletion completed. Total rows deleted: {total_deleted}")

#  Close database connection 
cursor.close()
conn.close()
