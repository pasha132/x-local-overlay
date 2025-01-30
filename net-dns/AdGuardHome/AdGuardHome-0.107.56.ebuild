# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Privacy protection center for you and your devices"
HOMEPAGE="https://adguard.com/ https://github.com/AdguardTeam/AdGuardHome"
SRC_URI=" https://github.com/AdguardTeam/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/pasha132/x-local-overlay-vendored/releases/download/v0.0.0/AdGuardHome-${PV}-vendor.tar.xz -> ${P}-vendor.tar.xz"
SRC_URI+=" https://github.com/AdguardTeam/${PN}/releases/download/v${PV}/AdGuardHome_frontend.tar.gz -> ${P}-frontend.tar.gz"

S="${WORKDIR}"/AdGuardHome-${PV}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="+webui debug"
RESTRICT="mirror"

RDEPEND=""
BDEPEND="
	>=dev-lang/go-1.21.0
"

DOCS=( CHANGELOG.md README.md )

src_unpack() {
	default

	rm --force --recursive --verbose -- "$S/build"
	mv --force --verbose "${WORKDIR}/build" "$S"
}

src_compile() {
	local -a my_ldflags=(
		"-X github.com/AdguardTeam/AdGuardHome/internal/version.version=v${PVR}-gentoo"
		"-X github.com/AdguardTeam/AdGuardHome/internal/version.channel=release"
		"-X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
		"-X main.commit="
		"-X main.builtBy=portage"
	)
	use debug || my_ldflags+=( -s -w )

	ego build -mod vendor -o ${PN} -ldflags "${my_ldflags[*]}"
}

src_test() {
	ego test
}

src_install() {
	einstalldocs
	newinitd "${FILESDIR}/AdGuardHome.init" AdGuardHome
	
	keepdir /etc/${PN}
	insinto /etc/${PN}
	newins "${FILESDIR}/AdGuardHome.yaml" AdGuardHome.yaml

	keepdir /var/lib/${PN}
	keepdir /var/log/${PN}
	dobin ${PN}
}
