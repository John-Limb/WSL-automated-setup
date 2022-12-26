#The base image
FROM ubuntu:22.10
#Set Timezone
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Add user
ARG USER
#Run container build script
RUN resources/dev-env.sh

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


