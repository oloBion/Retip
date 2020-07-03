FROM rocker/r-ver:3.6.2

RUN Rscript -e 'install.packages("devtools",repos="https://mirrors.nic.cz/R/")'

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Prague

RUN apt -y update
RUN apt -y install libpng-dev zlib1g-dev openjdk-11-jdk-headless
RUN apt -y install libpcre3-dev liblzma-dev libbz2-dev
RUN apt -y install libicu-dev 
 
RUN Rscript -e 'install.packages(c("rcdklibs", "rJava", "png", "ggplot2", "ModelMetrics" ,"keras", "caret", "xgboost", "doParallel", "brnn", "rcdk", "dplyr"),repos="https://mirrors.nic.cz/R/")'

RUN mkdir -p /build/retip
WORKDIR /build
COPY DESCRIPTION NAMESPACE Retip.Rproj /build/retip/
COPY R/ /build/retip/R/
COPY data/ /build/retip/data/
COPY examples/ /build/retip/examples/
COPY man/ /build/retip/man/
COPY vignettes/ /build/retip/vignettes/


WORKDIR /build/retip
RUN R CMD build .
RUN Rscript -e 'install.packages("Retip_0.5.4.tar.gz")'

WORKDIR /
RUN rm -rf /build

# examples need it
RUN Rscript -e 'install.packages("readxl",repos="https://mirrors.nic.cz/R/")'

RUN apt -y remove $(dpkg -l | grep -- -dev | awk '{print $2}')
RUN apt -y remove openjdk-11-jdk-headless
# nice but removes too much
# RUN apt -y autoremove

# if we ever need it
# RUN apt -y install openjdk-11-jre-headless

RUN apt -y clean


