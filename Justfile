# just is a handy way to save and run project-specific commands.
#
# https://github.com/casey/just

set dotenv-load := true

default:
  just --list

# Docker Compose commands
dc TARGET *ARGS:
  docker-compose -f docker-compose.{{TARGET}}.yaml {{ARGS}}

# Plex Meta Manager
plex-meta-manager:
  docker run -it -v ${APP_CONF}/plex-meta-manager:/config:rw meisnate12/plex-meta-manager --run

# Formatting
fmt:
  treefmt
