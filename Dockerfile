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
#COPY Dockerfile DESCRIPTION NAMESPACE R/ Retip.Rproj data/ examples/ man/ vignettes/ /build/retip/
COPY . /build/retip/

WORKDIR /build/retip
RUN R CMD build .
RUN Rscript -e 'install.packages("Retip_0.5.4.tar.gz")'

