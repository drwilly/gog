# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="faster_than_light"
inherit gog-games

SRC_URI="gog_ftl_advanced_edition_${PV}.sh"

DESCRIPTION=""

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="
	bundled-libs
"

CHECKREQS_DISK_BUILD=250M

RDEPEND="
	virtual/opengl
	!bundled-libs? (
		media-libs/devil[png]
		media-libs/freetype:2
		media-libs/libsdl[X,sound,joystick,opengl,video]
		sys-libs/zlib
	)
	sys-devel/gcc[cxx]
"

DEPEND=""

QA_PREBUILT="/opt/**"

S="${S}/data"

src_prepare() {
	chmod +x {x86,amd64}/lib/libbass{,mix}.so

	if ! use bundled-libs; then
		einfo "Removing bundled libs..."
		for x in x86 amd64; do
			rm -v \
				$x/lib/libfreetype.so.6 \
				$x/lib/libIL*.so.1 \
				$x/lib/libpng12.so.0 \
				$x/lib/libSDL-*.so.0 \
				$x/lib/libz.so.1
		done
	fi

	if ! use x86; then
		rm -r x86/
	fi
	if ! use amd64; then
		rm -r amd64/
	fi

	rm FTL
	rm -r licenses/

	mv -t . "${ARCH}/bin/" "${ARCH}/lib/"
	rmdir "${ARCH}"

	default
}

src_install() {
	newicon resources/exe_icon.bmp "${PN}.bmp"
	make_wrapper "${PN}" ./FTL "/opt/${PN}/"
	make_desktop_entry "${PN}" "Faster Than Light" "${PN}.bmp"

	mkdir -p "${D}/opt/${PN}/"
	mv -t "${D}/opt/${PN}/" bin/ lib/ resources/
}
