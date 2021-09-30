# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="cs de el eu fr hu_HU it lt nb_NO nl_NL pl_PL ro ru uk_UA uz@Latn"
PLOCALE_BACKUP="en"

inherit plocale cmake xdg

MY_PN="boomaga"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A virtual printer for viewing a document before printing it out using the physical printer."
HOMEPAGE="http://www.boomaga.org/"
SRC_URI="https://github.com/boomaga/boomaga/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtnetwork:5
	dev-qt/qtcore:5
	app-text/poppler
	net-print/cups"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	plocale_find_changes "${S}/src/${PN}/translations" "${PN}_" '.ts'
	cmake_src_prepare
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

