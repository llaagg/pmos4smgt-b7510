FROM alpine

ARG USER=pmosuser

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh sudo 

RUN apk add python3 coreutils procps openssl

#usefull for obtaining boot.img
#RUN apk --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ add android-tools
#RUN echo 'root:docker' | chpasswd
RUN adduser -D $USER \
        && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
        && chmod 0440 /etc/sudoers.d/$USER

#bugfix warkaround (https://github.com/sudo-project/sudo/issues/42)
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

USER $USER
WORKDIR /home/$USER
RUN pip3 install --user pmbootstrap

ENV PATH="/home/$USER/.local/bin:${PATH}"

ADD config.cfg /home/${USER}/config.cfg
RUN cat ~/config.cfg | pmbootstrap init

# RUN cat /home/pmosuser/.local/var/pmbootstrap/log.txt
#RUN tail /home/pmosuser/.local/var/pmbootstrap/log.txt -n 60

RUN sed -i -e '/_repository/ s/=.*/=android_kernel_samsung_msm/' ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/APKBUILD 
RUN sed -i -e '/_commit=/ s/=.*/=25f2ea57bae01ffe86e1da7232d1855394c054b2/' ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/APKBUILD 
RUN sed -i -e '/$pkgname-$_commit.tar.gz/ s/::.*/::https:\/\/github.com\/MardonHH\/$_repository\/archive\/$_commit.tar.gz/' ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/APKBUILD 

#version same is makefile of the kernel
RUN sed -i -e '/pkgver/ s/=.*/=3.0.31/' ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/APKBUILD

# not sure if that should be done
RUN mkdir -p ~/.local/var/pmbootstrap/chroot_native/dev

ADD config-samsung-gtb7510.armhf /home/${USER}/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/

RUN whoami

RUN /home/pmosuser/.local/bin/pmbootstrap checksum linux-samsung-gtb7510

#TODO
# 1. consume all paramters from comand line for pmbootstrap init
# 2. fix missing dev folder for mount
