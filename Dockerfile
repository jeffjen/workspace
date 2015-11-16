FROM ubuntu:latest
MAINTAINER YI-HUNG JEN <yihungjen@gmail.com>

# install core components
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    g++ \
    gdb \
    git \
    git-svn \
    htop \
    make \
    man \
    openjdk-7-jdk \
    python \
    python-dev \
    ruby \
    ruby-dev \
    screen \
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

# setup nodejs pkg source
RUN curl -sSL https://nodejs.org/dist/v4.1.2/node-v4.1.2-linux-x64.tar.gz | tar -C /usr/local -zxf -
RUN mv /usr/local/node-v4.1.2-linux-x64 /usr/local/node
RUN /usr/local/node/bin/npm install -g bower

# install golang pacakge
RUN curl -sSL https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz | tar -C /usr/local -zxf -

# install docker client
RUN curl -sSL https://get.docker.com/builds/Linux/x86_64/docker-latest > /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker

# install docker-compose for local service stack orchestration
RUN curl -sSL https://github.com/docker/compose/releases/download/1.5.1/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# install package manager for python
RUN curl -sSL https://bootstrap.pypa.io/get-pip.py | python -

# install common python packages
RUN pip install \
    ipython \
    requests \
    awscli \
    powerline-status \
    virtualenv

# install command line json parser
RUN curl -sSL http://stedolan.github.io/jq/download/linux64/jq -o /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq

# the user that will run this container
RUN groupadd -g 999 docker
RUN useradd -s /bin/bash -d /home/yihungjen -G sudo,docker -m yihungjen
RUN echo "yihungjen:!@mYihungJ3n" | chpasswd

# setup local info
RUN locale-gen en_US.UTF-8

WORKDIR /home/yihungjen

COPY entrypoint.sh /entrypoint.sh
COPY profile ./.profile

# get instance of workspaceenv for workspace configuration
COPY . /home/yihungjen/.workspaceenv

# setup workspace with bootsrap command
RUN env HOME=/home/yihungjen .workspaceenv/bootstrap

# make sure permission is correct
RUN chown -R yihungjen:yihungjen ./

ENV GOROOT /usr/local/go
ENV GOPATH /home/yihungjen/go
ENV PATH /home/yihungjen/go/bin:/home/yihungjen/bin:/usr/local/go/bin:/usr/local/node/bin:$PATH

# VOLUME hooks for security settings
VOLUME /home/yihungjen/.aws
VOLUME /home/yihungjen/.gnupg
VOLUME /home/yihungjen/.m2
VOLUME /home/yihungjen/.ssh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-l"]
