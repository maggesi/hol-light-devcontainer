# -----------------------------------------------------------------------------
# Starting configuration
# -----------------------------------------------------------------------------

ARG VARIANT=1.0-debian-12

FROM mcr.microsoft.com/devcontainers/base:${VARIANT} AS base

ARG USER=vscode
ARG HOME="/home/${USER}"

USER vscode
WORKDIR "$HOME"

# Serve?
COPY --chown="${USER}" wsl.conf "/etc/wsl.conf"

# -----------------------------------------------------------------------------
# Install Opam.
# -----------------------------------------------------------------------------

RUN sudo apt update \
 && sudo apt -y install --no-install-recommends opam \
 && opam init -a --bare --disable-sandboxing \
 && opam update

# -----------------------------------------------------------------------------
# Install HOL Light
# -----------------------------------------------------------------------------

# Version 2025-04-12
ARG HOL_LIGHT_VERSION=a807444b0041dcc429ade7994149b4ee89f55481
ARG HOLLIGHT_DIR="${HOME}/hol-light"

RUN git clone https://github.com/jrh13/hol-light.git \
 && cd hol-light \
 && git checkout "${HOL_LIGHT_VERSION}" \
 # Patch with scripts for checkpointing.  Needs to configure git first.
 && git config --global user.email "marco.maggesi@gmail.com" \
 && git config --global user.name  "Marco Maggesi" \
 && git pull --rebase https://github.com/aqjune-aws/hol-light.git ckpt2 \
 # Packages m4, xdot required by camlp5.
 && sudo apt -y install --no-install-recommends m4 xdot \
 # Install switch for OCaml 5.x
 && make switch-5 \
 # Packages libgmp-dev, pkg-config required by zarith.
 && sudo apt -y install --no-install-recommends libgmp-dev pkg-config \
 && opam install -y zarith ledit \
 && eval $(opam env) \
 && make

# Install additional software: CSDP, Minisat, Cadical.
RUN sudo apt -y install --no-install-recommends \
  coinor-csdp \
  cadical \
  minisat

# Copy startup scripts.
COPY --chown="${USER}" start.ml "${HOLLIGHT_DIR}/start.ml"
COPY --chown="${USER}" --chmod=0755 load-hol-light "${HOME}/.local/bin/load-hol-light"

# -----------------------------------------------------------------------------
# Install DMTCP for checkpointing.
# -----------------------------------------------------------------------------

# Version 2024-08-13
# ARG DMTCP_VERSION=fdca80f5f71bf4d3f88bfdc4bff0e5e9716754bb
# Version 2025-04-11
ARG DMTCP_VERSION=a36792cdc28a7879743bbf2bd95a2fe1d344557d
ARG BUILD_DIR=${HOME}/src

RUN mkdir -p ${BUILD_DIR}/dmtcp \
 && cd ${BUILD_DIR}/dmtcp \
 && curl -sL https://github.com/dmtcp/dmtcp/archive/$DMTCP_VERSION.tar.gz | \
    tar xz --strip-components=1 \
 && ./configure --prefix=/usr/local && make -j 2 \
 && sudo make install \
 && rm -rf ${BUILD_DIR}/dmtcp \
 && rmdir ${BUILD_DIR}

# # Warning: This is overwritten in devcontainer.json.
# ARG DMTCP_CHECKPOINT_DIR=${HOME}/checkpoints
# RUN mkdir -p ${DMTCP_CHECKPOINT_DIR}

# -----------------------------------------------------------------------------
# Install selfie for checkpointing.
# -----------------------------------------------------------------------------

RUN cd "${HOLLIGHT_DIR}" \
 && git clone git://c9x.me/selfie.git \
 && cd selfie \
 && eval $(opam env) \
 && make \
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

# Copy checkpointing scripts and other files.
COPY --chown="${USER}" --chmod=0755 restart-ocaml-checkpoint.sh "${HOME}/.local/bin/restart-ocaml-checkpoint.sh"
COPY --chown="${USER}" --chmod=0755 hol-light "${HOME}/.local/bin/hol-light"
COPY --chown="${USER}" --chmod=0755 hol-light-core "${HOME}/.local/bin/hol-light-core"
COPY --chown="${USER}" --chmod=0755 hol-light-card "${HOME}/.local/bin/hol-light-card"
COPY --chown="${USER}" --chmod=0755 hol-light-multivariate "${HOME}/.local/bin/hol-light-multivariate"
COPY --chown="${USER}" --chmod=0755 hol-light-complex "${HOME}/.local/bin/hol-light-complex"

# -----------------------------------------------------------------------------
# Install Z3.
# -----------------------------------------------------------------------------

RUN sudo apt install -y --no-install-recommends python3-distutils \
 && cd "${HOLLIGHT_DIR}" \
 && eval $(opam env) \
 && opam install -y z3
