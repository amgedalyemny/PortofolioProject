# Run from the project root in Windows PowerShell. Never prints the secret.
$ErrorActionPreference = "Stop"
$line = Get-Content ".env" | Where-Object { $_ -match '^APP_API_TOKEN=' } | Select-Object -First 1
if (-not $line) { throw "APP_API_TOKEN missing from .env" }
$token = ($line -replace '^APP_API_TOKEN=', '').Trim()
if (-not $token) { throw "APP_API_TOKEN is empty" }
$headers = @{ "X-API-Token" = $token }
Write-Host "Checking Docker..."
docker compose ps
Write-Host "Checking /health..."
Invoke-RestMethod "http://localhost:8000/health" | Format-List
Write-Host "Checking authenticated /status..."
Invoke-RestMethod "http://localhost:8000/status" -Headers $headers | Format-List
Write-Host "If successful, enter the same APP_API_TOKEN value in the emulator."
