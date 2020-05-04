FROM alpine:3.11

RUN apk add --no-cache py3-pip curl jq git bash build-base

RUN pip3 install awscli yq

ARG SOPS_VERSION=3.5.0
ADD https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux /usr/local/bin/sops

ARG KUBECTL_VERSION=1.18.2
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl

ARG HELM_VERSION=3.2.0
RUN curl -s https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xvz --strip 1 linux-amd64/helm -C /usr/local/bin/

ARG AWS_IAM_AUTHENTICATOR_VERSION=1.16.8/2020-04-16
ADD https://amazon-eks.s3-us-west-2.amazonaws.com/${AWS_IAM_AUTHENTICATOR_VERSION}/bin/linux/amd64/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

RUN chmod +x /usr/local/bin/*

ENV KUBECONFIG=/kube/kubeconfig

RUN mkdir $(dirname $KUBECONFIG) \
 && touch "$KUBECONFIG"

RUN helm plugin install https://github.com/futuresimple/helm-secrets \
 && helm plugin install https://github.com/hypnoglow/helm-s3.git
