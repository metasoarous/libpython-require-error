FROM clojure:openjdk-8-tools-deps

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
RUN clojure -e "(clojure.core/println :deps-downloaded)"


# Systems go
CMD clojure -m nrepl.cmdline --middleware "[cider.nrepl/cider-middleware]" --port 9876


