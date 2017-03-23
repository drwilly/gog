# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="day_of_the_tentacle_remastered"
inherit gog-games

DESCRIPTION="A mind-bending, time travel, cartoon puzzle adventure game"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE=""

CHECKREQS_DISK_BUILD=2700M

RDEPEND="
	virtual/opengl[abi_x86_32]
"

DEPEND=""

QA_PREBUILT="
	${dir#/}/Dott
	${dir#/}/lib/*
"

src_install() {
	make_wrapper "${PN}" ./Dott "${dir}"

	make_desktop_entry "${PN}"

	mkdir -p "${D}/${dir}"
	mv -t "${D}/${dir}" *
}
