# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="xenonauts"
inherit gog2

SRC_URI="${GOG_PN}_en_${GOG_PV}_21328.sh"

DESCRIPTION="Spiritual successor to UFO: Enemy Unknown set in the Cold-War era"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="bundled-deps extras"

CHECKREQS_DISK_BUILD=3G

RDEPEND="
	virtual/opengl[abi_x86_32]
	media-libs/libsdl2[abi_x86_32]
	x11-libs/libX11[abi_x86_32]
	x11-libs/libXinerama[abi_x86_32]
	x11-libs/libXxf86vm[abi_x86_32]
	x11-libs/libXext[abi_x86_32]
"

DEPEND=""

src_unpack() {
	if ! use bundled-deps; then
		# media-libs/libsdl2
		GOG_EXCLUDE+=("*/lib/libSDL2-2.0.so.0")
	fi

	if ! use extras; then
		GOG_EXCLUDE+=("*/extras/*")
	fi

	gog2_src_unpack
}

src_install() {
	gog2_make_wrapper "${PN}"

	newicon Icon.png xenonauts.png
	make_desktop_entry "${PN}" Xenonauts xenonauts.png

	gog2_src_install
}
