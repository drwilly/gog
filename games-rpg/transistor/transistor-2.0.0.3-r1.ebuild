# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="transistor"
inherit gog-games

DESCRIPTION="A sci-fi themed action RPG that integrates strategic planning with atmospheric storytelling"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"

CHECKREQS_DISK_BUILD=3G

# see game/README.linux
# TOOD bundled-libs
# libBink.so			???
# libFModPlugins.so		???
# libfmod.so.4			???
# libfmodstudio.so.4	???
# liblua52.so			dev-lang/lua:5.2
# libmono-2.0.so.1
# libSDL2-2.0.so.0		media-libs/libsdl2
RDEPEND="
	virtual/opengl
	!bundled-libs? (
		media-libs/libsdl2
	)
"

DEPEND=""

src_prepare() {
	if ! use bundled-libs; then
		einfo "Removing bundled libs..."
		rm -v lib{,64}/libSDL2-2.0.so.0
	fi

	if ! use x86; then
		rm *.bin.x86
		rm -r lib/
	fi
	if ! use amd64; then
		rm *.bin.x86_64
		rm -r lib64/
	fi

	rm Content/Textures/Thumbs.db

	default
}

src_install() {
	myarch=$(usex amd64 "x86_64" "x86")
	make_wrapper "${PN}" ./Transistor.bin.${myarch} "${dir}"

	doicon -s 256 Transistor.bmp
	make_desktop_entry "${PN}" Transistor Transistor.bmp

	mkdir -p "${D}/${dir}"
	mv -t "${D}/${dir}" ./*
}
