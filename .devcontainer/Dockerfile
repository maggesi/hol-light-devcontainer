# -----------------------------------------------------------------------------
# Starting configuration
# -----------------------------------------------------------------------------

ARG VARIANT=debian-11
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
 && apt-get -y install --no-install-recommends \
      build-essential git curl make m4 rlwrap screen tmux opam

USER vscode

# -----------------------------------------------------------------------------
# Install Opam, OCaml and the necessary tools.
# -----------------------------------------------------------------------------

# RUN opam init -a --disable-sandboxing \
#  && opam switch create 4.05.0 ocaml-base-compiler.4.05.0
# With 4.07 one gets Segmentation fault loading update_database.ml
RUN opam init -a --disable-sandboxing -c ocaml-base-compiler.4.05.0

# NB: merlin do not compile in 4.07.0 but compiles with 4.07.1
RUN eval $(opam env) \
 && opam pin add -y camlp5 7.10 \
 && opam install -y num camlp5 merlin

# -----------------------------------------------------------------------------
# Install DMTCP
# -----------------------------------------------------------------------------

ARG HOME=/home/vscode
ARG BUILD_DIR=${HOME}/src
# Version 2022-08-22  (help do not work)
# ARG DMTCP_VERSION=7136b64d828344ce1e137a6fc9b493ac6ee7d17d
# Version 2022-08-26  (help do not work)
# ARG DMTCP_VERSION=93c6eeb620d1184cddfc21e9c9ce704ece15c05d
# Version 2020-12-11 Segmentation fault while loading GL
# ARG DMTCP_VERSION=990c74b7aec3b52d440f9e19f0f39f149643bc1a
# Version 2022-03-01
ARG DMTCP_VERSION=133687764c6742906006a1d247e3b83cd860fa1d
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
# Install HOL Light
# -----------------------------------------------------------------------------

# Version 2022-08-01
ARG HOL_LIGHT_VERSION=8822aa45052e2ec5f9608e79aa3ec7bc84abedf8
ARG HOL_LIGHT_ARCHIVE=https://github.com/jrh13/hol-light/archive/${HOL_LIGHT_VERSION}.tar.gz
ARG HOLLIGHT_DIR=${HOME}/hol-light

RUN mkdir -p "${HOLLIGHT_DIR}" \
 && cd "${HOLLIGHT_DIR}" \
 && curl -sL "${HOL_LIGHT_ARCHIVE}" | tar xz --strip-components=1 \
 && eval $(opam env) \
 && make

COPY --chown=vscode start.ml "${HOLLIGHT_DIR}/start.ml"
COPY --chown=vscode --chmod=0755 load-hol-light "${HOME}/.local/bin/load-hol-light"
COPY --chown=vscode --chmod=0755 restart-ocaml-checkpoint.sh "${HOME}/.local/bin/restart-ocaml-checkpoint.sh"
COPY --chown=vscode --chmod=0755 hol-light "${HOME}/.local/bin/hol-light"
COPY --chown=vscode --chmod=0755 hol-light-core "${HOME}/.local/bin/hol-light-core"
COPY --chown=vscode --chmod=0755 hol-light-card "${HOME}/.local/bin/hol-light-card"
COPY --chown=vscode --chmod=0755 hol-light-multivariate "${HOME}/.local/bin/hol-light-multivariate"
COPY --chown=vscode --chmod=0755 hol-light-complex "${HOME}/.local/bin/hol-light-complex"
