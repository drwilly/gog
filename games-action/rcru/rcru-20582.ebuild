# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="river_city_ransom_underground"
inherit gog-games

SRC_URI="${GOG_PN}_en_r7_4_${PV}.sh"

DESCRIPTION="One of the best beat'em ups of the NES era is back!"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"

CHECKREQS_DISK_BUILD=150M

# TODO bundled-libs
# TODO Mono?
# libCSteamworks.so	: -
# libjpeg.so.62		: virtual/jpeg
# libmojoshader.so	: -
# libMonoPosixHelper.so	: -
# libogg.so.0		: media-libs/libogg
# libopenal.so.1	: media-libs/openal
# libpng15.so.15	: media-libs/libpng:1.5, later versions seem to work
# libSDL2-2.0.so.0	: media-libs/libsdl2
# libSDL2_image-2.0.so.0: media-libs/sdl2-image
# libsteam_api.so	: -
# libtheoradec.so.1	: ? media-libs/libtheora
# libtheorafile.so	: ? media-libs/libtheora
# libvorbisfile.so.3	: media-libs/libvorbis
# libvorbis.so.0	: media-libs/libvorbis
RDEPEND="
	virtual/opengl
	!bundled-libs? (
		virtual/jpeg
		media-libs/libogg
		media-libs/openal
		media-libs/libpng
		media-libs/libsdl2
		media-libs/sdl2-image
		media-libs/libtheora
		media-libs/libvorbis
	)
"

DEPEND=""

QA_PREBUILT="
	${dir#/}/RCRU.bin.x86
	${dir#/}/RCRU.bin.x86_64
	${dir#/}/lib/*
	${dir#/}/lib64/*
"

src_prepare() {
	chmod +x lib{,64}/*.so*
	chmod +x RCRU.bin.*

	if ! use bundled-libs; then
		einfo "Removing bundled libs..."
		rm -v \
			lib{,64}/libjpeg.so.62	\
			lib{,64}/libogg.so.0	\
			lib{,64}/libopenal.so.1	\
			lib{,64}/libpng15.so.15	\
			lib{,64}/libSDL2-2.0.so.0	\
			lib{,64}/libSDL2_image-2.0.so.0	\
			lib{,64}/libtheoradec.so.1	\
			lib{,64}/libtheorafile.so	\
			lib{,64}/libvorbisfile.so.3	\
			lib{,64}/libvorbis.so.0
	fi

	if ! use x86; then
		rm *.bin.x86
		rm -r lib/
	fi
	if ! use amd64; then
		rm *.bin.x86_64
		rm -r lib64/
	fi

	rm RCRU

	# fix logging
	sed -i -e 's:fileName="log.txt":fileName="/tmp/rcru.log":' || die

	default
}

src_install() {
	myarch=$(usex amd64 "x86_64" "x86")
	make_wrapper "${PN}" ./RCRU.bin.${myarch} "${dir}"

	make_desktop_entry "${PN}"
	doicon RCRU.bmp

	mkdir -p "${D}/${dir}"
	mv -t "${D}/${dir}" *
}
