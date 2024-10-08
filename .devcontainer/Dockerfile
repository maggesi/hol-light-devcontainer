# -----------------------------------------------------------------------------
# Starting configuration
# -----------------------------------------------------------------------------

# Warning: This is overwritten in devcontainer.json.
ARG VARIANT=1.0.15-debian-12

FROM mcr.microsoft.com/devcontainers/base:${VARIANT}

# Serve?
COPY --chown=vscode wsl.conf "/etc/wsl.conf"

# -----------------------------------------------------------------------------
# Install OCaml and the basic tools.
# -----------------------------------------------------------------------------

RUN apt update \
 && apt -y install --no-install-recommends \
      git curl m4 xdot libgmp-dev pkg-config opam
      # git curl ocaml-core camlp5 libnum-ocaml-dev ledit

USER vscode

RUN opam init -a --bare --disable-sandboxing \
 && opam update

# -----------------------------------------------------------------------------
# Install HOL Light
# -----------------------------------------------------------------------------

# Version 2022-09-15
# ARG HOL_LIGHT_VERSION=9c07c4f5a7b046e01a355e7612c5fe7582f4da91
# Version 2024-08-08
# ARG HOL_LIGHT_VERSION=016d22698294583153a0d9ff625d0b0cf44ee9d1
# Version 2024-08-08
# ARG HOL_LIGHT_VERSION=016d22698294583153a0d9ff625d0b0cf44ee9d1

# Version 2024-08-08
ARG HOL_LIGHT_VERSION=282fc370a33c3e5900dd2789bd53dd2a3bf138ad
ARG HOME=/home/vscode
ARG HOL_LIGHT_ARCHIVE="https://github.com/jrh13/hol-light/archive/${HOL_LIGHT_VERSION}.tar.gz"

# Warning: This is overwritten in devcontainer.json.
ARG HOLLIGHT_DIR="${HOME}/hol-light"

RUN mkdir -p "${HOLLIGHT_DIR}" \
 && cd "${HOLLIGHT_DIR}" \
 && curl -sL "${HOL_LIGHT_ARCHIVE}" | tar xz --strip-components=1

RUN cd "${HOLLIGHT_DIR}" \
 && make switch

RUN cd "${HOLLIGHT_DIR}" \
 && eval $(opam env) ; make

# -----------------------------------------------------------------------------
# Install selfie for checkpointing.
# -----------------------------------------------------------------------------

RUN cd "${HOLLIGHT_DIR}" \
 && git clone git://c9x.me/selfie.git \
 && cd selfie \
 && eval $(opam env) ; make \
 && make selfie.cma \
 && cp -a dllcaml_selfie.so selfie.cma selfie.ml ../ \
 && rm -rf "${HOLLIGHT_DIR}/selfie"

# # ARG HOL_SH="${HOLLIGHT_DIR}/hol.sh"
# # RUN cd "${HOLLIGHT_DIR}" \
# #  && ( echo 'loadt "update_database.ml";;'; \
# #       echo '#load "selfie.cma";;'; \
# #       echo '#use "selfie.ml";;'; \
# #       echo 'snap "hol-light.base.img";;' \
# #     ) | $HOL_SH

# -----------------------------------------------------------------------------
# Install DMTCP
# -----------------------------------------------------------------------------

# Version 2022-03-01
# ARG DMTCP_VERSION=133687764c6742906006a1d247e3b83cd860fa1d
# Version 2024-08-13
ARG DMTCP_VERSION=fdca80f5f71bf4d3f88bfdc4bff0e5e9716754bb
ARG BUILD_DIR=${HOME}/src

# Warning: This is overwritten in devcontainer.json.
ARG DMTCP_CHECKPOINT_DIR=${HOME}/checkpoints

RUN mkdir -p ${BUILD_DIR}/dmtcp \
 && cd ${BUILD_DIR}/dmtcp \
 && curl -sL https://github.com/dmtcp/dmtcp/archive/$DMTCP_VERSION.tar.gz | \
    tar xz --strip-components=1 \
 && ./configure --prefix=/usr/local && make -j 2 \
 && sudo make install \
 && rm -rf ${BUILD_DIR}/dmtcp \
 && rmdir ${BUILD_DIR} \
 && mkdir -p ${DMTCP_CHECKPOINT_DIR}

# -----------------------------------------------------------------------------
# Install additional software: CSDP, Minisat, Cadical.
# -----------------------------------------------------------------------------

USER root

RUN apt -y install --no-install-recommends \
  coinor-csdp \
  cadical \
  minisat

USER vscode

# RUN git clone https://github.com/coin-or/Csdp.git &&
#     cd Csdp &&
#     apt -y install gfortan libblas-dev liblapack-dev
#     apt -y install ncbi-blast+ &&
#     make

# -----------------------------------------------------------------------------
# Copy scripts and other files.
# -----------------------------------------------------------------------------

COPY --chown=vscode start.ml "${HOLLIGHT_DIR}/start.ml"
COPY --chown=vscode --chmod=0755 load-hol-light "${HOME}/.local/bin/load-hol-light"
COPY --chown=vscode --chmod=0755 restart-ocaml-checkpoint.sh "${HOME}/.local/bin/restart-ocaml-checkpoint.sh"
COPY --chown=vscode --chmod=0755 hol-light "${HOME}/.local/bin/hol-light"
COPY --chown=vscode --chmod=0755 hol-light-core "${HOME}/.local/bin/hol-light-core"
COPY --chown=vscode --chmod=0755 hol-light-card "${HOME}/.local/bin/hol-light-card"
COPY --chown=vscode --chmod=0755 hol-light-multivariate "${HOME}/.local/bin/hol-light-multivariate"
COPY --chown=vscode --chmod=0755 hol-light-complex "${HOME}/.local/bin/hol-light-complex"
