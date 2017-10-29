# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="darkest_dungeon_the_shieldbreaker_dlc"
GOG_PV="${PV}_15970"
inherit gog-games
SRC_URI="${GOG_PN}_en_${GOG_PV}.sh"

DESCRIPTION=""

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE=""

CHECKREQS_DISK_BUILD=40M

RDEPEND="games-rpg/darkestdungeon"

DEPEND=""

src_prepare() {
	rm \
		dlc/702540_theshieldbreaker/localization/localization.bat

	default
}

src_install() {
	mkdir -p "${D}/opt/darkestdungeon/"
	mv -t "${D}/opt/darkestdungeon/" *
}
