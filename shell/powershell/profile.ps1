# PowerShell Profile
# Slim entrypoint — sources all profile.d/*.ps1 drop-ins in order,
# then applies machine-specific overrides from profile.local.ps1.

# Source all profile.d drop-ins in order
$profileDir = Join-Path (Split-Path -Parent $PROFILE.CurrentUserAllHosts) "profile.d"
if (Test-Path $profileDir) {
    Get-ChildItem -Path $profileDir -Filter "*.ps1" | Sort-Object Name | ForEach-Object {
        . $_.FullName
    }
}

# Machine-specific overrides
$localProfile = Join-Path (Split-Path -Parent $PROFILE.CurrentUserAllHosts) "profile.local.ps1"
if (Test-Path $localProfile) {
    . $localProfile
}
