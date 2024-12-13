# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="KDE PIM - merge this to pull in all kdepim-derived packages"
HOMEPAGE="https://apps.kde.org/kontact/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="bogofilter clamav spamassassin"

RDEPEND="
	>=kde-apps/akonadi-${PV}:*
	>=kde-apps/akonadi-calendar-${PV}:*
	>=kde-apps/akonadi-contacts-${PV}:*
	>=kde-apps/akonadi-mime-${PV}:*
	>=kde-apps/akonadi-search-${PV}:*
	>=kde-apps/grantleetheme-${PV}:*
	>=kde-apps/kcalutils-${PV}:*
	>=kde-apps/kdepim-runtime-${PV}:*
	>=kde-apps/kidentitymanagement-${PV}:*
	>=kde-apps/kimap-${PV}:*
	>=kde-apps/kldap-${PV}:*
	>=kde-apps/kmail-${PV}:*
	>=kde-apps/kmail-account-wizard-${PV}:*
	>=kde-apps/kmailtransport-${PV}:*
	>=kde-apps/kmbox-${PV}:*
	>=kde-apps/kmime-${PV}:*
	>=kde-apps/kontactinterface-${PV}:*
	>=kde-apps/kpimtextedit-${PV}:*
	>=kde-apps/ksmtp-${PV}:*
	>=kde-apps/libgravatar-${PV}:*
	>=kde-apps/libkdepim-${PV}:*
	>=kde-apps/libkgapi-${PV}:*
	>=kde-apps/libkleo-${PV}:*
	>=kde-apps/libksieve-${PV}:*
	>=kde-apps/libktnef-${PV}:*
	>=kde-apps/mailcommon-${PV}:*
	>=kde-apps/mailimporter-${PV}:*
	>=kde-apps/mbox-importer-${PV}:*
	>=kde-apps/messagelib-${PV}:*
	>=kde-apps/mimetreeparser-${PV}:*
"
# Optional runtime dependencies: kde-apps/kmail
RDEPEND="${RDEPEND}
	bogofilter? ( mail-filter/bogofilter )
	clamav? ( app-antivirus/clamav )
	spamassassin? ( mail-filter/spamassassin )
"
