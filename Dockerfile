FROM ubuntu:trusty
MAINTAINER YI-HUNG JEN <yihungjen@gmail.com>

# install core components
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    dnsutils \
    g++ \
    gdb \
    git \
    htop \
    make \
    man \
    openjdk-7-jdk \
    python \
    python-dev \
    ruby2.0 \
    ruby2.0-dev \
    socat \
    tmux \
    telnet \
    vim \
    vim-gtk \
    xclip \
    xsel \
    zip \
    zlib1g \
    zlib1g-dev

# setup local info
RUN locale-gen en_US.UTF-8

# install command line json parser
RUN curl -sSL http://stedolan.github.io/jq/download/linux64/jq -o /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq

# install docker client
RUN curl -sSL https://get.docker.com/builds/`uname -s`/`uname -m`/docker-1.11.0.tgz | tar \
    --transform "s@docker@./@" \
    -zxf - -C /usr/local/bin -- docker/docker

# install docker-compose for local service stack orchestration
RUN curl -sSL https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# install docker-machine
RUN curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
RUN chmod +x /usr/local/bin/docker-machine

# install etcdctl
RUN curl -sSL https://github.com/coreos/etcd/releases/download/v2.2.1/etcd-v2.2.1-linux-amd64.tar.gz | tar \
    --transform "s@etcd-v2.2.1-linux-amd64@./@" \
    -zxf - -C /usr/local/bin -- etcd-v2.2.1-linux-amd64/etcdctl

# install confd
RUN curl -sSL https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 > /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd
# setup default confd backend config dir
RUN mkdir -p /etc/confd

# install maven
RUN mkdir -p /usr/local/mvn
RUN curl -sSL http://apache.stu.edu.tw/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz | tar \
    --transform "s@apache-maven-3.3.9@./@" \
    -zxf - -C /usr/local/mvn --

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_4.x | /bin/bash -
RUN apt-get install -y nodejs

# install common node packages
RUN npm install -g \
    bower \
    mustache

# install package manager for python
RUN curl -sSL https://bootstrap.pypa.io/get-pip.py | python -

# install common python packages
RUN pip install \
    ipython \
    requests \
    awscli \
    powerline-status \
    virtualenv

# install golang pacakge
RUN curl -sSL https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz | tar -C /usr/local -zxf -

# the user that will run this container
RUN groupadd -g 999 docker
RUN useradd -s /bin/bash -d /home/yihungjen -G sudo,docker -m yihungjen
RUN echo "yihungjen:!@mYihungJ3n" | chpasswd

COPY entrypoint.sh /entrypoint.sh
COPY profile ./.profile

# get instance of workspaceenv for workspace configuration
COPY . /home/yihungjen/.workspaceenv
# setup workspace with bootsrap command
WORKDIR /home/yihungjen/.workspaceenv
RUN env HOME=/home/yihungjen ./bootstrap

ENV GOROOT /usr/local/go
ENV GOPATH /home/yihungjen/go
ENV PATH /home/yihungjen/go/bin:/home/yihungjen/bin:/usr/local/go/bin:/usr/local/mvn/bin:$PATH

# VOLUME hooks for security settings
VOLUME /home/yihungjen/.aws
VOLUME /home/yihungjen/.gnupg
VOLUME /home/yihungjen/.m2
VOLUME /home/yihungjen/.ssh

# make sure permission is correct
WORKDIR /home/yihungjen
RUN chown -R yihungjen:yihungjen ./

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-l"]
