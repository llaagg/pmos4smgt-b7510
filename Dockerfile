FROM alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh sudo

RUN apk add python3 coreutils procps openssl

# go with new user
RUN adduser  -D -u 1000 pmosuser
USER pmosuser
WORKDIR /home/pmosuser



RUN pip3 install --user pmbootstrap


#RUN git clone https://gitlab.com/postmarketOS/pmbootstrap.git
#RUN python3 "$PWD/pmbootstrap/setup.py" install

