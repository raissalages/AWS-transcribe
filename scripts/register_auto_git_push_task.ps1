# Registers a scheduled task to run the auto_git_push.ps1 script

$script = 'C:\Users\igorz\dev\speech-to-text\scripts\auto_git_push.ps1'
$taskName = 'AutoGitPush_Temp'

Write-Output "Registering scheduled task '$taskName' to run $script every 15 minutes for 5 hours (starting 1 minute from now)."

$tr = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 15) -RepetitionDuration (New-TimeSpan -Hours 5)
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$script`""

try {
    Register-ScheduledTask -TaskName $taskName -Trigger $tr -Action $action -Description 'Temporary auto git add/commit/push every 15 minutes for 5 hours' -Force
    Write-Output "Scheduled task registered. Use Get-ScheduledTask -TaskName $taskName to inspect."
    Get-ScheduledTask -TaskName $taskName | Format-List -Property *
}
catch {
    Write-Error "Failed to register scheduled task: $($_.Exception.Message)"
}
