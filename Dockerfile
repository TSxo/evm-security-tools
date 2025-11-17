FROM ubuntu:24.04

# ------------------------------------------------------------------------------
# Install Dependencies and Common Tools

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    curl \
    git \
    default-jre \
    just \
    jq \
    python3 \
    python3-venv \
    python3-pip \
    sudo \
    tree \
    z3 \
    cvc5 \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# Args

ARG HEVM_VERSION="0.56.0"
ARG HEVM_SHA="aabc7570a987bb87f1f2628ea80e284ce251ce444f36940933a1d47151d5bf09"
ARG HEVM_URL="https://github.com/argotorg/hevm/releases/download/release%2F${HEVM_VERSION}/hevm-x86_64-linux"

ARG FOUNDRY_VERSION="v1.4.4"
ARG FOUNDRY_SHA="c7bd330ede9bc77534db8f99529d80e14ebc80bf3b778762ae3ce92a8997caa6"
ARG FOUNDRY_URL="https://raw.githubusercontent.com/foundry-rs/foundry/${FOUNDRY_VERSION}/foundryup/install"

ARG N_VERSION="v10.2.0"
ARG N_URL="https://raw.githubusercontent.com/tj/n/${N_VERSION}/bin/n"
ARG N_SHA="e4f5baa2e912d3a39b50d9f617de03acf2b4eeb3590f0a4181123f8393da1a19"

# ------------------------------------------------------------------------------
# Install Node and Yarn

RUN curl -fsSL "$N_URL" -o n && \
    echo "$N_SHA  n" | sha256sum -c - && \
    bash n install --cleanup lts && rm n && \
    npm install -g n yarn

# ------------------------------------------------------------------------------
# Add a Non-Root User

RUN useradd -m main && \
    usermod -aG sudo main && \
    echo 'main ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER main
WORKDIR /home/main

ENV HOME="/home/main"
ENV LOCAL_BIN="$HOME/.local/bin"
ENV FOUNDRY_BIN="$HOME/.foundry/bin"
ENV PY_TOOLS_BIN="$HOME/.pytools/bin"
ENV COMPLETIONS="$HOME/.local/share/bash-completion/completions"
ENV PATH="$PATH:$LOCAL_BIN:$FOUNDRY_BIN:$PY_TOOLS_BIN"

# ------------------------------------------------------------------------------
# Install Foundry

RUN curl -fsSL "$FOUNDRY_URL" -o install && \
    echo "$FOUNDRY_SHA  install" | sha256sum -c - && \
    SHELL=/bin/bash bash install && rm install && \
    foundryup && \
    mkdir -p $COMPLETIONS && \
    for i in forge anvil cast; do "$i" completions bash > "$COMPLETIONS/$i"; done

# ------------------------------------------------------------------------------
# Install HEVM

RUN curl -fsSL "$HEVM_URL" -o hevm && \
    echo "$HEVM_SHA  hevm" | sha256sum -c - && \
    mkdir -p "$LOCAL_BIN" && \
    mv hevm "$LOCAL_BIN/hevm" && \
    chmod 755 "$LOCAL_BIN/hevm"

# ------------------------------------------------------------------------------
# Install Python Tools

RUN python3 -m venv $HOME/.pytools && \
    $PY_TOOLS_BIN/pip3 install slither-analyzer solc-select vyper certora-cli

RUN solc-select install 0.6.12 0.7.6 0.8.20 latest && solc-select use latest

# ------------------------------------------------------------------------------
# Bash Message

COPY --link --chown=root:root bash_message /etc/bash_message
RUN echo '\ncat /etc/bash_message\n' >> ~/.bashrc

# ------------------------------------------------------------------------------
# Create Workspace

WORKDIR /workspace

# ------------------------------------------------------------------------------
# Command

CMD ["/bin/bash"]
