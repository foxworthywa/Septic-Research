<#
build-deliverables.ps1 — Windows/PowerShell equivalent of build-deliverables.sh

Rebuilds every .docx and the .zip in deliverables\ from the markdown sources.
Those files are SNAPSHOTS: editing a source does not update them.

    .\tools\build-deliverables.ps1            rebuild everything
    .\tools\build-deliverables.ps1 -Check     report staleness, change nothing

Requires pandoc. Install once with:
    winget install --id JohnMacFarlane.Pandoc

(No PDF engine is needed — DOCX output is pure pandoc.)

Note: the .build-manifest hashes raw file bytes. If the repo is checked out
with CRLF line endings on Windows but LF elsewhere, a manifest written on one
platform will read as stale on the other. Rebuild once per platform if you
switch; it is harmless.
#>

[CmdletBinding()]
param([switch]$Check)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $RepoRoot

$Out      = 'deliverables'
$ZipName  = 'ESVA_Septic_Project_Deliverables.zip'
$Manifest = Join-Path $Out '.build-manifest'

# Explicit documents, then everything under outreach\ and research\
$Sources = @(
    'ECOLOGICAL_EFFECTS_SYNTHESIS.md',
    'ECOLOGICAL_BIBLIOGRAPHY.md',
    'ECOLOGICAL_RESEARCH_STRATEGY.md',
    'poster\POSTER_CONTENT_AND_LAYOUT.md'
)
foreach ($dir in 'outreach','research') {
    if (Test-Path $dir) {
        $Sources += Get-ChildItem -Path $dir -Filter *.md |
                    ForEach-Object { Join-Path $dir $_.Name }
    }
}
$Assets = @('poster\ESVA_Symposium_Poster.html')
$All    = $Sources + $Assets

function Get-Hash([string]$Path) {
    (Get-FileHash -Path $Path -Algorithm SHA256).Hash.ToLower()
}

# Manifest paths are stored with forward slashes so bash and PowerShell agree.
function To-Posix([string]$Path) { $Path -replace '\\','/' }

# ------------------------------------------------------------------ -Check ---
if ($Check) {
    if (-not (Test-Path $Manifest)) {
        Write-Host "STALE: no build manifest — deliverables\ predates this script." -ForegroundColor Red
        Write-Host "Run: .\tools\build-deliverables.ps1"
        exit 1
    }
    $recorded = @{}
    foreach ($line in Get-Content $Manifest) {
        if ($line -match '^(\S+)\s+(.+)$') { $recorded[$Matches[2]] = $Matches[1] }
    }

    $drift = $false
    foreach ($f in $All) {
        if (-not (Test-Path $f)) { continue }
        $key = To-Posix $f
        $cur = Get-Hash $f
        if (-not $recorded.ContainsKey($key)) {
            Write-Host "  + $f  (new — not yet in the package)"; $drift = $true
        } elseif ($recorded[$key] -ne $cur) {
            Write-Host "  ~ $f  (changed since last build)"; $drift = $true
        }
    }
    foreach ($key in $recorded.Keys) {
        if (-not (Test-Path ($key -replace '/','\'))) {
            Write-Host "  - $key  (source removed)"; $drift = $true
        }
    }

    if ($drift) {
        Write-Host ""
        Write-Host "STALE: deliverables\ does not match the current sources." -ForegroundColor Red
        Write-Host "Run: .\tools\build-deliverables.ps1"
        exit 1
    }
    Write-Host "Deliverables are up to date." -ForegroundColor Green
    exit 0
}

# ------------------------------------------------------------------- build ---
if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Write-Host "pandoc not found." -ForegroundColor Red
    Write-Host "Install with:  winget install --id JohnMacFarlane.Pandoc"
    exit 1
}

New-Item -ItemType Directory -Force -Path $Out | Out-Null

# Clear old artifacts so deleted sources don't linger in the package
Remove-Item "$Out\*.docx", "$Out\*.html", "$Out\$ZipName" -ErrorAction SilentlyContinue

$built = 0
foreach ($f in $Sources) {
    if (-not (Test-Path $f)) { Write-Host "  missing source: $f" -ForegroundColor Red; continue }
    $target = Join-Path $Out ((Get-Item $f).BaseName + '.docx')
    pandoc $f -o $target --from=markdown --to=docx
    "  {0,-46} -> {1}" -f $f, (Split-Path $target -Leaf) | Write-Host
    $built++
}
foreach ($a in $Assets) {
    if (-not (Test-Path $a)) { Write-Host "  missing asset: $a" -ForegroundColor Red; continue }
    Copy-Item $a $Out
    "  {0,-46} -> {1}" -f $a, (Split-Path $a -Leaf) | Write-Host
    $built++
}

# Write manifest (forward-slash paths, lowercase hashes — matches the bash script)
$lines = foreach ($f in $All) {
    if (Test-Path $f) { "{0}  {1}" -f (Get-Hash $f), (To-Posix $f) }
}
Set-Content -Path $Manifest -Value $lines -Encoding ascii

Compress-Archive -Path "$Out\*.docx", "$Out\*.html" -DestinationPath "$Out\$ZipName" -Force

Write-Host ""
Write-Host "Built $built documents into $Out\" -ForegroundColor Green
Write-Host "Package: $Out\$ZipName" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Commit the result so the package on the remote matches the sources:" -ForegroundColor DarkGray
Write-Host "  git add $Out; git commit -m 'Rebuild deliverables'; git push" -ForegroundColor DarkGray
