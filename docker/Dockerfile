FROM r-base:3.6.3
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

# install Python
ENV PATH=/opt/conda/bin:${PATH}

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# install Retip dependencies
COPY install_dependencies.R /home/docker
RUN Rscript /home/docker/install_dependencies.R && \
    rm /home/docker/install_dependencies.R

RUN cd /home/docker && \
    git clone -b v2.2.3 --single-branch --recursive https://github.com/microsoft/LightGBM && \
    cd LightGBM && \
    Rscript build_r.R && \
    rm -rf /home/docker/LightGBM

# set data volume
VOLUME /data

# set working directory
WORKDIR /home/docker

ENTRYPOINT ["bash"]
