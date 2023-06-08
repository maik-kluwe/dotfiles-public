# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

oh-my-posh --init --shell pwsh --config "$env:POSH_THEMES_PATH/probua.minimal.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Alias
Set-Alias ls dir
Set-Alias ll ls
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContiue |
   Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}