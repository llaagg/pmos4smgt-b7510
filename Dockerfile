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

ADD config.cfg  /home/pmosuser/config.cfg
RUN cat config.cfg | .local/bin/pmbootstrap init

RUN sed -i -e '/pkgver/ s/=.*/=3.0.0/' /home/pmosuser/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/APKBUILD
RUN .local/bin/pmbootstrap checksum samung-gtb7510

# RUN cat /home/pmosuser/.local/var/pmbootstrap/log.txt
RUN tail /home/pmosuser/.local/var/pmbootstrap/log.txt -n 60