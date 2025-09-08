# This script automates local user creation and task assignment
# Local environment Bootsrap Script
# Create Users, Folders, and Scheduled Tasks

# Define Users
$users = @(                                                                                                                                                      
    @{Username="Mwright"; FullName="Marcus Wright"; Role="User"},
    @{Username="Ljohnson"; FullName="Linda Johnson"; Role="User"},
    @{Username="Dphillips"; FullName="Deandre Phillips"; Role="User"}
    @{Username="Bstewart"; Fullname="Brenda Stewart"; Role="Admin"}
    @{Username="Tgreen"; FullName="Tobias Green"; Role="Admin"}
    )
    # Create Users
    foreach ($user in $users) {
        $securePass = ConvertTo-SecureString "P@ssword123" -AsPlainText -Force
        New-LocalUser -Name $user.Username -Password $securepass -FullName $User.FullName -Description $user.role
        Add-LocalGroupMember -Group "Users" -Member $user.Username
        if ($user.role -eq "admin") {
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
  $backupscript = "C:/Scripts/Backup.ps1"
  New-Item -Path $backupscript -ItemType File -Force
  Set-Content -Path $backupscript -Value '# Placeholder for backup logic'
  $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File $backupscript"
  $trigger = New-ScheduledTaskTrigger -Daily -At 3am
  Register -ScheduledTask -Taskname "DailyBackup" -Action $action -Trigger $trigger -User "asmith" -Password "P@ssword123"

  Write-Host "Environment setup complete."
  
  

    
