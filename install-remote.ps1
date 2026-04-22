[CmdletBinding()]
param(
    [string]$Repo = $(if (-not [string]::IsNullOrWhiteSpace($env:SUMMARY_SKILLS_REPO)) { $env:SUMMARY_SKILLS_REPO } else { "CountClaw/summary-skills" }),
    [string]$Ref = $(if (-not [string]::IsNullOrWhiteSpace($env:SUMMARY_SKILLS_REF)) { $env:SUMMARY_SKILLS_REF } else { "master" }),
    [string]$TargetRoot = $env:SUMMARY_SKILLS_TARGET_ROOT,
    [string]$Skill = $env:SUMMARY_SKILLS_SKILL
)

$ErrorActionPreference = "Stop"

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("summary-skills-remote-" + [System.Guid]::NewGuid().ToString("N"))
$archivePath = Join-Path $tempRoot "repo.zip"
$extractRoot = Join-Path $tempRoot "extract"

try {
    New-Item -ItemType Directory -Path $extractRoot -Force | Out-Null

    $archiveUrl = "https://github.com/$Repo/archive/refs/heads/$Ref.zip"
    Write-Host "Downloading: $archiveUrl"
    Invoke-WebRequest -Uri $archiveUrl -OutFile $archivePath

    Expand-Archive -LiteralPath $archivePath -DestinationPath $extractRoot -Force

    $repoDir = Get-ChildItem -LiteralPath $extractRoot -Directory | Select-Object -First 1
    if ($null -eq $repoDir) {
        throw "解压后未找到仓库目录。"
    }

    $installScript = Join-Path $repoDir.FullName "install.ps1"
    if (-not (Test-Path -LiteralPath $installScript)) {
        throw "未找到 install.ps1。"
    }

    $arguments = @{
        Mode = "copy"
    }
    if (-not [string]::IsNullOrWhiteSpace($TargetRoot)) {
        $arguments.TargetRoot = $TargetRoot
    }
    if (-not [string]::IsNullOrWhiteSpace($Skill)) {
        $arguments.Skill = $Skill
    }

    Write-Host "Running installer from: $($repoDir.FullName)"
    & $installScript @arguments
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}
