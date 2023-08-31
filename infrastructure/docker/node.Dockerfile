FROM node:alpine3.17

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# versions of local tools
RUN echo "node version:   $(node -v)\n"
RUN echo "npm version:    $(npm -v)\n"
RUN echo "yarn version:   $(yarn -v)\n"
RUN echo "debian version: $(cat /etc/debian_version)\n"
RUN echo "user:           $(whoami)\n"
