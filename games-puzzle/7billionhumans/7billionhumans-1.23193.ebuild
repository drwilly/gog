# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="human_resource_machine"
inherit gog-games

MY_PV="${PV//\./_}"

SRC_URI="7_billion_humans_en_gog_${MY_PV}.sh"

DESCRIPTION="Automate swarms of office workers to solve puzzles"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"

CHECKREQS_DISK_BUILD=150M

RDEPEND="
	media-libs/libsdl2
	media-libs/openal
"

DEPEND=""

src_prepare() {
	if ! use x86; then
		rm *.x86
		rm -r lib/
	fi
	if ! use amd64; then
		rm *.x86_64
		rm -r lib64/
	fi
	if ! use bundled-libs; then
		rm -r lib*/
	fi

	rm LICENSE.txt

	default
}

src_install() {
	make_wrapper "${PN}" "./*.bin.*" "${dir}"

	make_desktop_entry "${PN}" "7 Billion Humans" "${dir}/icon.png"

	chmod +x "*.bin.*"

	mkdir -p "${dir}"
	mv -t "${dir}" ./*
}
