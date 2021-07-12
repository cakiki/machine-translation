FROM tensorflow/tensorflow:2.5.0-gpu-jupyter

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    g++ \
    git \
    openjdk-8-jdk \
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

WORKDIR /

RUN git clone https://github.com/moses-smt/mosesdecoder && git clone https://github.com/moses-smt/mgiza && git clone https://github.com/slavpetrov/berkeleyparser

RUN rm -r /berkeleyparser/.git && cp -r berkeleyparser /tf/berkeleyparser

WORKDIR /mosesdecoder

RUN ./bjam -j4 && rm -r /mosesdecoder/.git && cp -r /mosesdecoder /tf/mosesdecoder && mkdir /tf/mosesdecoder/tools

WORKDIR /mgiza/mgizapp

RUN cmake . && make && make install && rm -r /mgiza/.git && cp -r /mgiza/mgizapp/bin/. /tf/mosesdecoder/tools/ && cp -r /mgiza/mgizapp/scripts/. /tf/mosesdecoder/tools/

WORKDIR /tf

RUN export PATH=$PATH:/root/.local/bin

RUN pip install --use-feature=2020-resolver "jax[cuda111]" -f https://storage.googleapis.com/jax-releases/jax_releases.html flax tensorflow_hub tensorflow-probability tokenizers transformers[sentencepiece] pandas nltk spacy scikit-learn https://github.com/kpu/kenlm/archive/master.zip

# RUN pip install --no-warn-script-location --use-feature=2020-resolver --user -q tensorflow_text add a check to see which version of tf it installs 

# RUN pip uninstall -y tensorflow==TODETERMINE

CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter notebook --notebook-dir=/tf --ip 0.0.0.0 --no-browser --allow-root"]