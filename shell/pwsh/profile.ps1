################################################################################
#                               POWERSHELL PROFILE                             #
#                      ~/.dotfiles/shell/pwsh/profile.ps1                      #
################################################################################

################################################################################
#                            ENVIRONMENT VARIABLES                             #
################################################################################

function Ensure-EnvVariable {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Value,

        [ValidateSet("User", "Machine")]
        [string]$Scope = "User"
    )

    $existingValue = [Environment]::GetEnvironmentVariable($Name, $Scope)

    if ($null -ne $existingValue && $existingValue -eq $Value) {
        return
    }

    [Environment]::SetEnvironmentVariable($Name, $Value, $Scope)
    Set-Content -Path "Env:\$Name" -Value $Value

    Write-Host "Successfully set $Scope environment variable: $Name" -ForegroundColor Green
}

$xdgVars = @{
    "XDG_CONFIG_HOME" = Join-Path $env:USERPROFILE ".config"
    "XDG_DATA_HOME"   = Join-Path $env:USERPROFILE ".local" "share"
    "XDG_STATE_HOME"  = Join-Path $env:USERPROFILE ".local" "state"
    "XDG_CACHE_HOME"  = Join-Path $env:USERPROFILE ".cache"
    "XDG_BIN_HOME"    = Join-Path $env:USERPROFILE ".local" "bin"
}

foreach ($ev in $xdgVars.GetEnumerator()) {
    Ensure-EnvVariable -Name $ev.Key -Value $ev.Value
}

$env:RIPGREP_CONFIG_PATH = Join-Path $HOME ".config\ripgrep\.ripgreprc"

################################################################################
#                          PSREADLINE CONFIGURATION                            #
################################################################################

if (Get-Module -ListAvailable -Name PSReadLine) {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd

    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

################################################################################
#                           ALIASES AND FUNCTIONS                              #
################################################################################

if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias -Name vim -Value nvim
}

if (Get-Command eza -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    function ls { eza @args }
    function ll { eza -lagh @args }
}

################################################################################
#                            TOOL INTEGRATIONS                                 #
################################################################################

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

################################################################################
#                          PROMPT CONFIGURATION                                #
################################################################################

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

################################################################################
#                        MACHINE-SPECIFIC OVERRIDES                            #
################################################################################

$localProfile = Join-Path -Path $PSScriptRoot -ChildPath "profile.local.ps1"
if (Test-Path $localProfile) {
    . $localProfile
}
