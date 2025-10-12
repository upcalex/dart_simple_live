param(
  [string]$projectDir = ".\simple_live_app"
)

Write-Host "Building Flutter Windows release for project: $projectDir"

# Resolve project path
$projectPath = Resolve-Path $projectDir
Write-Host "Project path: $projectPath"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Error "flutter not found in PATH. Install Flutter and add to PATH."
  exit 1
}

# Check Visual Studio presence (vswhere helps detect installed workloads)
$vswhere = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path $vswhere)) {
  Write-Warning "vswhere not found. Visual Studio may not be installed. Windows build requires Visual Studio with 'Desktop development with C++' workload."
} else {
  & $vswhere -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath -latest | Out-Null
  if ($LASTEXITCODE -ne 0) { Write-Warning "Visual Studio with C++ workload not detected. Installing 'Desktop development with C++' is required." }
}

# Check Developer Mode for symlink support
try {
  $devMode = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction Stop).AllowDevelopmentWithoutDevLicense
} catch {
  $devMode = $null
}
if ($devMode -ne 1) {
  Write-Warning "Developer Mode not enabled. Open Settings -> Update & Security -> For developers and enable Developer Mode to allow symlinks."
}

Push-Location $projectPath

Write-Host "Running flutter pub get..."
flutter pub get
if ($LASTEXITCODE -ne 0) { Write-Error "flutter pub get failed"; Pop-Location; exit 1 }

Write-Host "Enabling Windows desktop support (if not already)..."
flutter config --enable-windows-desktop

Write-Host "Starting flutter build windows --release"
flutter build windows --release
if ($LASTEXITCODE -ne 0) { Write-Error "flutter build windows failed"; Pop-Location; exit 1 }

# Copy artifacts
$releaseDir = Join-Path $projectPath "build\windows\runner\Release"
$outDir = Join-Path $projectPath "build_artifacts\windows"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
Write-Host "Copying release artifacts from $releaseDir to $outDir"
Copy-Item -Path (Join-Path $releaseDir "*") -Destination $outDir -Recurse -Force
Write-Host "Windows release artifacts copied to $outDir"

Pop-Location

Write-Host "Done."
