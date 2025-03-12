FROM ruby:3.3-alpine AS builder

RUN apk add --no-cache build-base git

WORKDIR /app

RUN gem install bundler

COPY Gemfile Gemfile.lock /app/
RUN bundle install -j4 && \
    bundle clean --force

FROM ruby:3.3-alpine

RUN apk add --no-cache bash openssh-client git tini

WORKDIR /app

RUN gem install bundler

COPY --from=builder /usr/local/bundle /usr/local/bundle

RUN mkdir -p /root/.ssh/ && \
    echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > /root/.ssh/config

RUN echo '#!/bin/bash\n\
    eval $(ssh-agent -s)\n\
    exec "$@"' > /entrypoint.sh && \
        chmod +x /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
CMD ["/bin/bash"]
