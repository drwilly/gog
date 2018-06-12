# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gog-games.eclass
# @MAINTAINER:
# drwilly@drwilly.de
# @BLURB: Eclass for GOG games packages
# @DESCRIPTION:
# The gog-games eclass contains miscellaneous, useful functions for GOG games packages.
#

inherit check-reqs eutils

case "${EAPI:-0}" in
	6)
		;;
	0|1|2|3|4|5)
		die "EAPI=\"${EAPI}\" is not supported anymore"
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported yet"
		;;
esac

HOMEPAGE="https://www.gog.com/game/${GOG_PN}"
SRC_URI="gog_${GOG_PN}_${PV}.sh"

LICENSE="GOG-EULA"

SLOT="0"

DEPEND="app-arch/unzip"

RESTRICT="bindist strip test fetch"

GOG_S="data/noarch/game"
S="${WORKDIR}/${GOG_S}"
dir=/opt/${PN}

EXPORT_FUNCTIONS pkg_nofetch src_unpack pkg_postinst

gog-games_pkg_nofetch() {
	einfo "Please download ${SRC_URI} from your GOG.com account and put it into ${DISTDIR}."
	einfo
	einfo "You can download ${SRC_URI} in two ways:"
	einfo "   1) by internet browser"
	einfo "      a) open page 'https://www.gog.com/'"
	einfo "      b) login into your account"
	einfo "      c) go to 'Account' section"
	einfo "      d) select '${GOG_PN}'"
	einfo "      e) chose 'OS: Linux' and 'Language: English' (Linux version of archive contains all supported languages)"
	einfo "      f) in file list click on '${GOG_PN}'"
	einfo "   2) by programm 'lgogdownloader'"
	einfo "      a) install 'games-util/lgogdownloader': emerge games-util/lgogdownloader"
	einfo "      b) go to temporary directory"
	einfo "      c) run: lgogdownloader --download --game ${GOG_PN} --platform linux --include installers"
	einfo "      d) enter login information"
	einfo
	einfo "And do not forget to move ${SRC_URI} to ${DISTDIR}"
}

gog-games_src_unpack() {
	for file in ${A}; do
		unzip -qq -o "${DISTDIR}/${file}" "${GOG_S}/*" 2>/dev/null
		[[ $? -gt 1 ]] && die "Unzip failed"
	done
}

gog-games_pkg_postinst() {
	if [ ! -z "${game_require_serial_key}" ]; then
		elog "This game require serial key. You can obtain serial key following way"
		elog "   1) open in internet browser 'https://www.gog.com/'"
		elog "   2) login in your account"
		elog "   3) go to 'Account' section"
		elog "   3) select '${GOG_PN}'"
		elog "   4) click on list button 'MORE'"
		elog "   5) select 'SERIAL KEYS'"
		elog
	fi

	if has bundled-libs ${IUSE} && ! use bundled-libs; then
		elog "If you have problems try to reinstall package with 'bundled-libs' use flag turned on"
	fi
}
