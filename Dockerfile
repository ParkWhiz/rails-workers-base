FROM alpine:3.2
MAINTAINER ParkWhiz <dev@parkwhiz.com>

ENV RUBY_VERSION 2.2.4
ENV RUBYGEMS_VERSION 2.4.8
ENV BUNDLER_VERSION 1.11.2
ENV RAILS_VERSION 4.2.5.1
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_APP_CONFIG $GEM_HOME
ENV PATH $GEM_HOME/bin:$PATH
ENV BUILD_PACKAGES autoconf wget curl ruby-dev build-base openssl-dev postgresql-dev libc-dev pcre pcre-dev bison  procps libstdc++ git
ENV RUBY_PACKAGES tzdata postgresql-client ca-certificates ruby-rake nodejs nginx linux-headers curl-dev libxml2-dev libxslt-dev readline-dev procps

RUN apk update && \
    apk add bash && \
    apk --update add --virtual build-dependencies $BUILD_PACKAGES && \
    apk --update add --virtual ruby-packages $RUBY_PACKAGES && \
    mkdir -p /usr/src/ruby && \
    curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" && \
    tar -xzf ruby.tar.gz -C /usr/src/ruby &&\
    rm ruby.tar.gz && \
    cd "/usr/src/ruby/ruby-$RUBY_VERSION" && \
    autoconf && \
    ./configure --disable-install-doc --with-readline-dir=/usr/ && \
    make -j"$(nproc)" && \
    make install && \
    gem update -N --system $RUBYGEMS_VERSION && \
    rm -rf /usr/src/ruby && \
    cd ~/ && \
    gem install bundler --no-rdoc --no-ri --no-doc --version "$BUNDLER_VERSION" && \
    bundle config --global path "$GEM_HOME" && \
	  bundle config --global bin "$GEM_HOME/bin" && \
    gem install nokogiri -v 1.6.7 --no-rdoc --no-ri --no-doc -- --use-system-libraries && \
    gem install rb-readline --no-rdoc --no-ri --no-doc && \
    gem install json -v 1.8.3 --no-rdoc --no-ri --no-doc && \
    gem install rails -v "$RAILS_VERSION" --no-rdoc --no-ri --no-doc &&\
    gem install redis --no-rdoc --no-ri --no-doc && \
    gem install sidekiq -v 4.1.0 --no-rdoc --no-ri --no-doc && \
    mkdir -p /usr/app

WORKDIR /usr/app
