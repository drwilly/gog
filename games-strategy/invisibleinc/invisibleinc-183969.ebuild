# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="invisible_inc"
GOG_PV="8_07_2017_15873"
inherit gog-games
SRC_URI="${GOG_PN}_en_${GOG_PV}.sh"

DESCRIPTION="Control Invisible's agents and infiltrate the world's most dangerous corporations"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"

# about 1.2G
CHECKREQS_DISK_BUILD=1500M

# TOOD bundled-libs
#libsteam_api
#libfmodevent
#libfmodex
RDEPEND="
	media-libs/alsa-lib
	virtual/opengl
	!bundled-libs? (
		media-libs/libsdl2[haptic]
	)
"

DEPEND=""

QA_PREBUILT="
	${dir#/}/InvisibleInc{32,64}
	${dir#/}/lib{32,64}/*
"

src_prepare() {
	chmod +x lib{32,64}/*

	for l in libfmodevent libfmodex; do
		(cd lib32/; ln -sf ${l}-*.so ${l}.so)
		(cd lib64/; ln -sf ${l}64-*.so ${l}64.so)
	done
	for arch in 32 64; do
		(cd lib${arch}/; ln -sf libSDL2-*.so.0 libSDL2.so)
	done

	if ! use bundled-libs; then
		einfo "Removing bundled libs..."
		for file in libSDL2-2.0.so.0 libSDL2.so; do
			rm -v lib{32,64}/$file
		done
	fi

	if ! use x86; then
		rm InvisibleInc32
		rm -r lib32/
	fi
	if ! use amd64; then
		rm InvisibleInc64
		rm -r lib64/
	fi

	rm \
		run-linux{32,64}.sh \
		LICENSE

	default
}

src_install() {
	myarch=$(usex amd64 "64" "32")
	make_wrapper "${PN}" ./InvisibleInc${myarch} "${dir}"

	make_desktop_entry "${PN}" "Invisible Inc"

	mkdir -p "${D}/${dir}"
	mv -t "${D}/${dir}" ./*
}
