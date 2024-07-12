# Install cargo if it is not already installed
if (!(Get-Command -ErrorAction SilentlyContinue cargo)) {
    Write-Host "Installing cargo"
    Invoke-WebRequest -Uri https://win.rustup.rs -OutFile rustup-init.exe
    ./rustup-init.exe --no-update-default-toolchain --no-modify-path -y
    $env:PATH += ";$env:USERPROFILE\.cargo\bin"
    Remove-Item rustup-init.exe
} else {
    Write-Host "Updating cargo"
    rustup self update
    rustup update
}

function Install-CargoCommand {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = "Command used to check if the command is already installed"
        )]
        [string] $Command,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = "Name of crate used to install the command"
        )]
        [string] $Crate
    )
    
    process {
        if (!(Get-Command -ErrorAction SilentlyContinue $Command)) {
            Write-Host "Installing $Command"
            cargo install $Crate
        }
    }
}

# Install cargo commands
Install-CargoCommand -Command cargo-install-update -Crate cargo-update
Install-CargoCommand -Command dotter -Crate dotter
Install-CargoCommand -Command fd -Crate fd-find
Install-CargoCommand -Command just -Crate just
Install-CargoCommand -Command lsd -Crate lsd
Install-CargoCommand -Command rg -Crate ripgrep

# Update any existing cargo commands (mainly useful for updates)
#cargo install-update -a
