# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: gog2.eclass
# @MAINTAINER:
# drwilly@drwilly.de
# @BLURB: Eclass for GOG games packages
# @DESCRIPTION:
# The gog eclass contains miscellaneous, useful functions for GOG games packages.
#

inherit check-reqs eutils

case ${EAPI:-0} in
	6)              ;;
	0|1|2|3|4|5)    die "EAPI=\"${EAPI}\" is not supported anymore";;
	*)              die "EAPI=\"${EAPI}\" is not supported yet";;
esac

HOMEPAGE="https://www.gog.com/game/${GOG_PN}"

LICENSE="GOG-EULA"

SLOT="0"

DEPEND="app-arch/unzip"

# binary-only repository
QA_PREBUILT="*"

RESTRICT="bindist strip test fetch"

GOG_PV="${PV//\./_}"

GOG_S="data/noarch/game"
S="${WORKDIR}/${GOG_S}"

EXPORT_FUNCTIONS pkg_nofetch src_unpack src_install pkg_postinst

gog2_pkg_nofetch() {
	einfo "Please download ${SRC_URI} from your GOG.com account and put it into ${DISTDIR}."
	einfo
	einfo "You can download ${SRC_URI} in two ways:"
	einfo "   1) by internet browser"
	einfo "      a) on gog.com go to 'Account' section"
	einfo "      b) select '${GOG_PN}'"
	einfo "      c) chose 'OS: Linux' and 'Language: English' (Linux version of archive contains all supported languages)"
	einfo "      d) in file list click on '${GOG_PN}'"
	einfo "   2) by programm 'lgogdownloader'"
	einfo "      a) install 'games-util/lgogdownloader': emerge games-util/lgogdownloader"
	einfo "      b) go to temporary directory"
	einfo "      c) run: lgogdownloader --download --game ${GOG_PN} --platform linux --include installers"
	einfo "      d) enter login information"
}

declare -a GOG_EXCLUDE

gog2_src_unpack() {
	unzip -qq -o "${DISTDIR}/${A[0]}" \
		data/noarch/gameinfo \
		data/noarch/support/icon.png \
		2>/dev/null
	for file in ${A}; do
		unzip -qq -o "${DISTDIR}/${file}" \
			"${GOG_S}/*" \
			-x "${GOG_EXCLUDE[@]}" \
			2>/dev/null
		[[ $? -gt 1 ]] && die "Unzip failed"
	done
}

gog2_src_install() {
	local GOG_D="${D}"/opt/gog/"${PN}"
	mkdir -p "$GOG_D" || die
	mv -t "$GOG_D" ./* || die
	chown root:root -R "$GOG_D" || die
}

gog2_pkg_postinst() {
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
		elog "If you have problems try to reinstall the package with 'bundled-libs' use flag turned on"
	fi
}
