FROM alpine:3.22

RUN apk add --no-cache aws-cli curl jq git bash build-base

ARG TARGETARCH

ARG SOPS_VERSION=3.10.2
ADD https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.${TARGETARCH} /usr/local/bin/sops

ARG KUBECTL_VERSION=1.32.8
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl /usr/local/bin/kubectl

ARG HELM_VERSION=3.18.6
RUN curl -sL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" | tar -xvz --strip 1 "linux-${TARGETARCH}/helm" -C /usr/local/bin/

ARG AWS_IAM_AUTHENTICATOR_VERSION=1.32.8/2025-08-20
ADD https://amazon-eks.s3-us-west-2.amazonaws.com/${AWS_IAM_AUTHENTICATOR_VERSION}/bin/linux/${TARGETARCH}/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

RUN chmod +x /usr/local/bin/*

ENV KUBECONFIG=/kube/kubeconfig

RUN mkdir $(dirname $KUBECONFIG) \
 && touch "$KUBECONFIG"

RUN helm plugin install https://github.com/futuresimple/helm-secrets \
 && helm plugin install https://github.com/hypnoglow/helm-s3.git
