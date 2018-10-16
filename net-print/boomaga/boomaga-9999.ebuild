# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
LANGS="cs de el fr hu_HU it lt nb_NO nl_NL pl_PL ro ru uz@Latn"
inherit cmake-utils git-r3

DESCRIPTION="Boomaga provides a virtual printer for CUPS. This can be used for print preview or for print booklets."
HOMEPAGE="http://www.boomaga.org/"
EGIT_REPO_URI="https://github.com/Boomaga/boomaga.git"


LICENSE="GPL-3"
SLOT="0/31"
KEYWORDS=""
IUSE="qt4 +qt5 X"
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

REQUIRED_USE="
	qt4? ( X )
	qt5? ( X )
	qt4? ( !qt5 )
"

RDEPEND="
	net-print/cups
	app-arch/snappy
	!qt5? ( qt4? (
		>=dev-qt/qtcore-4.8:4
		>=dev-qt/qtgui-4.8:4
		app-text/poppler[qt4]
	) )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtdbus:5
		app-text/poppler[qt5]
	)
"
DEPEND="${RDEPEND}"

#DOCS="AUTHORS CHANGELOG README TRANSLATORS"

pkg_setup() {
	if ! ( use qt4 || use qt5 )
	then
		ewarn "You should enable at least one of the following USE flags:"
		ewarn "qt4 qt5"
	fi
}

src_unpack() {
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	cd ${S}
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

	cmake-utils_src_configure
}
