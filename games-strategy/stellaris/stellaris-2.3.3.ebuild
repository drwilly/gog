# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="stellaris"
inherit gog2

SRC_URI="
	${GOG_PN}_${GOG_PV}_30733.sh
	dlc_horizonsignal? ( ${GOG_PN}_horizon_signal_${GOG_PV}_30733.sh )
	dlc_anniversaryportraits? ( ${GOG_PN}_anniversary_portraits_${GOG_PV}_30733.sh )
	dlc_utopia? ( ${GOG_PN}_utopia_${GOG_PV}_30733.sh )
"

DESCRIPTION=""

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="bundled-deps dlc_novel dlc_artbook dlc_soundtrack +dlc_horizonsignal dlc_utopia +dlc_anniversaryportraits"

CHECKREQS_DISK_BUILD=10G

RDEPEND="
	virtual/opengl[abi_x86_32]
	media-plugins/alsa-plugins[abi_x86_32]
	x11-libs/libX11[abi_x86_32]
	!bundled-deps? (
		virtual/glu[abi_x86_32]
	)
"

DEPEND=""

src_unpack() {
	if ! use bundled-deps; then
		# sys-devel/gcc
		GOG_EXCLUDE+=("*/libatomic.so.1")
		# virtual/glu
		GOG_EXCLUDE+=("*/libGLU.so.1")
	fi

	# For full list of DLCs, see data/noarch/game/dlc/dlc.txt
	use dlc_novel || GOG_EXCLUDE+=("*/dlc005_novel/*")
	use dlc_artbook || GOG_EXCLUDE+=("*/dlc008_artbook/*")
	use dlc_soundtrack || GOG_EXCLUDE+=("*/dlc011_original_game_soundtrack/*")

	GOG_EXCLUDE+=("*.bat" "*.dll" "*.dylib")
	GOG_EXCLUDE+=("*/licenses/*")

	gog2_src_unpack
}

src_prepare() {
	find "${S}" \
		-type d -exec chmod 755 {} + \
		-o \
		-type f -exec chmod -x {} + \
		|| die
	chmod +x *.so stellaris *.py || die

	default
}

src_install() {
	gog2_make_wrapper ./stellaris

#	newicon Icon.png ???.png
	make_desktop_entry "${PN}" Stellaris

	gog2_src_install
}
