# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="darkest_dungeon"
inherit gog-games

DESCRIPTION="A challenging gothic RPG about the stresses of dungeon crawling"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"

CHECKREQS_DISK_BUILD=2G

# see game/README.linux
# TOOD bundled-libs
# libfmod.so.6          -> ??? (not media-libs/fmod)
# libfmodstudio.so.6    -> ???
# libSDL2-2.0.so.0      -> media-libs/libsdl2
RDEPEND="
	virtual/opengl
	!bundled-libs? (
		media-libs/libsdl2
	)
"

DEPEND=""

QA_PREBUILT="
	${dir#/}/*.bin.x86{,_64}
	${dir#/}/lib/*
	${dir#/}/lib64/*
"

src_prepare() {
	if ! use bundled-libs; then
		einfo "Removing bundled libs..."
		for file in libSDL2-2.0.so.0; do
			rm -v lib{,64}/$file
		done
	fi

	if ! use x86; then
		rm *.bin.x86
		rm -r lib/
	fi
	if ! use amd64; then
		rm *.bin.x86_64
		rm -r lib64/
	fi

	default
}

src_install() {
	myarch=$(usex amd64 "x86_64" "x86")

	newicon -s 128 Icon.bmp "${PN}.bmp"
	make_desktop_entry "${PN}"
	make_wrapper "${PN}" ./darkest.bin.${myarch} "${dir}"

	mkdir -p "${D}/${dir}"
	mv * "${D}/${dir}"
#	insinto "${dir}"
#	doins -r *

#	fperms +x "${dir}"/darkest.bin.*
}
