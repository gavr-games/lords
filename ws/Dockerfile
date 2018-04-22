FROM elixir:1.6.4

RUN mix local.hex --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez
RUN mix local.rebar --force

WORKDIR /app
COPY . .

EXPOSE 4000

# Initial setup
RUN mix deps.get
# RUN mix deps.get --only prod
# RUN MIX_ENV=prod mix compile