# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-info readme.gentoo-r1

DESCRIPTION="Scripts to support compressed squashfs images"
HOMEPAGE="https://github.com/pasha132/squashfs-init/"

LICENSE="BSD-2"
SLOT="0"
IUSE="split-usr"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pasha132/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/pasha132/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
fi

RDEPEND=">=app-shells/push-2.0
	!<sys-apps/openrc-0.13
	>=sys-block/zram-init-8.0"

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="To use squashfs, activate it in your kernel and add it to default runlevel:
	rc-config add sqaushfs.instance default"

pkg_setup() {
	# Check kernel configuration:
	CONFIG_CHECK=""

	CONFIG_CHECK+="~OVERLAY_FS ~SQUASHFS"
	if [[ -n ${CONFIG_CHECK} ]]; then
		linux-info_pkg_setup
	fi
}

src_install() {
	doinitd openrc/init.d/*
	doconfd openrc/conf.d/*
	dodoc README.md
	readme.gentoo_create_doc
	into $(get_usr)/
}

pkg_postinst() {
	readme.gentoo_print_elog
}

get_usr() {
	use split-usr || echo /usr
}
