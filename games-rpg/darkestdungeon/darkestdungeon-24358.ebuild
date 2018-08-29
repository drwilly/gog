# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GOG_PN="darkest_dungeon"
inherit gog-games

SRC_URI="
	${GOG_PN}_en_${PV}_23005.sh
	dlc_musketeer? ( ${GOG_PN}_musketeer_dlc_en_${PV}_23005.sh )
	dlc_crimsoncourt? ( ${GOG_PN}_the_crimson_court_dlc_en_${PV}_23005.sh )
	dlc_shieldbreaker? ( ${GOG_PN}_the_shieldbreaker_dlc_en_${PV}_23005.sh )
	dlc_colorofmadness? ( ${GOG_PN}_the_color_of_madness_dlc_en_${PV}_23005.sh )
"

DESCRIPTION="A challenging gothic RPG about the stresses of dungeon crawling"

LICENSE="all-rights-reserved"
KEYWORDS="-* amd64 x86"
IUSE="
	bundled-libs
	dlc_musketeer
	dlc_crimsoncourt
	dlc_shieldbreaker
	dlc_colorofmadness
"

CHECKREQS_DISK_BUILD=3000M

# see game/README.linux
# TODO bundled-libs
# libfmod.so.6          : ??? (not media-libs/fmod)
# libfmodstudio.so.6    : ???
# libSDL2-2.0.so.0      : media-libs/libsdl2
RDEPEND="
	virtual/opengl
	!bundled-libs? (
		media-libs/libsdl2
	)
"

DEPEND=""

png_fix() {
	pngfix --quiet --optimize --suffix=":pngfix" "$@"
	for f; do
		mv "$f:pngfix" "$f"
	done
}

src_prepare() {
	chmod +x lib{,64}/libfmod*.so.*

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

	rm -r \
		shaders_{ps4,psv}/ \
		video_{ps4,psv}/ \
		localization/{ps4,psv,iPhone}/

	png_fix \
		panels/icons_equip/quest_item/inv_quest_item+beacon_light.png \
		shared/tutorial_popup/tutorial_popup.combat.png

	if use dlc_crimsoncourt; then
		rm dlc/580100_crimson_court/localization/localization.bat
	fi
	if use dlc_shieldbreaker; then
		rm dlc/702540_shieldbreaker/localization/localization.bat
	fi
	if use dlc_colorofmadness; then
		rm dlc/735730_color_of_madness/localization/localization.bat
	fi

	default
}

src_install() {
	myarch=$(usex amd64 "x86_64" "x86")
	make_wrapper "${PN}" ./darkest.bin.${myarch} "${dir}"

	newicon -s 128 Icon.bmp "${PN}.bmp"
	make_desktop_entry "${PN}" "Darkest Dungeon" "${PN}.bmp"

	mkdir -p "${D}/${dir}"
	mv -t "${D}/${dir}" ./*

	find "${D}/${dir}/" \
		'(' -type d -o -name '*.so.*' -o -name '*.bin.*' ')' -exec chmod 755 {} + \
		-o \
		'(' -type f ')' -exec chmod 644 {} +
}
