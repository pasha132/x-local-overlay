# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
LANGS="ru"

inherit cmake-utils

DESCRIPTION="Quick(Qt) Online Music Player"
HOMEPAGE="http://qomp.sourceforge.net/"
MY_PV="${PV/_beta/-beta}-1"
MY_PF="${PN}_${MY_PV}"
S="${WORKDIR}/${P%%_*}-beta"
SRC_URI="mirror://sourceforge/${PN}/${PV/_beta/}/dev/${MY_PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
PLUGINS=" filesystem url prostopleer myzukaru yandexmusic lastfm tunetofile mpris"
IUSE="${PLUGINS// / +} qt5"
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

RDEPEND="
	>=dev-qt/qtcore-4.8:4
	>=dev-qt/qtgui-4.8:4
	media-libs/phonon[qt4]
	>=dev-libs/qjson-0.8
"
DEPEND="${RDEPEND}"

DOCS="README"

src_prepare() {
	# Force usage of system libraries
	cmake-utils_src_prepare
}

src_configure() {
	# linguas
	local langs="none;" plugins="none;" x
	for x in ${LANGS}; do
		use linguas_${x} && langs+="${x};"
	done

	for x in ${PLUGINS}; do
		use ${x} && plugins+="${x}plugin;"
	done
	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(get_libdir)"
		-DLANGS="${langs}"
		-DPLUGINS="${plugins}"
	)

	cmake-utils_src_configure
}
