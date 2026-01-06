# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Xray, Penetrates Everything"
HOMEPAGE="https://xtls.github.io https://github.com/XTLS/Xray-core"
SRC_URI="https://github.com/XTLS/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/pasha132/x-local-overlay-vendored/releases/download/v0.0.0/${PN}-${PV}-vendor.tar.xz -> ${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${PV}"
MY_PN="xray"

LICENSE="BSD BSD-2 MIT Apache-2.0 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="debug"
RESTRICT="mirror"

RDEPEND="
	acct-group/xray
	acct-user/xray
"
BDEPEND="
	>=dev-lang/go-1.25.0
"

DOCS=( README.md )

src_compile() {
	local -a my_gcflags=(
		"all=-l=4"
	)
	local -a my_ldflags=(
		"-X github.com/xtls/xray-core/core.build=v${PVR}-gentoo"
	)
	use debug || my_ldflags+=( -s -w )

	ego build -mod vendor -o "${MY_PN}" -gcflags="${my_gcflags[*]}" -ldflags "${my_ldflags[*]}" ./main
}

src_test() {
	ego test
}

src_install() {
	einstalldocs

	dobin "${MY_PN}"
	newconfd "${FILESDIR}"/${MY_PN}.confd ${MY_PN}
	newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}

	newins "${FILESDIR}"/${MY_PN}.logrotate ${MY_PN}

	keepdir /etc/"${MY_PN}"
	keepdir /var/log/"${MY_PN}"
}
