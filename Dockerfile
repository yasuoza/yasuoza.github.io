FROM codercom/code-server:3.11.0

# Must be set as environment variable
ENV CODESERVER_PASSWORD='password'

ARG HUGO=0.78.0

COPY docker/git-credential-github-token /usr/local/bin
RUN git config --global credential.helper github-token && \
    sudo chmod +x /usr/local/bin/git-credential-github-token

COPY docker/code-server.yml /home/coder/.config/code-server/config.yaml
RUN sudo chown -R coder:coder /home/coder/.config

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sudo chmod +x /usr/local/bin/entrypoint.sh

RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    sudo apt-get install -y nodejs && \
    sudo npm install -g yarn

RUN mkdir -p /tmp/hugo && \
    curl -sSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_extended_${HUGO}_Linux-64bit.tar.gz" | tar zx -C /tmp/hugo && \
    sudo cp /tmp/hugo/hugo /usr/local/bin/ && \
    rm -rf /tmp/hugo
EXPOSE 1313

USER coder
WORKDIR /home/coder
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/code-server", "--bind-addr", "0.0.0.0:8080", "."]
EXPOSE 8080
