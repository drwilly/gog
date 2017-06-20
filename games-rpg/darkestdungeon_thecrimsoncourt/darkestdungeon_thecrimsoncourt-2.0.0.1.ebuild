# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="darkest_dungeon_the_crimson_court_dlc"
inherit gog-games

DESCRIPTION="A parallel campaign alongside the main Darkest Dungeon content"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE=""

CHECKREQS_DISK_BUILD=400M

RDEPEND="games-rpg/darkestdungeon"

DEPEND=""

src_prepare() {
	rm \
		dlc/580100_crimson_court/localization/localization.bat

	default
}

src_install() {
	mkdir -p "${D}/opt/darkestdungeon/"
	mv -t "${D}/opt/darkestdungeon/" *
}
