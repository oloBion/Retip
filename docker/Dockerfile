FROM r-base:4.4.4
LABEL maintainer="sajjan.s.mehta@gmail.com"

# install Retip build dependencies
RUN apt-get update && \
    apt-get install -yqq --no-install-recommends curl wget git && \
    apt-get install -yqq --no-install-recommends build-essential cmake libcurl4-gnutls-dev libxml2-dev libssl-dev libgit2-dev && \
    apt-get install -yqq --no-install-recommends libfontconfig1-dev libcairo2-dev pandoc && \
    apt-get -yqq install openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/*

# configure Java for R
# https://stackoverflow.com/a/58647104/406772
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/bin/java
ENV LD_LIBRARY_PATH=/usr/lib/jvm/java-11-openjdk-amd64/lib/server:${LD_LIBRARY_PATH}

RUN R CMD javareconf

# set working directory 
WORKDIR /home/docker

# install Retip dependencies
COPY install_dependencies.R /home/docker
RUN Rscript install_dependencies.R

RUN git clone -b v2.2.3 --single-branch --recursive https://github.com/microsoft/LightGBM && \
    cd LightGBM && \
    Rscript build_r.R

# set data volume
VOLUME /data

ENTRYPOINT ["bash"]
