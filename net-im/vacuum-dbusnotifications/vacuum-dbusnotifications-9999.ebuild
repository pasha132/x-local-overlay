# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/vacuum/vacuum-9999.ebuild,v 1.14 2015/05/26 16:17:39 mgorny Exp $

EAPI="5"
LANGS="de en pl ru uk"

inherit cmake-utils git-r3

DESCRIPTION="Popup notofications over DBus extension plugin for Vacuum-IM"
HOMEPAGE="http://www.vacuum-im.org/"
EGIT_REPO_URI="https://github.com/Vacuum-IM/dbusnotifications"

LICENSE="GPL-3"
SLOT="0/31"
KEYWORDS=""
IUSE="qt4 +qt5"
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

REQUIRED_USE="
	qt4? ( !qt5 )
"
RDEPEND="
	!qt5? ( qt4? (
		net-im/vacuum[qt4(+),notifications(+),optionsmanager(+)]
	) )
	qt5? (
		dev-qt/qtxml:5
		dev-qt/qtdbus:5
		dev-qt/qtwidgets:5
		net-im/vacuum[qt5(+),notifications(+),optionsmanager(+)]
	)
"
DEPEND="${RDEPEND}"

DOCS="README"

pkg_setup() {
	if ! ( use qt4 || use qt5 )
	then
		ewarn "You should enable at least one of the following USE flags:"
		ewarn "qt4 qt5"
	fi
}

src_prepare() {
	cd ${S}
	epatch "${FILESDIR}"/${P}-plugin.cmake.patch
	epatch "${FILESDIR}"/${P}-CMakeLists.txt.patch
	if use qt5; then
		export QT_SELECT=qt5
	elif use qt4; then
		export QT_SELECT=qt4
	fi
	cmake-utils_src_prepare
}

src_configure() {
	# linguas
	local langs="none;" x
	for x in ${LANGS}; do
		use linguas_${x} && langs+="${x};"
	done

	local mycmakeargs=(
		-DLANGS="${langs}"
		-DVACUUM_SDK_PATH="/usr/include/vacuum"
	)

	cmake-utils_src_configure
}
