# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Manage your dotfiles across multiple machines, securely"
HOMEPAGE="https://www.chezmoi.io https://github.com/twpayne/chezmoi"
SRC_URI="https://github.com/twpayne/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/pasha132/x-local-overlay-vendored/releases/download/v0.0.0/${PN}-${PV}-vendor.tar.xz -> ${P}-vendor.tar.xz"

S="${WORKDIR}/${PN}-${PV}"

LICENSE="BSD BSD-2 MIT Apache-2.0 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bash-completion debug"
RESTRICT="mirror"

RDEPEND=""
BDEPEND="
	>=dev-lang/go-1.25.7
	bash-completion? (
		>=app-shells/bash-completion-2.0
	)
"

DOCS=( README.md )

src_compile() {
	local -a my_ldflags=(
		"-X main.version=v${PVR}-gentoo"
		"-X main.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
		"-X main.commit="
		"-X main.builtBy=portage"
	)
	use debug || my_ldflags+=( -s -w )

	ego build -mod vendor -o ${PN} -ldflags "${my_ldflags[*]}"
}

src_test() {
	ego test -ldflags \
		"-X github.com/twpayne/chezmoi/v2/internal/chezmoitest.umaskStr=0o022"
}

src_install() {
	einstalldocs

	dobin ${PN}

	newbashcomp completions/${PN}-completion.bash ${PN}
	dofishcomp completions/${PN}.fish
	newzshcomp completions/${PN}.zsh _${PN}
}
