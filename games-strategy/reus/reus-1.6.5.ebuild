# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="reus"
inherit gog-games

MY_PV="${PV//\./_}"

SRC_URI="${GOG_PN}_en_${MY_PV}_20844.sh"

DESCRIPTION=""

LICENSE="all-rights-reserved"
KEYWORDS="-* x86"
IUSE="bundled-libs"

CHECKREQS_DISK_BUILD=500M

RDEPEND="
	virtual/jpeg
	media-libs/freetype
	media-libs/libogg
	media-libs/openal
	media-libs/libpng
	media-libs/libsdl2
	media-libs/sdl2-image
	media-libs/libtheora
	media-libs/libvorbis
"

DEPEND=""

src_prepare() {
	chmod +x lib/* lib64/* *.bin.*

	if ! use bundled-libs; then
		einfo "Removing bundled libs..."
		rm -v \
			lib*/libfreetype.so.6   \
			lib*/libjpeg.so.62      \
			lib*/libogg.so.0        \
			lib*/libopenal.so.1     \
			lib*/libpng15.so.15     \
			lib*/libSDL2-2.0.so.0   \
			lib*/libSDL2_image-2.0.so.0 \
			lib*/libtheoradec.so.1  \
			lib*/libvorbis.so.0     \
			lib*/libvorbisfile.so.3
	fi

	if ! use x86; then
		rm Reus.bin.x86
		rm -r lib/
	fi
	if ! use amd64; then
		rm Reus.bin.x86_64
		rm -r lib64/
	fi

	rm Reus

	default
}

src_install() {
	make_wrapper "${PN}" ./*.bin.* "${dir}"

	newicon Reus.bmp reus.bmp
	make_desktop_entry "${PN}" Reus reus.bmp

	mkdir -p "${D}/${dir}"
	mv -t "${D}/${dir}" ./*
}
