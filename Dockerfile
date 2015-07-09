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
    python \
    python-dev \
    screen \
    tmux \
    vim

# setup nodejs pkg source
RUN curl -sSL https://deb.nodesource.com/setup | bash
RUN apt-get install -y nodejs

# install golang pacakge
RUN curl -sSL https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | tar -C /usr/local -zxf -

# install docker client
RUN curl -sSL https://get.docker.com/builds/Linux/x86_64/docker-latest > /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker

# install docker machine client
RUN curl -sSL https://github.com/docker/machine/releases/download/v0.3.0/docker-machine_linux-amd64 > /usr/local/bin/docker-machine
RUN chmod +x /usr/local/bin/docker-machine

# install package manager for python
RUN curl -sSL https://bootstrap.pypa.io/get-pip.py | python -

# install common python packages
RUN pip install \
    ipython \
    requests \
    awscli \
    powerline-status

# install command line json parser
RUN curl -sSL http://stedolan.github.io/jq/download/linux64/jq -o /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq

# the user that will run this container
RUN groupadd -g 999 docker
RUN useradd -s /bin/bash -d /home/yihungjen -G sudo,docker -m yihungjen
RUN echo "yihungjen:!@mYihungJ3n" | chpasswd

WORKDIR /home/yihungjen

COPY profile ./.profile

# get instance of workspaceenv for workspace configuration
COPY . /home/yihungjen/.workspaceenv

# setup workspace with bootsrap command
RUN env HOME=/home/yihungjen .workspaceenv/bootstrap

# make sure permission is correct
RUN chown -R yihungjen:yihungjen ./

ENV GOROOT /usr/local/go
ENV GOPATH /home/yihungjen/go
ENV PATH /home/yihungjen/go/bin:/home/yihungjen/bin:/usr/local/go/bin:$PATH

# VOLUME hooks for security settings
VOLUME /home/yihungjen/.aws
VOLUME /home/yihungjen/.gnupg
VOLUME /home/yihungjen/.m2
VOLUME /home/yihungjen/.ssh

CMD ["/bin/bash", "-l"]
