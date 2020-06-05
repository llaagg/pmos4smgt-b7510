FROM alpine

ARG USER=pmosuser

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash git openssh sudo \
    && apk add python3 coreutils procps openssl

#Extra tools
#usefull for obtaining boot.img
#RUN apk --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ add android-tools

RUN adduser -D $USER \
        && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
        && chmod 0440 /etc/sudoers.d/$USER \
#bugfix warkaround (https://github.com/sudo-project/sudo/issues/42)
        && echo "Set disable_coredump false" >> /etc/sudo.conf

USER $USER
WORKDIR /home/$USER
RUN pip3 install --user pmbootstrap

ENV PATH="/home/$USER/.local/bin:${PATH}"

ADD config.cfg /home/${USER}/config.cfg
RUN cat ~/config.cfg | pmbootstrap init

ADD config-samsung-gtb7510.armhf /home/${USER}/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/
RUN sudo chmod a+rwx /home/${USER}/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/config-samsung-gtb7510.armhf 

#
RUN sed -i -e '/\_repository=/ s/=.*/=android_kernel_samsung_msm/' ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/APKBUILD 
RUN sed -i -e '/\_commit=/ s/=.*/=25f2ea57bae01ffe86e1da7232d1855394c054b2/' ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/APKBUILD  
RUN sed -i -e '/$pkgname-$_commit.tar.gz/ s/::.*/::https:\/\/github.com\/MardonHH\/$_repository\/archive\/$_commit.tar.gz/' ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/APKBUILD  
    #version same is makefile of the kernel
RUN sed -i -e '/pkgver/ s/=.*/=3.0.31/' ~/.local/var/pmbootstrap/cache_git/pmaports/device/testing/linux-samsung-gtb7510/APKBUILD

RUN echo $'echo Starting Post Market Bootstrap \n\
pmbootstrap checksum linux-samsung-gtb7510 \n\
pmbootstrap kconfig check \n\
pmbootstrap kconfig edit samsung-gtb7510 \n\
pmbootstrap build linux-samsung-gtb7510 \n\
' > ~/pmrunner.sh
RUN cat ~/pmrunner.sh
RUN chmod a+x ./pmrunner.sh

# run is cached, cmd is not cached and always starting
#CMD "./pmrunner.sh"


#TODO
# 1. consume all paramters from comand line for pmbootstrap init

#  CC      arch/arm/mach-msm/spm_devices.o
# /home/pmos/build/src/android_kernel_samsung_msm-25f2ea57bae01ffe86e1da7232d1855394c054b2/arch/arm/mach-msm/spm_devices.c: In function 'msm_spm_turn_on_cpu_rail':        
# /home/pmos/build/src/android_kernel_samsung_msm-25f2ea57bae01ffe86e1da7232d1855394c054b2/arch/arm/mach-msm/spm_devices.c:176:9: error: 'MSM_SAW1_BASE' undeclared (first 
# use in this function); did you mean 'MSM_AD5_BASE'?
#   176 |   reg = MSM_SAW1_BASE;
#       |         ^~~~~~~~~~~~~ 
#       |         MSM_AD5_BASE
# /home/pmos/build/src/android_kernel_samsung_msm-25f2ea57bae01ffe86e1da7232d1855394c054b2/arch/arm/mach-msm/spm_devices.c:176:9: note: each undeclared identifier is reported only once for each function it appears in
# samsung devicde driver for adb
# https://developer.samsung.com/mobile/android-usb-driver.html
# boot imae testing 
# https://android.stackexchange.com/questions/69954/how-to-unpack-and-edit-boot-img-for-rom-porting
