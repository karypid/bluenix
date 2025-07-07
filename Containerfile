# Allow build scripts to be referenced without being copied into the final image
ARG UBRAND=bluefin
ARG UFLAVOR=
ARG USTREAM=latest

# ARG SOURCE_IMAGE=${UBRAND}${UFLAVOR:+-}${UFLAVOR}:${USTREAM}
ARG SOURCE_IMAGE=${UBRAND}${UFLAVOR}:${USTREAM}

FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/${SOURCE_IMAGE} AS base

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint

