# Local Environment Bootstrap Script
# Create Users, Folders, and Scheduled Tasks

# Define Users
$users = @(
    @{Username="Mwright"; FullName="Marcus Wright"; Role="User"},
    @{Username="Ljohnson"; FullName="Linda Johnson"; Role="User"},
    @{Username="Dphillips"; FullName="Deandre Phillips"; Role="User"},
    @{Username="Bstewart"; FullName="Brenda Stewart"; Role="Admin"},
    @{Username="Tgreen"; FullName="Tobias Green"; Role="Admin"}
)

# Create Users
foreach ($user in $users) {
    $securePass = ConvertTo-SecureString "P@ssword123" -AsPlainText -Force
    New-LocalUser -Name $user.Username -Password $securePass -FullName $user.FullName -Description $user.Role
    Add-LocalGroupMember -Group "Users" -Member $user.Username
    if ($user.Role -eq "Admin") {
        Add-LocalGroupMember -Group "Administrators" -Member $user.Username
    }
}

# Create folders and assign permissions
$basePath = "C:\CompanyData"
New-Item -Path $basePath -ItemType Directory -Force

$folders = @("Reports", "Monitoring", "Backups")

foreach ($folder in $folders) {
    $path = Join-Path $basePath $folder
    New-Item -Path $path -ItemType Directory -Force

    switch ($folder) {
        "Reports"     { icacls $path /grant "Users:(R,W)" }
        "Monitoring"  { icacls $path /grant "Administrators:(F)" }
        "Backups"     { icacls $path /grant "Administrators:(F)" }
    }
}

# Create scheduled task for backup
$backupScript = "C:\Scripts\Backup.ps1"
New-Item -Path $backupScript -ItemType File -Force
Set-Content -Path $backupScript -Value '# Placeholder for backup logic'

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"$backupScript`""
$trigger = New-ScheduledTaskTrigger -Daily -At 3am
Register-ScheduledTask -TaskName "DailyBackup" -Action $action -Trigger $trigger -User "Bstewart" -Password "P@ssword123"
Register-ScheduledTask -TaskName "DailyBackup" -Action $action -Trigger $trigger -User "Tgreen" -Password "P@ssword123"

Write-Host "Environment setup complete."
Read-Host -Prompt "Press Enter to exit"


  
  

    
