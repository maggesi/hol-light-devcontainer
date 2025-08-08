# -----------------------------------------------------------------------------
# Starting configuration
# -----------------------------------------------------------------------------

ARG VARIANT=1.0-debian-12

FROM mcr.microsoft.com/devcontainers/base:${VARIANT} AS base

ARG USER=vscode
ARG HOME="/home/${USER}"

USER vscode
WORKDIR "$HOME"

# Configuration for then Windows Subsystem for Linux.
COPY --chown="${USER}" wsl.conf "/etc/wsl.conf"

# -----------------------------------------------------------------------------
# Install Opam.
# -----------------------------------------------------------------------------

RUN sudo apt update \
 && sudo apt -y install --no-install-recommends opam \
 && opam init -a --bare --disable-sandboxing \
 && opam update

# -----------------------------------------------------------------------------
# Install system-level dependecies and additional software.
# -----------------------------------------------------------------------------

RUN sudo apt -y install --no-install-recommends \
  # Packages m4, xdot required by camlp5.
  m4 xdot \
  # Packages libgmp-dev, pkg-config required by zarith.
  libgmp-dev pkg-config \
  # Additional software: CSDP, Minisat, Cadical.
  coinor-csdp cadical minisat

# -----------------------------------------------------------------------------
# Install DMTCP for checkpointing.
# -----------------------------------------------------------------------------

# Version 2025-04-11
# ARG DMTCP_VERSION=a36792cdc28a7879743bbf2bd95a2fe1d344557d
# Version 2025-07-07
ARG DMTCP_VERSION=b7fab641fbd62ed3de3ebc27fe3c24d3f0f0a680
ARG BUILD_DIR=${HOME}/src

RUN mkdir -p ${BUILD_DIR}/dmtcp \
 && cd ${BUILD_DIR}/dmtcp \
 && curl -sL https://github.com/dmtcp/dmtcp/archive/$DMTCP_VERSION.tar.gz | \
    tar xz --strip-components=1 \
 && ./configure --prefix=/usr/local && make -j 2 \
 && sudo make install \
 && rm -rf ${BUILD_DIR}/dmtcp \
 && rmdir ${BUILD_DIR}

# -----------------------------------------------------------------------------
# Install HOL Light
# -----------------------------------------------------------------------------

# Version 2025-06-19
# ARG HOL_LIGHT_VERSION=37af947830f04a0dbd68b141b8148b63ae7c313c
ARG HOL_LIGHT_VERSION=2025-07-16
ARG HOL_LIGHT_VERSION=157c99b7bb3a485116dc2bfc4ef3ad00912d883b
ENV HOLLIGHT_DIR="${HOME}/hol-light" 

RUN git clone https://github.com/jrh13/hol-light.git

WORKDIR $HOLLIGHT_DIR

RUN git checkout "${HOL_LIGHT_VERSION}" \
 && git tag Version-2025-07-16

# Install switch for OCaml 5.x
RUN make switch-5

RUN eval $(opam env --set-switch) \
 # && opam install -y zarith ledit \
 && make

# Copy startup scripts.
COPY --chown="${USER}" start.ml "${HOLLIGHT_DIR}/start.ml"
COPY --chown="${USER}" --chmod=0755 load-hol-light "${HOME}/.local/bin/load-hol-light"

# -----------------------------------------------------------------------------
# Install selfie for checkpointing.
# NOTE: Do not work with OCaml 5.xx.x at the moment (august 2025).
# -----------------------------------------------------------------------------

# RUN eval $(opam env)
#  && opam install -y selfie

# RUN cd "${HOLLIGHT_DIR}" \
#  && git clone git://c9x.me/selfie.git \
#  && cd selfie \
#  && eval $(opam env) \
#  && make \
#  && make selfie.cma \
#  && cp -a dllcaml_selfie.so selfie.cma selfie.ml ../ \
#  && rm -rf "${HOLLIGHT_DIR}/selfie"

# ARG HOL_SH="${HOLLIGHT_DIR}/hol.sh"
# RUN cd "${HOLLIGHT_DIR}" \
#  && ( echo 'loadt "update_database.ml";;'; \
#       echo '#load "selfie.cma";;'; \
#       echo '#use "selfie.ml";;'; \
#       echo 'snap "hol-light.base.img";;' \
#     ) | $HOL_SH

# -----------------------------------------------------------------------------
# Install Z3.
# -----------------------------------------------------------------------------

# RUN sudo apt install -y --no-install-recommends python3-distutils \
#  && cd "${HOLLIGHT_DIR}" \
#  && eval $(opam env) \
#  && opam install -y z3