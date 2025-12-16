param(
  [Parameter(Mandatory=$true)]
  [ValidateSet('up', 'down', 'restart', 'logs', 'ps', 'build')]
  [string]$Action
)

# Navigate to project root
$projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location $projectRoot

# Auto-detect all compose files
$composeFiles = @(
  Get-ChildItem -Path @('.', 'docker') -Filter "docker-compose*.yml" -Recurse -ErrorAction SilentlyContinue |
    ForEach-Object { $_.FullName.Replace("$projectRoot\", "").Replace("\", "/") }
)

if ($composeFiles.Count -eq 0) {
  Write-Host "No docker-compose files found" -ForegroundColor Red
  exit 1
}

# Build compose arguments
$composeArgs = $composeFiles | ForEach-Object { @('-f', $_) } | Write-Output

# Action to command mapping
$commands = @{
  'ps'      = @('ps')
  'down'    = @('down')
  'build'   = @('build')
  'restart' = @('restart')
  'up'      = @('up', '-d')
  'clean'   = @('down', '-v')
  'logs'    = @('logs', '-f')
}

# Execute
docker compose $composeArgs $commands[$Action]
