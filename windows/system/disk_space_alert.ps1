# Example usage:
# .\disk_space_alert.ps1 -smtp_user "novy.user@gmail.com" -smtp_pass "hqmk wzgz bshb hhoa" -email_from "novy.user@gmail.com" -company "IPG" -threshold 75
# Only the parameters you specify are overridden; all others use their default values.

param(
    [string]$drive = "C",
    [int]$threshold = 80, # size limit for alert
    [switch]$log = $true,
    [string]$log_file = "disk_alert.log",
    [string]$smtp_server = "smtp.gmail.com",
    [int]$smtp_port = 587,
    [string]$smtp_user = "testuserlogin2025@gmail.com",
    [string]$smtp_pass = "hqmk wzgz bshb hhoa", # App Password required if its gmail.com
    [string]$email_to = "johndoe@gmail.com",
    [string]$email_from = "testuserlogin2025@gmail.com",
    [string]$company = "IPG"
)

function now { (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }

# --- Optional config ---
$use_custom = Read-Host "Do you want to modify configuration? (y/N)"
if ($use_custom -eq "y" -or $use_custom -eq "Y") {
    $cfg_drive = Read-Host "Drive to monitor [$drive]"
    if ($cfg_drive) { $drive = $cfg_drive }

    $cfg_threshold = Read-Host "Threshold percent [$threshold]"
    if ($cfg_threshold) { $threshold = [int]$cfg_threshold }

    if ($log) {
        $cfg_log_file = Read-Host "Log file [$log_file]"
        if ($cfg_log_file) { $log_file = $cfg_log_file }
    }

    $cfg_company = Read-Host "Company name [$company]"
    if ($cfg_company) { $company = $cfg_company }
}

# --- Start log ---
$line = "[{0}] Disk Space Alert started for $drive (threshold: $threshold%)" -f (now)
Write-Host $line
if ($log) { Add-Content $log_file $line }

# --- Check disk space using WMI ---
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='${drive}:'" 

if ($null -eq $disk) {
    Write-Host "[$(now)] ERROR: Drive $drive not found!"
    if ($log) { Add-Content $log_file "[$(now)] ERROR: Drive $drive not found!" }
    exit
}

$used_percent = [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size * 100), 2)

if ($used_percent -ge $threshold) {
    $msg = "WARNING: $drive usage is $used_percent% (>= $threshold%)"

    # --- Send email alert with company name ---
    $email_body = "Disk space alert for company: $company`nDrive: $drive`nUsage: $used_percent% (Threshold: $threshold%)"
    try {
        $securePass = ConvertTo-SecureString $smtp_pass -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($smtp_user, $securePass)
        Send-MailMessage -From $email_from -To $email_to -Subject "Disk Alert $drive - $company" -Body $email_body -SmtpServer $smtp_server -Port $smtp_port -Credential $cred -UseSsl
    } catch {
        Write-Host "[$(now)] ERROR: Failed to send email. $_"
        if ($log) { Add-Content $log_file "[$(now)] ERROR: Failed to send email. $_" }
    }
} else {
    $msg = "$drive usage is $used_percent% (below threshold)"
}

Write-Host "[$(now)] $msg"
if ($log) { Add-Content $log_file "[$(now)] $msg" }

# --- End log ---
$line = "[{0}] Disk Space Alert finished for $drive" -f (now)
Write-Host $line
if ($log) { Add-Content $log_file $line }
