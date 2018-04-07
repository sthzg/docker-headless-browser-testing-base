# https://github.com/nodejs/docker-node/blob/b3ca6573b5c179148b446107386ae96ac6204ad3/8/Dockerfile
FROM node:8

# Java.
# ---
RUN set -ex \
  && echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
  && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
  && apt-get update \
  && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
  && apt-get install -y oracle-java8-installer \
  && rm -rf /var/cache/oracle-jdk8-installer

# Chrome.
# ---
RUN set -ex \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    google-chrome-stable

# PhantomJS.
# ---
RUN set -ex \
  apt-get install build-essential chrpath libssl-dev libxft-dev -y \
  && apt-get install libfreetype6 libfreetype6-dev -y \
  && apt-get install libfontconfig1 libfontconfig1-dev -y \
  && mkdir -p /tmp/phantom \
  && cd /tmp/phantom \
  && export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64" \
  && wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/$PHANTOM_JS.tar.bz2 \
  && tar xvjf $PHANTOM_JS.tar.bz2 \
  && mv $PHANTOM_JS /usr/local/share \
  && ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin \
  && phantomjs --version \
  && rm -Rfv /tmp/phantom

# Cleanup.
# ---
RUN set -ex \
  && rm -rf /var/lib/apt/lists/*    

# Global Node Binaries.
# ---
RUN yarn global add pm2 concurrently

CMD [ "node" ]
