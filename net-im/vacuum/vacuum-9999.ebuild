# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/Vacuum-IM/vacuum-im.git"
PLOCALES="de es pl ru uk"
inherit cmake-utils git-r3

DESCRIPTION="Qt Crossplatform Jabber client"
HOMEPAGE="http://www.vacuum-im.org/"

LICENSE="GPL-3"
SLOT="0/37" # subslot = libvacuumutils soname version
KEYWORDS=""
PLUGINS="+accountmanager adiummessagestyle annotations autostatus avatars birthdayreminder bitsofbinary bookmarks captchaforms +chatmessagehandler chatstates clientinfo commands compress +connectionmanager console dataforms datastreamsmanager datastreamspublisher +defaultconnection emoticons filemessagearchive filestreamsmanager filetransfer gateways inbandstreams iqauth jabbersearch +mainwindow messagearchiver messagecarbons +messageprocessor +messagestyles +messagewidgets metacontacts multiuserchat +normalmessagehandler +notifications +optionsmanager pepmanager +presence privacylists privatestorage recentcontacts registration remotecontrol +roster +rosterchanger rosteritemexchange rostersearch +rostersmodel +rostersview +saslauth servermessagearchive servicediscovery sessionnegotiation shortcutmanager +simplemessagestyle socksstreams spellchecker +stanzaprocessor +starttls statistics +statuschanger +statusicons +traymanager urlprocessor vcard +xmppstreams xmppuriqueries"
SPELLCHECKER_BACKENDS="aspell +enchant hunspell"
IUSE="${PLUGINS} ${SPELLCHECKER_BACKENDS} +spell"
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

REQUIRED_USE="
	accountmanager? ( xmppstreams )
	annotations? ( privatestorage )
	autostatus? ( statuschanger accountmanager )
	avatars? ( vcard )
	birthdayreminder? ( vcard )
	bitsofbinary? ( stanzaprocessor )
	bookmarks? ( privatestorage )
	captchaforms? ( dataforms xmppstreams stanzaprocessor )
	chatmessagehandler? ( messagewidgets messageprocessor messagestyles )
	chatstates? ( presence messagewidgets stanzaprocessor )
	clientinfo? ( stanzaprocessor )
	commands? ( dataforms xmppstreams stanzaprocessor )
	compress? ( xmppstreams )
	console? ( xmppstreams mainwindow )
	datastreamsmanager? ( dataforms stanzaprocessor )
	emoticons? ( messagewidgets )
	filemessagearchive? ( messagearchiver )
	filestreamsmanager? ( datastreamsmanager )
	filetransfer? ( filestreamsmanager datastreamsmanager )
	gateways? ( stanzaprocessor )
	inbandstreams? ( stanzaprocessor )
	iqauth? ( xmppstreams )
	jabbersearch? ( stanzaprocessor )
	messagearchiver? ( xmppstreams stanzaprocessor )
	messagecarbons? ( xmppstreams stanzaprocessor servicediscovery )
	messageprocessor? ( xmppstreams stanzaprocessor )
	metacontacts? ( privatestorage )
	multiuserchat? ( stanzaprocessor )
	normalmessagehandler? ( messagewidgets messageprocessor messagestyles )
	pepmanager? ( stanzaprocessor servicediscovery xmppstreams )
	presence? ( xmppstreams stanzaprocessor )
	privacylists? ( xmppstreams stanzaprocessor )
	privatestorage? ( stanzaprocessor )
	recentcontacts? ( privatestorage )
	registration? ( dataforms stanzaprocessor )
	remotecontrol? ( commands dataforms )
	roster? ( xmppstreams stanzaprocessor )
	rosterchanger? ( roster )
	rosteritemexchange? ( roster stanzaprocessor )
	rostersearch? ( rostersview mainwindow )
	rostersview? ( rostersmodel )
	saslauth? ( xmppstreams )
	servermessagearchive? ( messagearchiver stanzaprocessor )
	servicediscovery? ( xmppstreams stanzaprocessor )
	sessionnegotiation? ( dataforms stanzaprocessor )
	shortcutmanager? ( optionsmanager )
	socksstreams? ( stanzaprocessor )
	spellchecker? ( messagewidgets )
	stanzaprocessor? ( xmppstreams )
	starttls? ( xmppstreams defaultconnection )
	statuschanger? ( presence )
	spell? ( ^^ ( ${SPELLCHECKER_BACKENDS//+/} ) )
"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtlockedfile[qt5(+)]
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtxml:5
	net-dns/libidn
	adiummessagestyle? ( dev-qt/qtwebkit:5 )
	filemessagearchive? ( dev-qt/qtsql:5[sqlite] )
	messagearchiver? ( dev-qt/qtsql:5[sqlite] )
	spell? (
		aspell? ( app-text/aspell )
		enchant? ( app-text/enchant )
		hunspell? ( app-text/hunspell )
	)
	net-dns/libidn
	x11-libs/libXScrnSaver
	sys-libs/zlib[minizip]
"
RDEPEND="${DEPEND}
	!net-im/vacuum-spellchecker
"

DOCS=(AUTHORS CHANGELOG README TRANSLATORS)

src_prepare() {
	# Force usage of system libraries
	rm -rf src/thirdparty/{idn,hunspell,minizip,zlib,qtlockedfile}
	cd ${S}
	export QT_SELECT=qt5
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(get_libdir)"
		-DINSTALL_SDK=ON
		-DLANGS="$(l10n_get_locales)"
		-DINSTALL_DOCS=OFF
		-DFORCE_BUNDLED_MINIZIP=OFF
		-DPLUGIN_statistics=OFF
		-DNO_WEBKIT=$(usex !adiummessagestyle)
		-DPLUGIN_spellchecker=$(usex spell)
	)

	for x in ${PLUGINS}; do
		p=${x/#+/}
		mycmakeargs+=( -DPLUGIN_${p}=$(usex $p) )
	done

	for i in ${SPELLCHECKER_BACKENDS//+/}; do
		use "${i}" && mycmakeargs+=( -DSPELLCHECKER_BACKEND="${i}" )
	done

	cmake-utils_src_configure
}
