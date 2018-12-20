#!/usr/bin/env bash
#
# Post-installation Configuration Scripts
#
# First stage script for Kimsufi
#

#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1

# OVH dedicated servers are expected to run this script as "script"
EXPECT_SCRIPT_PATH="/tmp/script"

# Log files
LOG_FILE="/home/root/postinstall.log"
ERROR_FILE="/home/root/postinstall_error.log"
exec 1>$LOG_FILE
exec 2>$ERROR_FILE


# Remote scripts URI root
URI_ROOT="https://raw.githubusercontent.com/Khalshim/post-install-script/master/"

# Error codes
ERR_OK=0
ERR_KO=1

exec_remote () {
  # 'raw.githubusercontent.com' domain may not clear HTTPS CA checks
  bash <(wget --no-check-certificate -O - $URI_ROOT$1)
  return $?
}

cfg_debian () {
	
  apt-get --assume-yes install wget

  exec_remote "scripts/install_basic_packages"
  exec_remote "scripts/install_docker"
  exec_remote "scripts/cfg_users_skel"
  exec_remote "scripts/add_user khalshim"
  su khalshim
  exec_remote "scripts/install_dstserver dst_serv"
}

main () {
	cfg_debian
}


main
