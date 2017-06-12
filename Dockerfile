FROM elixir:1.4.4

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN mix local.hex --force \
      && mix local.rebar --force

ADD . /app
