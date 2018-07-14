# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
GOG_PN="mark_of_the_ninja"
inherit gog-games

DESCRIPTION="Mark of the Ninja"

KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"

CHECKREQS_DISK_BUILD=2500M

# TODO bundled-libs
# libSDL-1.2.so.0.11.4	: media-libs/libsdl
RDEPEND="
	virtual/opengl
	!bundled-libs? (
		media-libs/libsdl
	)
"

DEPEND=""

src_prepare() {
	for l in libfmodevent libfmodex; do
		(cd bin/lib32/; ln -sf ${l}-*.so ${l}.so)
		(cd bin/lib64/; ln -sf ${l}64-*.so ${l}64.so)
	done

	if ! use bundled-libs; then
		einfo "Removing bundled libs..."
		rm -v \
			bin/lib{32,64}/libSDL-1.2.so* \
			bin/lib{32,64}/libSDL.so
	fi

	if ! use x86; then
		rm bin/ninja-bin32
		rm -r bin/lib32/
	fi
	if ! use amd64; then
		rm bin/ninja-bin64
		rm -r bin/lib64/
	fi

	rm bin/ninja-bin

	default
}

src_install() {
	myarch=$(usex amd64 "64" "32")
	make_wrapper "${PN}" "env force_s3tc_enable=true ./ninja-bin${myarch}" "${dir}/bin/" "${dir}/bin/lib${myarch}/"

	newicon bin/motn_icon.xpm "${PN}.xpm"
	make_desktop_entry "${PN}" "Mark of the Ninja" "${PN}.xpm"

	mkdir -p "${D}/${dir}"
	mv -t "${D}/${dir}" ./*
}
