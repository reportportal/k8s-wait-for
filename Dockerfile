FROM alpine:3.19.1

ARG BUILD_DATE
ARG TARGETOS
ARG TARGETARCH

# Metadata
LABEL maintainer="Reingold Shekhtel <Reingold_Shekhtel@epam.com>" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

RUN apk add --update --no-cache ca-certificates curl jq \
    && K8S_VERSION=$(curl -L -s "https://dl.k8s.io/release/stable.txt") \
    && echo "K8S_VERSION: $K8S_VERSION" \
    && curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl" \
    && chmod +x kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && /usr/local/bin/kubectl version --client

ENV USER=docker
ENV UID=1100
ENV GID=1100

RUN addgroup -g $GID $USER && \
    adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

USER $UID

ADD --chown=$UID:$GID wait_for.sh /usr/local/bin/wait_for.sh
RUN chmod +x /usr/local/bin/wait_for.sh

ENTRYPOINT ["wait_for.sh"]
