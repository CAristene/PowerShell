# Local Environment Bootstrap Script
# Creates Users, Folders, and Scheduled Tasks

# Define Users
$users = @(
    @{Username="Mwright"; FullName="Marcus Wright"; Role="User"},
    @{Username="Ljohnson"; FullName="Linda Johnson"; Role="User"},
    @{Username="Dphillips"; FullName="Deandre Phillips"; Role="User"},
    @{Username="Bstewart"; FullName="Brenda Stewart"; Role="Admin"},
    @{Username="Tgreen"; FullName="Tobias Green"; Role="Admin"}
)

# Create Users and Assign Groups
foreach ($user in $users) {
    $securePass = ConvertTo-SecureString "P@ssword123" -AsPlainText -Force
    New-LocalUser -Name $user.Username -Password $securePass -FullName $user.FullName -Description $user.Role
    Add-LocalGroupMember -Group "Users" -Member $user.Username
    if ($user.Role -eq "Admin") {
        Add-LocalGroupMember -Group "Administrators" -Member $user.Username
    }
}

# Create Base Folder and Subfolders
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

# Create Backup Script
$backupScript = "C:\Scripts\Backup.ps1"
New-Item -Path $backupScript -ItemType File -Force
Set-Content -Path $backupScript -Value '# Placeholder for backup logic'

# Register Scheduled Tasks for Admin Users
$adminUsers = @("Bstewart", "Tgreen")

foreach ($admin in $adminUsers) {
    $taskName = "DailyBackup_$admin"
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"$backupScript`""
    $trigger = New-ScheduledTaskTrigger -Daily -At 3am

    # Remove existing task if present
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-Host "Old task '$taskName' removed."
    }

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -User $admin -Password "P@ssword123"
    Write-Host "Scheduled task '$taskName' registered for $admin."
}

Write-Host "`n✅ Environment setup complete."
Read-Host -Prompt "Press Enter to exit"



  
  

    
