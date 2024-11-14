# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 linux-mod-r1

DESCRIPTION="Kernel driver for Nuvoton NCT6687-R"
HOMEPAGE="https://github.com/Fred78290/nct6687d"
EGIT_REPO_URI="https://github.com/Fred78290/nct6687d.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/Makefile.patch
)

src_compile() {
	local modlist=( nct6687 )
	local modargs=( KERNEL_BUILD="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

}
