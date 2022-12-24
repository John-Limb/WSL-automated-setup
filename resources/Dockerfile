#The base image
FROM ubuntu:22.10
#Set Timezone
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Add user
ARG USER  

#Install base applications
RUN apt-get update -y && apt-get -y install iputils-ping \
    iproute2 openssh-client openssh-server curl wget vim passwd sudo \
    apt-transport-https ca-certificates \
    software-properties-common git-all
 
## now we have curl installed we can add the other repos etc.
#Add google keyring for k8s cli
RUN curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#Add repo for Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
#install keyring
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# Now install helm and kubectl
RUN apt-get update -y && apt-get -y install helm kubectl
#Install age
RUN wget -O age.tar.gz https://github.com/FiloSottile/age/releases/download/v1.0.0/age-v1.0.0-linux-amd64.tar.gz
RUN tar xf age.tar.gz
RUN mv age/age /usr/local/bin
RUN mv age/age-keygen /usr/local/bin
#Install SOPS for file encryption
RUN wget https://github.com/mozilla/sops/releases/download/v3.7.3/sops_3.7.3_amd64.deb
RUN sudo dpkg -i ./sops_3.7.3_amd64.deb
RUN rm ./sops_3.7.3_amd64.deb
#install flux
RUN curl -s https://fluxcd.io/install.sh | sudo bash
#Install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

#Install VS code server
RUN sudo curl -fsSL https://code-server.dev/install.sh | sh
RUN systemctl --user enable --now code-server
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


