FROM tensorflow/tensorflow:2.4.1-gpu-jupyter

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    g++ \
    git \
    subversion \
    automake \
    libtool \
    zlib1g-dev \
    libicu-dev \
    libboost-all-dev \
    libbz2-dev \
    liblzma-dev \
    python-dev \
    graphviz \
    imagemagick \
    make \
    cmake \
    libgoogle-perftools-dev \
    autoconf \
    doxygen \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/moses-smt/mosesdecoder

WORKDIR /tf/mosesdecoder

RUN ./bjam -j8

WORKDIR /tf

RUN export export PATH=$PATH:/root/.local/bin

RUN pip install --use-feature=2020-resolver tokenizers transformers[sentencepiece] pandas nltk spacy scikit-learn jax jaxlib==0.1.67+cuda111 -f https://storage.googleapis.com/jax-releases/jax_releases.html

RUN pip install --no-warn-script-location --use-feature=2020-resolver --user -q tensorflow_text 

RUN pip uninstall -y tensorflow==2.4.1