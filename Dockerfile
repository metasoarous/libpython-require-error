FROM clojure:openjdk-17-tools-deps

EXPOSE 9876

RUN apt-get update && apt-get install -y gnupg2

RUN echo "deb http://fr.archive.ubuntu.com/ubuntu bionic main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
RUN apt-get update
RUN apt-get install libpython3.9-dev python3-pip -y --allow-unauthenticated

# This should make tech.ml stuff fast for things like pca/svd
RUN apt-get install -y libblas-dev
RUN apt-get install -y gfortran
RUN apt-get install -y libopenblas-dev
RUN apt-get install -y liblapack-dev
RUN apt-get install -y zlib1g-dev zlib1g

# Preinstall python packages
RUN pip3 install numpy
RUN pip3 install scipy
RUN pip3 install sklearn
RUN pip3 install pandas

#RUN apt-get install -y llvm-11
#RUN pip3 install llvmlite

#RUN pip3 install numba==0.50.1
#RUN apt-get install conda-package-handling
#RUN conda install -c numba llvmdev
RUN pip3 install numba

RUN pip3 install umap-learn


# Everything after this will get rerun even if the commands haven't changed, since data could change
WORKDIR /app
COPY . .

# Make sure deps are pre-installed
RUN clojure -e "(clojure.core/println :deps-downloaded)"


# Systems go
CMD clojure -m nrepl.cmdline --middleware "[cider.nrepl/cider-middleware]" --port 9876


