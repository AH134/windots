#Requires -RunAsAdministrator

function Confirm($title, $question) {
  $choices = "&Yes", "&No"
  $choice = $Host.UI.PromptForChoice($title, $question, $choices, 1)

  return $choice -eq 0
}

function Make-Symlink($target, $link) {
  if (-not(Test-Path $target)) {
    New-Item $target -ItemType SymbolicLink -Value $link
    Write-Host "Created symlink at: $target."
    return
  }
  
  if (Test-Path -Path $link -PathType Container) {
    Write-Host "Symlink to directory exists at: $target. Skipping."
    return
  }
  
  if ((Get-FileHash $target).Hash -eq (Get-FileHash $link).Hash) {
    Write-Host "Symlink exists at: $target. Skipping."
    return
  } 

  $question = "Do you want to create a symlink at: $($target)? THIS WILL OVERWRITE THE EXISTING FILE!"
  
  if (-not(Confirm "[Symlink] -", $question)) {
    Write-Host "Skipping."
    return
  }

  New-Item $target -ItemType SymbolicLink -Value $link -Force
  Write-Host "Created symlink at: $target."
}

# setup environment variables for komorebi and wkhd
[Environment]::SetEnvironmentVariable("KOMOREBI_CONFIG_HOME", "$env:USERPROFILE\.config\komorebi", "User")
[Environment]::SetEnvironmentVariable("WKHD_CONFIG_HOME", "$env:USERPROFILE\.config\komorebi", "User")

$RepoRoot = Split-Path $PSScriptRoot -Parent
$ConfigPath = Join-Path $RepoRoot "windows\.config\komorebi"

Make-Symlink "$env:USERPROFILE\.config\komorebi" $ConfigPath
