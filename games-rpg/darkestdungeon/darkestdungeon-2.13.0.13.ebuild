# Copyright 1999-2016 Gentoo Foundation
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
# TODO bundled-libs
# libfmod.so.6          : ??? (not media-libs/fmod)
# libfmodstudio.so.6    : ???
# libSDL2-2.0.so.0      : media-libs/libsdl2
RDEPEND="
	dev-libs/libbsd
	media-libs/alsa-lib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXxf86vm
	x11-libs/libxcb
	!bundled-libs? (
		media-libs/libsdl2
	)
"

DEPEND=""

QA_PREBUILT="
	${dir#/}/darkest.bin.x86
	${dir#/}/darkest.bin.x86_64
	${dir#/}/lib/*
	${dir#/}/lib64/*
"

png_fix() {
	pngfix --quiet --optimize --suffix=":pngfix" "$@"
	for f; do
		mv "$f:pngfix" "$f"
	done
}

src_prepare() {
	chmod +x lib{,64}/libfmod*.so.6

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

	rm \
		localization/localization.bat \
		localization/project_paths.txt

	for p in ps4 psv; do
		rm -r \
			shaders_$p/ \
			video_$p/ \
			localization/$p/
	done

	png_fix \
		panels/icons_equip/quest_item/inv_quest_item+beacon_light.png \
		shared/tutorial_popup/tutorial_popup.combat.png

	default
}

src_install() {
	myarch=$(usex amd64 "x86_64" "x86")
	make_wrapper "${PN}" ./darkest.bin.${myarch} "${dir}"

	make_desktop_entry "${PN}"
	newicon -s 128 Icon.bmp "${PN}.bmp"

	mkdir -p "${D}/${dir}"
	mv -t "${D}/${dir}" *
}
