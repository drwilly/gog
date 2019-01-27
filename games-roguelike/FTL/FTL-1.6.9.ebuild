# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="faster_than_light"
inherit gog2

SRC_URI="ftl_advanced_edition_${GOG_PV}_25330.sh"

DESCRIPTION="Faster Than Light: A spaceship simulation real-time roguelike-like game"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE=""

CHECKREQS_DISK_BUILD=200M

RDEPEND="
	virtual/opengl
	media-libs/alsa-lib
	x11-libs/libX11
"

DEPEND=""

S="${S}/data"

src_unpack() {
	use x86 || GOG_EXCLUDE+=("*/FTL.x86")
	use amd64 || GOG_EXCLUDE+=("*/FTL.amd64")

	GOG_EXCLUDE+=("*/FTL_README.html")
	GOG_EXCLUDE+=("*/FTL")
	GOG_EXCLUDE+=("*/licenses/*")

	gog2_src_unpack
}

src_prepare() {
	chmod -x exe_icon.bmp ftl.dat
	chmod +x "FTL.$ARCH"

	default
}

src_install() {
	make_wrapper "${PN}" "./FTL.$ARCH" "/opt/gog/${PN}/"

	newicon exe_icon.bmp "${PN}.bmp"
	make_desktop_entry "${PN}" "Faster Than Light" "${PN}.bmp"

	gog2_src_install
}
