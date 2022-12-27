#Initalization script
# 1st lets check that WSL is installed and enabled. 
Write-warning "Checking if WSL feature is installed..."
$i = 0
$installed = $false
while ($i -lt 30) {
  $i +=1  
  $installed = (Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online).State -eq 'Enabled'
  if ($installed) {
    Write-host "WSL feature is installed"
    break
  }
  Write-warning "Retrying in 10 seconds..."
  sleep 10;
}
# install it if not already installed. as we should
if (-not $installed) {
    Write-error "WSL feature is not installed- Going to install"
    Write-host "Enabling WSL - no restart"
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    Write-host "Enable VMPlatform"
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    Write-warning " Your machine needs to restart"
    sleep 5 
    $wshell = New-Object -ComObject Wscript.Shell
    $Output = $wshell.Popup("Your machine needs to reboot!")
    Restart-Computer -Confirm 
}

Write-host "Continuing with build"
# Setting WSL2 as the default WSL
wsl --set-default-version 2
sleep 5
#import and run builder
Write-warning "Importing builder and running build"
wsl --import builder .\builderInstall .\resources\builder\alpine-builder.tar.gz --version 2
wsl -d builder -u root sh -c "resources/builder/build-container.sh %USERNAME%"
sleep 5
# import newly built image
Write-host "Importing new image"
wsl --import dev-env c:\wsl .\output\dev-env.tar.gz
wsl --set-default dev-env
sleep 10

#Cleanup time
Write-warning "Cleaning up"
echo Begginging Cleanup
wsl --unregister builder
rmdir .\builderInstall
sleep 10
exit