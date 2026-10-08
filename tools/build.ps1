[CmdletBinding()]
param(
    [string]$ToolsPath = $env:ARMA3_TOOLS,
    [string]$ArmaPath = $env:ARMA3_PATH,
    [string]$OutputDirectory,
    [switch]$RebuildIcons
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot

if (-not $ToolsPath) {
    $steamRoot = (Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
    if (-not $steamRoot) {
        $steamRoot = Join-Path ${env:ProgramFiles(x86)} 'Steam'
    }
    $libraries = @($steamRoot)
    $libraryFile = Join-Path $steamRoot 'steamapps\libraryfolders.vdf'
    if (Test-Path -LiteralPath $libraryFile) {
        $libraries += [regex]::Matches((Get-Content -LiteralPath $libraryFile -Raw), '"path"\s+"([^"]+)"') |
            ForEach-Object { $_.Groups[1].Value.Replace('\\', '\') }
    }
    foreach ($library in ($libraries | Select-Object -Unique)) {
        $candidate = Join-Path $library 'steamapps\common\Arma 3 Tools'
        if (Test-Path -LiteralPath (Join-Path $candidate 'AddonBuilder\AddonBuilder.exe')) {
            $ToolsPath = $candidate
            break
        }
    }
}
if (-not $ToolsPath) {
    throw 'Arma 3 Tools was not found. Pass -ToolsPath or set ARMA3_TOOLS.'
}
$ToolsPath = (Resolve-Path -LiteralPath $ToolsPath).Path
$builder = Join-Path $ToolsPath 'AddonBuilder\AddonBuilder.exe'
$converter = Join-Path $ToolsPath 'CfgConvert\CfgConvert.exe'
foreach ($tool in @($builder, $converter)) {
    if (-not (Test-Path -LiteralPath $tool)) { throw "Missing tool: $tool" }
}

if ($RebuildIcons) {
    & npm.cmd --prefix $PSScriptRoot ci --ignore-scripts --no-audit --no-fund
    if ($LASTEXITCODE -ne 0) { throw 'Artwork dependencies could not be installed.' }
    & node (Join-Path $PSScriptRoot 'rebuild-icons.mjs') $ToolsPath
    if ($LASTEXITCODE -ne 0) { throw 'Artwork conversion failed.' }
}

if (-not $OutputDirectory) {
    if (-not $ArmaPath) {
        $ArmaPath = Join-Path (Split-Path -Parent $ToolsPath) 'Arma 3'
    }
    if (-not (Test-Path -LiteralPath (Join-Path $ArmaPath 'arma3_x64.exe'))) {
        throw 'Arma 3 was not found beside Arma 3 Tools. Pass -ArmaPath or -OutputDirectory.'
    }
    $OutputDirectory = Join-Path $ArmaPath 'Testing\@MarkersPlus'
}
$OutputDirectory = [IO.Path]::GetFullPath($OutputDirectory)
# A fresh staging directory prevents stale files and keeps artwork/tools out of the PBO.
$runRoot = Join-Path $repoRoot ('.build\pack-' + [guid]::NewGuid().ToString('N'))
$destination = Join-Path $OutputDirectory 'addons'
New-Item -ItemType Directory -Force -Path $destination | Out-Null
foreach ($addonName in @('MarkersPlus','MarkersPlus_UI')) {
    $addonSource = Join-Path $repoRoot "addons\$addonName"
    $prefix = [IO.File]::ReadAllText((Join-Path $addonSource '$PBOPREFIX$'))
    $expectedPrefix = if ($addonName -eq 'MarkersPlus') { 'markersplus' } else { 'markersplus_ui' }
    if ($prefix -ne $expectedPrefix) { throw "Unexpected addon prefix for $addonName." }
    $staging = Join-Path $runRoot $addonName
    New-Item -ItemType Directory -Force -Path $staging | Out-Null
    Get-ChildItem -LiteralPath $addonSource -Force | Where-Object Name -ne '$PBOPREFIX$' |
        Copy-Item -Destination $staging -Recurse
    & $converter -test (Join-Path $staging 'config.cpp')
    if ($LASTEXITCODE -ne 0) { throw "Config validation failed for $addonName." }
    & $builder $staging $destination "-prefix=$prefix" "-toolsDirectory=$ToolsPath" "-temp=$runRoot\temp" "-include=$PSScriptRoot\include.txt"
    if ($LASTEXITCODE -ne 0) { throw "Addon Builder failed for $addonName." }
    $pbo = Join-Path $destination "$addonName.pbo"
    if (-not (Test-Path -LiteralPath $pbo)) { throw "Addon Builder did not produce $addonName.pbo." }
    Write-Output "Built $pbo"
}
Copy-Item -LiteralPath (Join-Path $repoRoot 'mod.cpp') -Destination $OutputDirectory
Copy-Item -LiteralPath (Join-Path $repoRoot 'README.md') -Destination $OutputDirectory
