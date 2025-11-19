Param()

# Auto git add/commit/push script
# - Run from Windows Task Scheduler every 15 minutes (or as configured)
# - Intended repo path: adjust $RepoPath if needed

$RepoPath = "C:\Users\igorz\dev\speech-to-text"
$LogFile = Join-Path $RepoPath "scripts\auto_git_push.log"

Function Log {
    param([string]$msg)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "[$ts] $msg"
    Add-Content -Path $LogFile -Value $entry -Encoding UTF8
}

Try {
    if (-not (Test-Path $RepoPath)) {
        Log "ERROR: Repo path not found: $RepoPath"
        exit 1
    }

    Set-Location -Path $RepoPath

    # Ensure git is present
    $git = Get-Command git -ErrorAction SilentlyContinue
    if (-not $git) {
        Log "ERROR: git not found in PATH"
        exit 1
    }

    # Check for any changes to commit
    $status = git status --porcelain
    if ([string]::IsNullOrWhiteSpace($status)) {
        Log "No changes to commit."
        exit 0
    }

    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git add -A

    # commit with timestamp
    git commit -m "Auto-commit at $now"

    # push to current tracked remote/branch
    $pushResult = git push 2>&1
    Log "Pushed changes. git push output: $($pushResult -join ' | ')"
}
Catch {
    Log "ERROR: $($_.Exception.Message)"
    exit 1
}
