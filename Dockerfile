FROM ubuntu:trusty

MAINTAINER Penn Su "pennsu@gmail.com"

# Remove sh and use bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

# Prepping install
RUN apt-get update
RUN apt-get install -y \
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
  imagemagick \
  nginx \
  supervisor
RUN apt-get clean

# Installing rbenv w/ ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/bin:~/.rbenv/shims:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
ENV PATH ~/.rbenv/bin:~/.rbenv/shims:$PATH
RUN source ~/.bashrc

# Install Ruby
ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install 2.1.3
RUN rbenv global 2.1.3
RUN rbenv init -
RUN rbenv rehash

# Install Bundler
RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN gem install bundler rubygems-update && rbenv rehash

# Run nginx in foreground
RUN \
  rm -rf /var/lib/apt/lists/* && \
  echo "daemon off;" >> /etc/nginx/nginx.conf

ADD supervisor.conf /etc/supervisor/conf.d/nginx.conf

# Clean up APT and temporary files when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data", "/var/log/nginx", "/var/log/supervisor"]

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
