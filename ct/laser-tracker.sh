#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/MakaiView/ProxmoxScripts/main/misc/build.func)
# Copyright (c) 2024-2026 Makai View Media
# Author: MakaiView (Steve Robinson)
# License: MIT
# Source: https://github.com/MakaiView/LaserSettingsManager

APP="Laser Settings Tracker"
var_tags="${var_tags:-laser;maker}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-1024}"
var_disk="${var_disk:-8}"
var_os="${var_os:-ubuntu}"
var_version="${var_version:-22.04}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -d /opt/laser-tracker ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  CURRENT=$(cat /opt/laser-tracker_version.txt 2>/dev/null || echo "none")
  LATEST=$(curl -fsSL "https://api.github.com/repos/MakaiView/LaserSettingsManager/commits/master" \
    | grep '"sha"' | head -1 | cut -d'"' -f4 | head -c7 || echo "unknown")

  if [[ "$CURRENT" == "$LATEST" ]]; then
    msg_ok "Already up to date — commit ${CURRENT}"
    exit
  fi

  msg_info "Stopping ${APP}"
  systemctl stop laser-tracker
  msg_ok "Stopped ${APP}"

  msg_info "Updating ${APP}"
  $STD git -C /opt/laser-tracker pull origin master
  $STD npm install --production --prefix /opt/laser-tracker/app
  echo "$LATEST" >/opt/laser-tracker_version.txt
  msg_ok "Updated ${APP} to ${LATEST}"

  msg_info "Starting ${APP}"
  systemctl start laser-tracker
  msg_ok "Started ${APP}"

  msg_ok "Updated Successfully"
  exit
}

start
build_container
description
