# just is a handy way to save and run project-specific commands.
#
# https://github.com/casey/just

# Just settings
set dotenv-load := true

# Variables
PLEX_AGENTS := "${PLEX_PLUGINS}"
PLEX_TRASH_UPDATER := "${APP_CONF}/trash-updater"

PLEX_AGENT_HAMA_URL := "https://github.com/ZeroQI/Hama.bundle/archive/refs/heads/master.zip"
PLEX_AGENT_HAMA_ZIP_OUT := "Hama.bundle-master"
PLEX_AGENT_HAMA_ID := "Hama.bundle"

PLEX_AGENT_COLIMA_URL := "https://github.com/defract/Colima.bundle/archive/refs/heads/master.zip"
PLEX_AGENT_COLIMA_ZIP_OUT := "Colima.bundle-master"
PLEX_AGENT_COLIMA_ID := "Colima.bundle"

PLEX_AGENT_YOUTUBE_URL := "https://github.com/ZeroQI/YouTube-Agent.bundle/archive/refs/heads/master.zip"
PLEX_AGENT_YOUTUBE_ZIP_OUT := "YouTube-Agent.bundle-master"
PLEX_AGENT_YOUTUBE_ID := "YouTube-Agent.bundle"

# Default command
default:
  just --list

# Docker Compose commands
dc TARGET *ARGS:
  docker-compose --profile {{TARGET}} {{ARGS}}

# Utils
alias f := fmt
fmt:
  treefmt

# Plex Agents
fetch-plex-hama:
  wget --no-verbose --show-progress --continue {{PLEX_AGENT_HAMA_URL}} -O {{PLEX_AGENTS}}/hama.zip
  unzip -o -d {{PLEX_AGENTS}} {{PLEX_AGENTS}}/hama.zip
  mv {{PLEX_AGENTS}}/{{PLEX_AGENT_HAMA_ZIP_OUT}} {{PLEX_AGENTS}}/{{PLEX_AGENT_HAMA_ID}}
  rm {{PLEX_AGENTS}}/hama.zip

fetch-plex-colima:
  wget --no-verbose --show-progress --continue {{PLEX_AGENT_COLIMA_URL}} -O {{PLEX_AGENTS}}/colima.zip
  unzip -o -d {{PLEX_AGENTS}} {{PLEX_AGENTS}}/colima.zip
  mv {{PLEX_AGENTS}}/{{PLEX_AGENT_COLIMA_ZIP_OUT}} {{PLEX_AGENTS}}/{{PLEX_AGENT_COLIMA_ID}}
  rm {{PLEX_AGENTS}}/colima.zip

fetch-plex-youtube:
  wget --no-verbose --show-progress --continue {{PLEX_AGENT_YOUTUBE_URL}} -O {{PLEX_AGENTS}}/youtube.zip
  unzip -o -d {{PLEX_AGENTS}} {{PLEX_AGENTS}}/youtube.zip
  mv {{PLEX_AGENTS}}/{{PLEX_AGENT_YOUTUBE_ZIP_OUT}} {{PLEX_AGENTS}}/{{PLEX_AGENT_YOUTUBE_ID}}
  rm {{PLEX_AGENTS}}/youtube.zip

fetch-plex-plugins: fetch-plex-hama fetch-plex-colima fetch-plex-youtube

# Plex Meta Manager
alias meta-manager := plex-meta-manager
plex-meta-manager:
  docker run -it -v ${APP_CONF}/plex-meta-manager:/config:rw meisnate12/plex-meta-manager --run

# Plex Trash Updater (Temporal solution until nixified package works)
PLEX_TRASH_UPDATER_URL := "https://github.com/rcdailey/trash-updater/releases/latest/download/trash-linux-x64.zip"

fetch-plex-trash-updater:
  wget --no-verbose --show-progress --continue {{PLEX_TRASH_UPDATER_URL}} -O {{PLEX_TRASH_UPDATER}}/trash.zip
  unzip -o -d {{PLEX_TRASH_UPDATER}} {{PLEX_TRASH_UPDATER}}/trash.zip
  rm {{PLEX_TRASH_UPDATER}}/trash.zip
  chmod u+rx {{PLEX_TRASH_UPDATER}}/trash

alias trash := plex-trash
plex-trash *ARGS:
  {{PLEX_TRASH_UPDATER}}/trash {{ARGS}}
