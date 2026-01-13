# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the system-wide net-proxy/Xray-core proxy"
ACCT_USER_ID=600
ACCT_USER_HOME=/var/lib/xray
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( xray )

acct-user_add_deps
