# Set PowerShell encoding to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Find out if the current user identity is elevated (has admin rights)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Remove-Variable @("identity", "principal")

# Prompt setup
function prompt {
  if ($isAdmin) {
    "[" + (Get-Location) + "] # "
  } else {
    "" + (Get-Location) + " $ "
  }
}

# Set window title
if ($isAdmin) {
  $Host.UI.RawUI.WindowTitle += " [ADMIN]"
}

# Setup OhMyPosh
oh-my-posh --init --shell pwsh --config "$env:POSH_THEMES_PATH/probua.minimal.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons

# Environment Variables
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"
$env:XDG_CONFIG_HOME = "$env:USERPROFILE\.config"
#$env:XDG_DATA_HOME = "$env:USERPROFILE"

# Functions
function ll { Get-ChildItem -Path $pwd -File }
function which ($name) { Get-Command $name | Select-Object -ExpandProperty Definition }
function touch ($file) { "" | Out-File $file -Encoding UTF-8 }
function tail ($file, $lines) {
  $_lines = 10 || $lines
  Get-Content -Path $file -Tail $_lines -Wait 
}
function pgrep($name) { Get-Process $name }
function pkill($name) { Get-Process $name --ErrorAction SilentlyContinue | Stop-Process }
function reload-profile { . $profile }
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

function grep($regex, $dir) {
  if ( $dir ) {
    Get-ChildItem $dir | select-string $regex
    return
  }
  $input | select-string $regex
}
function unzip ($file) {
  Write-Output("Extracting", $file, "to", $pwd)
  $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
  Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function find-file($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${_}"
    }
}
function uptime() { Get-Uptime }
function Projects { Set-Location -Path C:\prj }
function edit-profile { notepad $env:USERPROFILE\.config\powershell\user_profile.ps1 }
function edit-history { notepad (Get-PSReadlineOption).HistorySavePath }

# Alias
# Set Alias
Set-Alias ls dir
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias wget Invoke-WebRequest
Set-Alias grep findstr

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContiue |
   Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
