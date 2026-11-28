FROM public.ecr.aws/lambda/ruby:4.0.2026.11.24.13 AS build

# The build stage also installs node and the tree-sitter CLI, for grammars that
# don't commit their parser.c (marked `generate: true` in grammars.yml). The
# runtime stage doesn't get them. Node 20 or later is needed, because ABAP's
# grammar.js uses a recursive fs.readdirSync (the default nodejs is 18).
RUN dnf install gcc git nodejs22 nodejs22-npm -y && \
    npm install -g tree-sitter-cli@0.25.10

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

FROM public.ecr.aws/lambda/ruby:4.0.2026.11.24.13 AS runtime

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
WORKDIR ${LAMBDA_TASK_ROOT}

COPY --from=build ${LAMBDA_TASK_ROOT}/ ${LAMBDA_TASK_ROOT}/
COPY lib/ lib/

ENV RUBY_YJIT_ENABLE=1

CMD [ "lib/inspector.Inspector.process" ]
