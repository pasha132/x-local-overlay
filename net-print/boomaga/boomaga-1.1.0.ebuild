# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN}
PLOCALES="cs de el eu fr hu_HU it lt nb_NO nl_NL pl_PL ro ru uz@Latn"
inherit cmake-utils l10n

DESCRIPTION="Boomaga provides a virtual printer for CUPS. This can be used for print preview or for print booklets."
HOMEPAGE="http://www.boomaga.org/"
SRC_URI="https://github.com/Boomaga/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 +qt5 X"

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

DOCS="README.md"

pkg_setup() {
	if ! ( use qt4 || use qt5 )
	then
		ewarn "You should enable at least one of the following USE flags:"
		ewarn "qt4 qt5"
	fi
}

src_prepare() {
	cd ${S}
	if use qt5; then
		export QT_SELECT=qt5
	elif use qt4; then
		export QT_SELECT=qt4
	fi
	l10n_find_plocales_changes "gui/translations" "${PN}_" '.ts'
	cmake-utils_src_prepare
}

src_install() {
	remove_translation() {
		rm "${ED}/usr/share/${PN}/translations/${PN}_${1}.qm" || die "remove '${PN}_${1}.qm' file failed"
	}
	cmake-utils_src_install
	l10n_for_each_disabled_locale_do remove_translation
}

pkg_postinst() {
	elog "You will need to set up your Virtual printer file before"
	elog "running Boomaga for the first time."
	elog "lpadmin -h localhost -p Boomaga_Printer -v boomaga:/ -E \
	-m /usr/share/ppd/boomaga/boomaga.ppd -o printer-is-shared=no -o PageSize=a4"
}
