FROM buildpack-deps:bionic-scm

ENV BASE_DIR /usr/local

# Set up common env variables
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV NB_USER jovyan
ENV NB_UID 1000
ENV PY_VER 3.8

RUN adduser --disabled-password --gecos "Default Jupyter user" ${NB_USER}

RUN apt-get -qq update --yes && \
    apt-get -qq install --yes \
            tar \
            vim \
            locales > /dev/null

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install Python
COPY install_python3.sh /tmp/install_python3.sh
RUN /tmp/install_python3.sh


# for nbconvert
RUN apt-get -qq install --yes \
            pandoc \
            texlive-xetex \
            texlive-fonts-recommended \
            texlive-generic-recommended > /dev/null

# 700MB
# install R, packages, and RStudio dependencies
RUN apt-get -qq update --yes && \
    apt-get -qq install --yes \
            libapparmor1 \
            libgdal-dev \
            libproj-dev \
            psmisc \
            sudo \
            r-base \
            r-base-dev \
            r-cran-aer \
            r-cran-backports \
            r-cran-base64enc \
            r-cran-bindrcpp \
            r-cran-broom \
            r-cran-crayon \
            r-cran-crosstalk \
            r-cran-curl \
            r-cran-data.table \
            r-cran-dbi \
            r-cran-devtools \
            r-cran-digest \
            r-cran-e1071 \
            r-cran-evaluate \
            r-cran-forcats \
            r-cran-ggplot2 \
            r-cran-glue \
            r-cran-haven \
            r-cran-highr \
            r-cran-hms \
            r-cran-htmlwidgets \
            r-cran-httpuv \
            r-cran-httr \
            r-cran-lubridate \
            r-cran-mapproj \
            r-cran-maptools \
            r-cran-markdown \
            r-cran-matrix \
            r-cran-matrixstats \
            r-cran-memoise \
            r-cran-nlme \
            r-cran-openssl \
            r-cran-pbdzmq \
            r-cran-pillar \
            r-cran-png \
            r-cran-praise \
            r-cran-proto \
            r-cran-raster \
            r-cran-rcolorbrewer \
            r-cran-rcpp \
            r-cran-rcurl \
            r-cran-readr \
            r-cran-readxl \
            r-cran-rematch \
            r-cran-repr \
            r-cran-reshape \
            r-cran-rjson \
            r-cran-rlang \
            r-cran-rpart \
            r-cran-rprojroot \
            r-cran-shiny \
            r-cran-sp \
            r-cran-spatstat \
            r-cran-spdep \
            r-cran-stringr \
            r-cran-stringi \
            r-cran-testthat \
            r-cran-tibble \
            r-cran-tidyr \
            r-cran-utf8 \
            r-cran-uuid \
            r-cran-viridis \
            r-cran-withr \
            r-cran-xml2 \
            r-cran-yaml \
            r-cran-rlist \
            r-cran-jsonlite \
            r-cran-assertthat \
            lsb-release > /dev/null

# install graphviz
RUN apt-get -qq update --yes && \
    apt-get -qq install --yes graphviz

# Install some R libraries that aren't in the debs
COPY install.R  /tmp/install.R
# CircleCI stops printing output at 40k chars.
# We send stdout to a log file, and tail it a bit
# FIXME: Find something less sucky
# another hubploy #1
# 226MB
RUN Rscript /tmp/install.R > /tmp/r-custom-packages.log 2>&1 && \
    true || ( echo FAIL ; tail /tmp/r-custom-packages.log ; false )
RUN tail /tmp/r-custom-packages.log
RUN rm /tmp/r-custom-packages.log

ENV RSTUDIO_URL https://download2.rstudio.org/rstudio-server-1.1.453-amd64.deb
ENV RSTUDIO_CHECKSUM 3c546fa9067f48ed1a342f810fca8be6

# install rstudio
# 356MB
RUN curl --silent --location --fail ${RSTUDIO_URL} > /tmp/rstudio.deb && \
    echo "${RSTUDIO_CHECKSUM} /tmp/rstudio.deb" | md5sum -c - && \
    dpkg -i /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb

ENV PATH ${BASE_DIR}/bin:$PATH:/usr/lib/rstudio-server/bin

# Set this to be on container storage, rather than under $HOME
ENV IPYTHONDIR ${BASE_DIR}/etc/ipython

# FIXME: Move this elsewhere in the dockerfile?
# Install packages needed by notebook-as-pdf
# Default fonts seem ok, we just install an emoji font
RUN apt-get update && \
    apt-get install --yes \
            libx11-xcb1 \
            libxtst6 \
            libxrandr2 \
            libasound2 \
            libpangocairo-1.0-0 \
            libatk1.0-0 \
            libatk-bridge2.0-0 \
            libgtk-3-0 \
            libnss3 \
            libxss1 \
            fonts-noto-color-emoji && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Python package install
COPY requirements.txt /tmp/requirements.txt
COPY infra-requirements.txt /tmp/infra-requirements.txt

RUN pip install --no-cache -r /tmp/infra-requirements.txt

RUN pip install --no-cache -r /tmp/requirements.txt

# Install IR kernelspec
RUN Rscript -e "IRkernel::installspec(user = FALSE, prefix='${BASE_DIR}')"

COPY d8extension.bash /usr/local/sbin/d8extension.bash
RUN /usr/local/sbin/d8extension.bash

ADD ipython_config.py ${IPYTHONDIR}/ipython_config.py

# install QGrid notebook extension
RUN jupyter nbextension enable --py --sys-prefix qgrid

# Install jupytext
RUN pip install jupytext

# Ottr grader.
RUN Rscript -e "devtools::install_github('ucbds-infra/ottr', ref='0.0.1', upgrade_dependencies=FALSE, quiet=FALSE)"

# Path for pip user install
WORKDIR /home/${NB_USER}
ENV PATH /home/${NB_USER}/.local/bin:$PATH

USER ${NB_USER}

EXPOSE 8888
