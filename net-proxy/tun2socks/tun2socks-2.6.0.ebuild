# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="tun2socks - powered by gVisor TCP/IP stack "
HOMEPAGE="https://github.com/xjasonlyu/tun2socks"
SRC_URI="https://github.com/xjasonlyu/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/pasha132/x-local-overlay-vendored/releases/download/v0.0.0/${PN}-${PV}-vendor.tar.xz -> ${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${PV}"

LICENSE="BSD BSD-2 MIT Apache-2.0 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="debug"
RESTRICT="mirror"

RDEPEND=""
BDEPEND="
	>=dev-lang/go-1.25.0
"

DOCS=( README.md )

src_compile() {
	local -a my_ldflags=(
		"-X github.com/xjasonlyu/tun2socks/v2/internal/version.Version=v${PVR}-gentoo"
		"-X github.com/xjasonlyu/tun2socks/v2/internal/version.GitCommit="
	)
	use debug || my_ldflags+=( -s -w )

	ego build -mod vendor -o ${PN} -ldflags "${my_ldflags[*]}"
}

src_test() {
	ego test
}

src_install() {
	einstalldocs

	dobin ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	keepdir /var/log/"${PN}"
}
