$ErrorActionPreference = "Stop"

$repoPath = "$env:USERPROFILE\daily-log"
$logFile  = Join-Path $repoPath "STREAK.md"
$today    = Get-Date -Format "yyyy-MM-dd"
$stamp    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

function Log($msg) {
    Write-Output "[$stamp] $msg"
}

try {
    Set-Location $repoPath

    git pull --quiet origin main 2>&1 | Out-Null

    $alreadyLogged = $false
    if (Test-Path $logFile) {
        $alreadyLogged = [bool](Select-String -Path $logFile -Pattern "^- $today\b" -Quiet)
    }

    if ($alreadyLogged) {
        Log "$today already logged, skipping."
        exit 0
    }

    Add-Content -Path $logFile -Value "- $today"

    git add STREAK.md
    git commit -m "Update: $today" --quiet
    git push --quiet origin main

    Log "$today committed and pushed."
}
catch {
    Log "ERROR: $($_.Exception.Message)"
    exit 1
}
