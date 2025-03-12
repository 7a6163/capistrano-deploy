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

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/bash"]
