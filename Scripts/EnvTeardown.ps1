Local Environment Cleanup Script

# Environment Teardown Script
Write-Host "'n Starting teardown of environment..."

# Define users and folders
$users = @("Mwright, "Ljohnson", "Dphillips", "Bstewart", "Tgreen")
$basePath = "C:\CompanyData"
$folders = @("Reports", "Monitoring", "Backups")
$backupScript = "C:\Scripts\Backup.ps1"
$taskName = "DailyBackup"

# Remove scheduled task
try {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
    Write-Host "Scheduled task 'taskName' removed."
} catch {
    Write-Warning " Scheduled Task 'taskName' not found or could not be removed. "

# Remove backup script
if (Test-path $backupScrupt) {
    Remove-Item $backupScript -Force
    Write-Host "Backup script removed."
} else {
    Write-Warning "Backup script not found. "
}

#Remove folders
foreach ($folder in $folders) {
    $path = Join-Path $basePath $folder
    if (Test-Path $path) {
        Remove-Item -Path $basePath -Recurse -Force
        Write-Host "Base folder removed"
}
# Remove users
foreach ($user in $users) {
    try {
        Remove-LocalUser -Name $user -ErrorAction Stop
        Write-Host "User 'user removed."
    } catch {
        Write-Warning " User "$user' not found or could not removed."
    }
}
Write-Host "'n Environment teardown complete." 
