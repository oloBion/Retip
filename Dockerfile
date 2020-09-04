FROM rocker/r-ver:3.6.2

ARG MIRROR=https://mirrors.nic.cz/R/

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Prague


RUN apt -y update
RUN apt -y install libpng-dev zlib1g-dev openjdk-11-jdk-headless
RUN apt -y install libpcre3-dev liblzma-dev libbz2-dev
RUN apt -y install libicu-dev 
 
RUN apt install -y libssl-dev libxml2-dev libssh2-1-dev libcurl4-openssl-dev

RUN Rscript -e "install.packages('devtools',repos='${MIRROR}')"
RUN Rscript -e 'devtools::install_github("Paolobnn/Retiplib")'

RUN mkdir -p /build/retip
COPY DESCRIPTION NAMESPACE Retip.Rproj /build/retip/
COPY R/ /build/retip/R/
COPY data/ /build/retip/data/
COPY examples/ /build/retip/examples/
COPY man/ /build/retip/man/
COPY vignettes/ /build/retip/vignettes/
COPY .git/ /build/retip/.git/

RUN apt -y install pkg-config

WORKDIR /build/retip
RUN Rscript -e "devtools::install_local('.',repos='${MIRROR}')"
RUN rm -rf /build/retip

RUN Rscript -e "install.packages('readxl',repos='${MIRROR}')"
RUN Rscript -e 'reticulate::install_miniconda()'
RUN bash -c "source /root/.local/share/r-miniconda/bin/activate r-reticulate && Rscript -e 'library(keras); install_keras()'"

RUN Rscript -e "install.packages('readr',repos='${MIRROR}')"
RUN Rscript -e "install.packages('feather',repos='${MIRROR}')"

WORKDIR /

RUN apt -y remove $(dpkg -l | grep -- -dev | awk '{print $2}')
RUN apt -y remove openjdk-11-jdk-headless
# nice but removes too much
# RUN apt -y autoremove

RUN apt -y clean
RUN chmod go+x /root

RUN mkdir /Retip
COPY galaxy/*.R /Retip/
COPY galaxy/run.sh /

#Don't add entrypoint because with entry point it fails with galaxy
#ENTRYPOINT [ "/run.sh" ]
