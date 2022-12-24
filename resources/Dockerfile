#The base image
FROM ubuntu:20.04
# Add user
ARG USER  

#Install base applications
RUN apt-get update -y && apt-get -y install python iputils-ping \
    iproute2 openssh-client openssh-server curl wget vim passwd sudo \
    apt-transport-https ca-certificates \
    software-properties-common
 
## now we have curl installed we can add the other repos etc.
#Add google keyring for k8s cli
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#Add repo for Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
#install keyring
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update -y && apt-get -y install helm
RUN apt-get install age
#Install SOPS for file encryption
RUN wget https://github.com/mozilla/sops/releases/download/v3.7.3/sops_3.7.3_amd64.deb
RUN sudo dpkg -i ./sops_3.7.3_amd64.deb
RUN rm ./sops_3.7.3_amd64.deb
#install flux
RUN curl -s https://fluxcd.io/install.sh | sudo bash
#Install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

#Add current user to environment 
RUN /bin/bash -c 'useradd -m -s /bin/bash -g root ${USER}; echo "${USER}:PassW0rd" | chpasswd'

#Add wsl settings to change mount point and default user
COPY ./resources/wsl.conf /etc/wsl.conf
RUN /bin/bash -c 'echo "default=${USER}" >> /etc/wsl.conf; \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers;'

#Set the default user
USER $USER

#Add default .bashrc for new user
COPY --chown=$USER:root ./resources/bashrc /home/${USER}/.bashrc 


