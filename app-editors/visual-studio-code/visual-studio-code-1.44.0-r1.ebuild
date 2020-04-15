# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft"
HOMEPAGE="https://code.visualstudio.com"
SRC_URI="https://update.code.visualstudio.com/${PV}/linux-x64/stable -> ${P}-amd64.tar.gz"

RESTRICT="mirror strip bindist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="global-menu libsecret qt5 +oss"

DEPEND="
	>=media-libs/libpng-1.2.46:0
	>=x11-libs/cairo-1.14.12:0
	>=x11-libs/gtk+-2.24.31-r1:2
	>=x11-libs/libXtst-1.2.3:0
	"

RDEPEND="
	${DEPEND}
	>=net-print/cups-2.1.4:0
	>=x11-libs/libnotify-0.7.7:0
	>=x11-libs/libXScrnSaver-1.2.2-r1:0
	dev-libs/nss
	libsecret? ( app-crypt/libsecret[crypt] )
	global-menu? (
		dev-libs/libdbusmenu
		qt5? (
			dev-libs/libdbusmenu-qt
		)
	)
"

QA_PRESTRIPPED="opt/${PN}/code"
QA_PREBUILT="opt/${PN}/code"

pkg_setup(){
	use amd64 && S="${WORKDIR}/VSCode-linux-x64" || S="${WORKDIR}/VSCode-linux-ia32"
}

src_install(){
	pax-mark m code
	insinto "/opt/${PN}"
	doins -r *
	dosym "/opt/${PN}/bin/code" "/usr/bin/${PN}"
	dosym "/opt/${PN}/bin/code" "/usr/bin/vscode"
	make_desktop_entry "vscode" "Visual Studio Code" "${PN}" "Development;IDE"
	doicon ${FILESDIR}/${PN}.png
	fperms +x "/opt/${PN}/code"
	fperms +x "/opt/${PN}/bin/code"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
	fperms +x "/opt/${PN}/resources/app/extensions/git/dist/askpass.sh"
	insinto "/usr/share/licenses/${PN}"
	newins "resources/app/LICENSE.rtf" "LICENSE"
}

pkg_postinst(){
	elog "You may install some additional utils, so check them in:"
	elog "https://code.visualstudio.com/Docs/setup#_additional-tools"
}