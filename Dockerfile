# We will use Ubuntu for our image
FROM ubuntu:latest

# Updating Ubuntu packages

ARG CLOJURE_TOOLS_VERSION=1.10.1.507

RUN apt-get -qq update \
    && apt install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa

RUN apt-get -qq update && apt-get -qq -y install curl wget bzip2 openjdk-8-jdk-headless python3.9 libpython3.9 python3-pip python3-distutils rlwrap\
    && curl -o install-clojure https://download.clojure.org/install/linux-install-${CLOJURE_TOOLS_VERSION}.sh \
    && chmod +x install-clojure \
    && ./install-clojure && rm install-clojure \
    && wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
    && chmod a+x lein \
    && mv lein /usr/bin \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log 


# ARG USERID
# ARG GROUPID
# ARG USERNAME

# RUN groupadd -g $GROUPID $USERNAME
# RUN useradd -u $USERID -g $GROUPID $USERNAME
# RUN mkdir /home/$USERNAME && chown $USERNAME:$USERNAME /home/$USERNAME
# USER $USERNAME

# Install leiningen during build process
RUN lein -v

EXPOSE 9876

# Setup python
RUN apt-get -qq update \
  && apt-get install -y software-properties-common \
  && add-apt-repository -y ppa:deadsnakes/ppa \
  && apt-get install -y python3.9 libpython3.9 python3-pip python3-distutils

# This should make tech.ml stuff fast for things like pca/svd
RUN apt-get install -y libblas-dev gfortran libopenblas-dev liblapack-dev zlib1g-dev zlib1g

# Preinstall python packages
RUN pip3 install numpy scipy sklearn pandas numba umap-learn


# Everything after this will get rerun even if the commands haven't changed, since data could change
WORKDIR /app
COPY . .

# Make sure deps are pre-installed
RUN clojure -e "(clojure.core/println :deps-downloaded)" ||  clojure -e "(clojure.core/println :deps-downloaded)" || clojure -e "(clojure.core/println :deps-downloaded)" || clojure -e "(clojure.core/println :deps-downloaded)" || clojure -e "(clojure.core/println :deps-downloaded)"

# install Java 17
RUN apt install -y -qq libc6-x32 libc6-i386 libasound2 git
RUN wget -q https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
RUN dpkg -i jdk-17_linux-x64_bin.deb
RUN git clone https://github.com/jenv/jenv.git ~/.jenv

CMD make run


