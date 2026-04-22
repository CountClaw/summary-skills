[CmdletBinding()]
param(
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

function Get-SkillNames {
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

    return @($dirs | ForEach-Object { $_.Name })
}

$repoRoot = Get-RepoRoot
$skillNames = Get-SkillNames -RepoRoot $repoRoot -FilterName $Skill

if ($skillNames.Count -eq 0) {
    if ([string]::IsNullOrWhiteSpace($Skill)) {
        throw "未找到可卸载的 skill 定义。"
    }

    throw "未找到名为 '$Skill' 的 skill 定义。"
}

if ([string]::IsNullOrWhiteSpace($TargetRoot)) {
    $TargetRoot = Get-DefaultTargetRoot
}

if (-not (Test-Path -LiteralPath $TargetRoot)) {
    Write-Host "目标目录不存在，无需卸载: $TargetRoot"
    exit 0
}

$resolvedTargetRoot = (Resolve-Path -LiteralPath $TargetRoot).Path
$removed = @()

foreach ($skillName in $skillNames) {
    $destination = Join-Path $resolvedTargetRoot $skillName

    if (Test-Path -LiteralPath $destination) {
        Remove-Item -LiteralPath $destination -Recurse -Force
        $removed += $destination
    }
}

Write-Host "Removed $($removed.Count) skill(s) from: $resolvedTargetRoot"
$removed | ForEach-Object { Write-Host " - $_" }
