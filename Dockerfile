FROM node:20-buster

LABEL version="0.0.2"
LABEL repository="https://github.com/driphireweb/zapier-action"
LABEL homepage="https://github.com/driphireweb/zapier-action"
LABEL maintainer="Fullbound <jeff@fullbound.ai>"

LABEL com.github.actions.name="GitHub Action for Zapier"
LABEL com.github.actions.description="Wraps the zapier-platform-cli CLI to enable common commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="gray-dark"

RUN apt-get update && apt-get install -y \
  software-properties-common \
  jq \
  git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g npm@latest
RUN npm install -g zapier-platform-cli@latest

COPY LICENSE README.md /
COPY entrypoint.sh /

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]