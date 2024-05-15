FROM --platform=$BUILDPLATFORM alpine:3.19.1

ARG VCS_REF
ARG BUILD_DATE
ARG TARGETARCH

# Metadata
LABEL maintainer="Reingold Shekhtel <Reingold_Shekhtel@epam.com>" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/groundnuty/k8s-wait-for" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

ENV KUBE_LATEST_VERSION="1.30.1"

RUN apk add --update --no-cache ca-certificates curl jq \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/$TARGETARCH/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Replace for non-root version
ADD wait_for.sh /usr/local/bin/wait_for.sh

ENTRYPOINT ["wait_for.sh"]
