# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="darkest_dungeon"
inherit gog2

SRC_URI="
	${GOG_PN}_${PV}_28859.sh
	dlc_musketeer? ( ${GOG_PN}_musketeer_${PV}_28859.sh )
	dlc_crimsoncourt? ( ${GOG_PN}_the_crimson_court_${PV}_28859.sh )
	dlc_shieldbreaker? ( ${GOG_PN}_the_shieldbreaker_${PV}_28859.sh )
	dlc_colorofmadness? ( ${GOG_PN}_the_color_of_madness_${PV}_28859.sh )
"

DESCRIPTION="A challenging gothic RPG about the stresses of dungeon crawling"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="
	bundled-deps
	dlc_musketeer
	dlc_crimsoncourt
	dlc_shieldbreaker
	dlc_colorofmadness
"

CHECKREQS_DISK_BUILD=3000M

# see game/README.linux
# TODO bundled-deps
# libfmod.so.6          : ??? (not media-libs/fmod)
# libfmodstudio.so.6    : ???
# libSDL2-2.0.so.0      : media-libs/libsdl2
RDEPEND="
	virtual/opengl
	!bundled-deps? (
		media-libs/libsdl2
	)
"

DEPEND=""

src_unpack() {
	if ! use bundled-deps; then
		GOG_EXCLUDE+=("*/lib*/libSDL2-2.0.so.0")
	fi

	if ! use x86; then
		GOG_EXCLUDE+=("*.bin.x86")
		GOG_EXCLUDE+=("*/lib/*")
	fi
	if ! use amd64; then
		GOG_EXCLUDE+=("*.bin.x86_64")
		GOG_EXCLUDE+=("*/lib64/*")
	fi

	GOG_EXCLUDE+=("*.bat")
	GOG_EXCLUDE+=("*/project_paths.txt")

	GOG_EXCLUDE+=("*/ps4/*" "*/shaders_ps4/*" "*/video_ps4/*")
	GOG_EXCLUDE+=("*/psv/*" "*/shaders_psv/*" "*/video_psv/*")
	GOG_EXCLUDE+=("*/iPhone/*" "*/iphone/*")
	GOG_EXCLUDE+=("*/xb1/*")
	#GOG_EXCLUDE+=("*/nx/*")

	gog2_src_unpack
}

png_fix() {
	pngfix --quiet --optimize --suffix=":pngfix" "$@"
	for f; do
		mv "$f:pngfix" "$f"
	done
}

src_prepare() {
	find "${S}" \
		-type d -exec chmod 755 {} + \
		-o \
		-type f -exec chmod -x {} + \
		|| die
	chmod +x *.bin.* lib*/*.so.*

	png_fix \
		panels/icons_equip/quest_item/inv_quest_item+beacon_light.png \
		shared/tutorial_popup/tutorial_popup.combat.png

	default
}

src_install() {
	gog2_make_wrapper ./darkest.bin.'$(uname -m)'

	newicon -s 128 Icon.bmp "${PN}.bmp"
	make_desktop_entry "${PN}" "Darkest Dungeon" "${PN}.bmp"

	gog2_src_install
}
