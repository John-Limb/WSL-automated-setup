#!/bin/sh
set -euo pipefail
#Install base applications
apt-get update -y && apt-get -y install iputils-ping \
    iproute2 openssh-client openssh-server curl wget vim passwd sudo \
    apt-transport-https ca-certificates \
    software-properties-common git-all
 
## now we have curl installed we can add the other repos etc.
#Add google keyring for k8s cli
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#Add repo for Helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
#install keyring
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# Now install helm and kubectl
apt-get update -y && apt-get -y install helm kubectl
#Install age
wget -O age.tar.gz https://github.com/FiloSottile/age/releases/download/v1.0.0/age-v1.0.0-linux-amd64.tar.gz
tar xf age.tar.gz
mv age/age /usr/local/bin
mv age/age-keygen /usr/local/bin
#Install SOPS for file encryption
wget https://github.com/mozilla/sops/releases/download/v3.7.3/sops_3.7.3_amd64.deb
sudo dpkg -i ./sops_3.7.3_amd64.deb
rm ./sops_3.7.3_amd64.deb
#install flux
curl -s https://fluxcd.io/install.sh | sudo bash

#Install VS code server
sudo curl -fsSL https://code-server.dev/install.sh | sh

#install and setup zsh
apt install zsh
#install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"