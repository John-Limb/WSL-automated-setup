@echo on
rem [32m Remove the distro from WSL [0m
wsl --unregister dev-env
timeout 5
rem [32m Delete the inatallation directory [0m
rmdir /Q /S installDir

