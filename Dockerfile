FROM public.ecr.aws/lambda/ruby:3.4.2026.11.13.17 AS build

# nodejs and the tree-sitter CLI are for grammars that don't commit their
# parser.c (the ones marked `generate: true` in grammars.yml).
RUN dnf install gcc git nodejs npm -y && \
    npm install -g tree-sitter-cli@0.23.0

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}
COPY Gemfile Gemfile.lock ./
RUN bundle config set deployment 'true' && \
    bundle config set without 'development test' && \
    bundle install

# Compile the pinned tree-sitter grammars, then drop their source
COPY grammars.yml ./
COPY bin/build-grammars bin/
RUN ruby bin/build-grammars && rm -rf grammars/src bin

FROM public.ecr.aws/lambda/ruby:3.4.2026.11.13.17 AS runtime

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=build ${LAMBDA_TASK_ROOT}/ ${LAMBDA_TASK_ROOT}/
COPY lib/ lib/

CMD [ "lib/representer.Representer.process" ]
