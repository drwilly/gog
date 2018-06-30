# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="torchlight_ii"
inherit gog-games

SRC_URI="gog_torchlight_2_${PV}.sh"

DESCRIPTION=""

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="+bundled-libs"

CHECKREQS_DISK_BUILD=2G

# TOOD bundled-libs
# libCEGUIBase.so.1                     : dev-games/cegui
# libCEGUIExpatParser.so                : dev-games/cegui[expat]
# libCEGUIFalagardWRBase.so             : dev-games/cegui
# libCEGUIFreeImageImageCodec.so        : dev-games/cegui[freeimage]
# libfmodex.so                          : -
# libfreeimage.so.3                     : media-libs/freeimage
# libfreetype.so.6                      : media-libs/freetype
# libOgreMain.so.1                      : dev-games/ogre
# Plugin_OctreeSceneManager.so          : ???
# RenderSystem_GL.so                    : ???
RDEPEND="
	virtual/opengl
	media-libs/libsdl2
	sys-apps/util-linux
	sys-libs/zlib
	!bundled-libs? (
		dev-games/cegui[expat,freeimage,freetype,ogre]
	)
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXext
"

DEPEND=""

QA_PREBUILT="*"

src_prepare() {
	if ! use bundled-libs; then
		einfo "Removing bundled libs..."
		rm -v \
			lib{,64}/libSDL2-2.0.so.0 \
			lib{,64}/libCEGUIBase.so.1 \
			lib{,64}/libCEGUIExpatParser.so \
			lib{,64}/libCEGUIFreeImageImageCodec.so \
			lib{,64}/libfreeimage.so.3 \
			lib{,64}/libfreetype.so.6 \
			lib{,64}/libOgreMain.so.1
	fi

	if ! use x86; then
		rm *.bin.x86
		rm -r lib/
	fi
	if ! use amd64; then
		rm *.bin.x86_64
		rm -r lib64/
	fi

	rm -r licenses/

	default
}

src_install() {
	myarch=$(usex amd64 "x86_64" "x86")
	make_wrapper "${PN}" ./Torchlight2.bin.${myarch} "${dir}"

	newicon logo.bmp "${PN}.bmp"
	make_desktop_entry "${PN}" "Torchlight 2" "${PN}.bmp"

	mkdir -p "${D}/${dir}"
	mv -t "${D}/${dir}" ./*
}
