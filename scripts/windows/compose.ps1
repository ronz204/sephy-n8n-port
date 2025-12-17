param(
  [Parameter(Mandatory=$true)]
  [ValidateSet('up', 'down', 'restart', 'logs', 'ps', 'build', 'clean')]
  [string]$Action
)

# Navigate to project root
$projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $projectRoot

# Load context.json
$context = Get-Content "context.json" | ConvertFrom-Json

# Get active clients only
$activeClients = $context.clients.PSObject.Properties.Value | Where-Object { $_.active -eq $true }

# Build compose file list
$composeFiles = @('docker-compose.yml')
$composeFiles += $activeClients | ForEach-Object { "docker/$($_.compose)" }

# Build compose arguments
$composeArgs = $composeFiles | ForEach-Object { @('-f', $_) } | Write-Output

# Action to command mapping
$commands = @{
  'up'      = @('up', '-d')
  'down'    = @('down')
  'restart' = @('restart')
  'logs'    = @('logs', '-f')
  'ps'      = @('ps')
  'build'   = @('build')
  'clean'   = @('down', '-v')
}

# Execute
docker compose $composeArgs $commands[$Action]
