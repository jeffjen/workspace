FROM ubuntu:latest
MAINTAINER YI-HUNG JEN <yihungjen@gmail.com>

# install core components
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    cmake \
    g++ \
    gem \
    gdb \
    git \
    git-svn \
    golang \
    libssl-dev \
    libreadline-dev \
    make \
    maven2 \
    openjdk-7-jdk \
    php5-cli \
    php5-dev \
    python \
    python-dev \
    ruby \
    ruby-dev \
    screen \
    vim \
    zlib1g-dev

# install docker client (but sadly has docker daemon in there)
RUN curl -sSL https://get.docker.com/ | sh

# install composer for php package management
RUN curl -sSL https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin \
    --filename=composer

# install package manager for python
RUN curl -sSL https://bootstrap.pypa.io/get-pip.py | python -

# install common python packages
RUN pip install \
    ipython \
    requests \
    awscli \
    powerline-status

# install kensa helper tool
RUN gem install kensa

# the user that will run this container
RUN useradd -s /bin/bash -d /home/yihungjen -G sudo -m yihungjen
RUN echo "yihungjen:!@mYihungJ3n" | chpasswd

WORKDIR /home/yihungjen

COPY profile ./.profile

# get instance of workspaceenv for workspace configuration
COPY . /home/yihungjen/.workspaceenv

# setup workspace with bootsrap command
RUN env HOME=/home/yihungjen .workspaceenv/bootstrap

# make sure permission is correct
RUN chown -R yihungjen:yihungjen ./

# VOLUME hooks for security settings
VOLUME /home/yihungjen/.aws
VOLUME /home/yihungjen/.gnupg
VOLUME /home/yihungjen/.m2
VOLUME /home/yihungjen/.ssh

CMD ["/bin/bash", "-l"]
