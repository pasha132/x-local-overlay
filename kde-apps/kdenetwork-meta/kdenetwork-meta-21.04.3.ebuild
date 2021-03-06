# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="kdenetwork - merge this to pull in all kdenetwork-derived packages"
HOMEPAGE="https://kde.org/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="+bittorrent dropbox samba +webengine"

RDEPEND="


	>=kde-apps/krdc-${PV}:${SLOT}

	>=kde-apps/zeroconf-ioslave-${PV}:${SLOT}



	bittorrent? (
		>=net-libs/libktorrent-${PV}:${SLOT}
		>=net-p2p/ktorrent-${PV}:${SLOT}
	)
	dropbox? ( >=kde-apps/dolphin-plugins-dropbox-${PV}:${SLOT} )
	samba? ( >=kde-apps/kdenetwork-filesharing-${PV}:${SLOT} )
	webengine? ( >=kde-apps/plasma-telepathy-meta-${PV}:${SLOT} )
"
