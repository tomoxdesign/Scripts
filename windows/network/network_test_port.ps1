param(
    [string]$ip = "192.168.0.101",
    [int]$start_port = 1,
    [int]$end_port = 65535,
    [switch]$log,
    [string]$log_file = "ports.log"
)

function now { (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }

# --- Optional custom configuration ---
$use_custom_config = Read-Host "Do you want to use a modified configuration? (y/N)"
if ($use_custom_config -eq "y" -or $use_custom_config -eq "Y") {
    $cfg_ip = Read-Host "IP address [$ip]"
    if ($cfg_ip) { $ip = $cfg_ip }

    $cfg_start = Read-Host "Start port [$start_port]"
    if ($cfg_start) { $start_port = [int]$cfg_start }

    $cfg_end = Read-Host "End port [$end_port]"
    if ($cfg_end) { $end_port = [int]$cfg_end }

    if ($log) {
        $cfg_log_file = Read-Host "Log file [$log_file]"
        if ($cfg_log_file) { $log_file = $cfg_log_file }
    }
}

# --- Start log ---
$line = "[{0}] Port Scan started for $ip (ports $start_port-$end_port)" -f (now)
Write-Host $line
if ($log) { Add-Content $log_file $line }

$open_ports = @()
foreach ($port in $start_port..$end_port) {
    $tcp = New-Object System.Net.Sockets.TcpClient
    try {
        $tcp.Connect($ip, $port)
        $status = "open"
        $open_ports += $port
    } catch {
        $status = "closed"
    }
    $tcp.Close()

    $line = "[{0}] Port {1} is {2}" -f (now), $port, $status
    Write-Host $line
    if ($log) { Add-Content $log_file $line }
}

# --- Summary ---
$line = "[{0}] Open ports: {1}" -f (now), ($open_ports -join ", ")
Write-Host $line
if ($log) { Add-Content $log_file $line }

# --- End log ---
$line = "[{0}] Port Scan finished for $ip" -f (now)
Write-Host $line
if ($log) { Add-Content $log_file $line }
