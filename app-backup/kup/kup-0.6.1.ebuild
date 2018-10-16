# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Kup Backup System"
HOMEPAGE="https://github.com/spersson/Kup"

MY_PN="Kup"
MY_P="${MY_PN}-${P}"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/spersson/${MY_PN}.git"
else
	SRC_URI="https://github.com/spersson/${MY_PN}/archive/${P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
	S=${WORKDIR}/${MY_P}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus debug +X"
REQUIRED_USE="
	dbus? ( X )
"

RDEPEND="
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=(README.md LICENSE MAINTAINER)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-${PV}-CMakeLists.patch"
	epatch "${FILESDIR}/${PN}-${PV}-libgit-fix.patch"

	rm -r libgit2-*
	kde5_src_prepare
}

src_configure() {
	kde5_src_configure
}
