#!/usr/bin/env python3
import os
import shutil
import smtplib
from email.message import EmailMessage
from datetime import datetime

# --- Default configuration ---
drive = "C"  # Disk to monitor
threshold = 80  # Percent usage to trigger alert
log_enabled = True
log_file = "disk_alert.log"
smtp_server = "smtp.gmail.com"
smtp_port = 587
smtp_user = "testuserlogin2025@gmail.com"
smtp_pass = "hqmk wzgz bshb hhoa"  # App Password required if using Gmail
email_to = "example@gmail.com"
email_from = "testuserlogin2025@gmail.com"
company = "IPG"

def now():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# --- Logging function ---
def log(msg):
    timestamped = f"[{now()}] {msg}"
    print(timestamped)
    if log_enabled:
        with open(log_file, "a") as f:
            f.write(timestamped + "\n")

# --- Determine disk path ---
disk_path = drive if os.name != "nt" else f"{drive}:/"

# --- Start monitoring ---
log(f"Disk Space Alert started for {disk_path} (threshold: {threshold}%)")

try:
    total, used, free = shutil.disk_usage(disk_path)
except FileNotFoundError:
    log(f"ERROR: Drive {disk_path} not found!")
    exit(1)

used_percent = round(used / total * 100, 2)

if used_percent >= threshold:
    msg = f"WARNING: {disk_path} usage is {used_percent}% (>= {threshold}%)"
    
    # --- Prepare and send email alert ---
    email_body = f"""DiskSpaceAlert - Disk {disk_path} for company {company} has exceeded the set threshold!

Disk: {disk_path}
Company: {company}
Usage: {used_percent}% (Threshold: {threshold}%)

Recommendation: Please check available disk space and free up capacity if needed.
"""
    try:
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()
            server.login(smtp_user, smtp_pass)
            email = EmailMessage()
            email["From"] = email_from
            email["To"] = email_to
            email["Subject"] = f"DiskSpaceAlert {disk_path} - {company}"
            email.set_content(email_body)
            server.send_message(email)
        log("Alert email sent successfully.")
    except Exception as e:
        log(f"ERROR: Failed to send email: {e}")
else:
    msg = f"{disk_path} usage is {used_percent}% (below threshold)"

log(msg)
log(f"Disk Space Alert finished for {disk_path}")
