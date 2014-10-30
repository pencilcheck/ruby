FROM ubuntu:trusty

MAINTAINER Penn Su "pennsu@gmail.com"

# Prepping install
RUN apt-get update && apt-get install -y \
  build-essential \
  wget \
  curl \
  git \
  zlib1g-dev \
  libssl-dev \
  libreadline-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt-dev \
  bison \
  vim-nox \
  imagemagick
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install RVM Ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /etc/gemrc
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 BF04FF17
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby=2.1.3 --gems=bundler,rubygems-update
RUN echo 'source /usr/local/rvm/scripts/rvm' >> ~/.bashrc
