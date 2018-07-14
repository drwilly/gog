# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="faster_than_light"
inherit gog-games

MY_PV="${PV//\./_}"

SRC_URI="ftl_advanced_edition_en_${MY_PV}_18662.sh"

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

src_prepare() {
	if ! use x86; then
		rm FTL.x86
	fi
	if ! use amd64; then
		rm FTL.amd64
	fi

	rm FTL
	rm -r licenses/

	default
}

src_install() {
	make_wrapper "${PN}" "./FTL.$ARCH" "/opt/${PN}/"

	newicon exe_icon.bmp "${PN}.bmp"
	make_desktop_entry "${PN}" "Faster Than Light" "${PN}.bmp"

	chmod +x "FTL.$ARCH"

	mkdir -p "${D}/opt/${PN}/"
	mv -t "${D}/opt/${PN}/" ftl.dat "FTL.$ARCH"
}
