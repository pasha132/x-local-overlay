# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Simple terminal UI for git commands"
HOMEPAGE="https://github.com/jesseduffield/lazygit"
if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jesseduffield/${PN}.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/jesseduffield/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://github.com/pasha132/x-local-overlay-vendored/releases/download/v0.0.0/${PN}-${PV}-vendor.tar.xz -> ${P}-vendor.tar.xz"
fi

S="${WORKDIR}/${PN}-${PV}"

LICENSE="MIT"
# dependency licenses:
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MIT Unlicense "
SLOT="0"
IUSE="debug"
RESTRICT="mirror"

RDEPEND="dev-vcs/git"
BDEPEND="
		>=dev-lang/go-1.25.0
"

DOCS=( {CODE-OF-CONDUCT,CONTRIBUTING,README}.md docs )

src_unpack() {
	if [[ "${PV}" == 9999 ]];then
		git-r3_src_unpack
	else
		default
	fi
}

src_compile() {
	local -a my_ldflags=(
		"-X main.version=v${PVR}-gentoo"
		"-X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
		"-X main.commit="
	)
	use debug || my_ldflags+=( -s -w )

	ego build -mod vendor -o ${PN} -ldflags "${my_ldflags[*]}"

}

src_test() {
	ego test ./... -short
}

src_install() {
	einstalldocs

	dobin ${PN}
}
