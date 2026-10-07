$envFile = ".env"
$backup = "backup\espocrm_backup.sql"

$rootPassword = (Get-Content $envFile |
    Where-Object { $_ -match "^MARIADB_ROOT_PASSWORD=" } |
    ForEach-Object { $_.Split("=", 2)[1] })

Write-Host "Waiting for MariaDB..."

do {
    Start-Sleep -Seconds 3
    docker exec espocrm-db mariadb-admin ping -u root -p"$rootPassword" --silent 2>$null
} until ($LASTEXITCODE -eq 0)

Write-Host "MariaDB is ready."

Get-Content $backup | docker exec -i espocrm-db mariadb -u root -p"$rootPassword" espocrm

Write-Host "CRM database restored successfully."