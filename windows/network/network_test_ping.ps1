# network_test_ping.ps1
param(
    [string]$base_ip = "192.168.1",
    [int]$start = 1,
    [int]$end = 20,
    [string]$log_file = "network_ping.log"
)

function now {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

# --- Input override ---
$input_ip = Read-Host "Base IP [$base_ip]"
if ($input_ip) { $base_ip = $input_ip }

$input_start = Read-Host "Start [$start]"
if ($input_start) { $start = [int]$input_start }

$input_end = Read-Host "End [$end]"
if ($input_end) { $end = [int]$input_end }

$input_log = Read-Host "Log file [$log_file]"
if ($input_log) { $log_file = $input_log }

# --- Start log ---
$time = now
$line = "[{0}] Network Ping Test started" -f $time
Write-Host $line
Add-Content $log_file $line

# --- Ping loop ---
foreach ($i in $start..$end) {
    $ip = "$base_ip.$i"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        $msg = "$ip is up"
    } else {
        $msg = "$ip is down"
    }
    $time = now
    $line = "[{0}] {1}" -f $time, $msg
    Write-Host $line
    Add-Content $log_file $line
}

# --- End log ---
$time = now
$line = "[{0}] Network Ping Test finished" -f $time
Write-Host $line
Add-Content $log_file $line
