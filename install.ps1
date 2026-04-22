[CmdletBinding()]
param(
    [ValidateSet("copy", "link")]
    [string]$Mode = "copy",
    [string]$TargetRoot,
    [string]$Skill
)

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    return $PSScriptRoot
}

function Get-DefaultTargetRoot {
    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        return Join-Path $env:CODEX_HOME "skills"
    }

    return Join-Path $HOME ".codex\skills"
}

function Get-SkillDirectories {
    param(
        [string]$RepoRoot,
        [string]$FilterName
    )

    $dirs = Get-ChildItem -LiteralPath $RepoRoot -Directory | Where-Object {
        Test-Path (Join-Path $_.FullName "SKILL.md")
    }

    if (-not [string]::IsNullOrWhiteSpace($FilterName)) {
        $dirs = $dirs | Where-Object { $_.Name -eq $FilterName }
    }

    return @($dirs)
}

function Copy-SkillDirectory {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    Get-ChildItem -LiteralPath $SourcePath -Force | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $DestinationPath -Recurse -Force
    }
}

$repoRoot = Get-RepoRoot
$skillDirs = Get-SkillDirectories -RepoRoot $repoRoot -FilterName $Skill

if ($skillDirs.Count -eq 0) {
    if ([string]::IsNullOrWhiteSpace($Skill)) {
        throw "未找到可安装的 skill 目录。"
    }

    throw "未找到名为 '$Skill' 的 skill。"
}

if ([string]::IsNullOrWhiteSpace($TargetRoot)) {
    $TargetRoot = Get-DefaultTargetRoot
}

New-Item -ItemType Directory -Path $TargetRoot -Force | Out-Null
$resolvedTargetRoot = (Resolve-Path -LiteralPath $TargetRoot).Path

$installed = @()

foreach ($skillDir in $skillDirs) {
    $destination = Join-Path $resolvedTargetRoot $skillDir.Name

    if (Test-Path -LiteralPath $destination) {
        Remove-Item -LiteralPath $destination -Recurse -Force
    }

    if ($Mode -eq "link") {
        try {
            New-Item -ItemType SymbolicLink -Path $destination -Target $skillDir.FullName | Out-Null
        }
        catch {
            throw "创建符号链接失败。可改用 -Mode copy，或在系统中启用开发者模式。原始错误：$($_.Exception.Message)"
        }
    }
    else {
        Copy-SkillDirectory -SourcePath $skillDir.FullName -DestinationPath $destination
    }

    $installed += $destination
}

Write-Host "Installed $($installed.Count) skill(s) to: $resolvedTargetRoot"
$installed | ForEach-Object { Write-Host " - $_" }
