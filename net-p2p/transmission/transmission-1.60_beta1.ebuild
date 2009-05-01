# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="BitTorrent client"
HOMEPAGE="http://www.transmissionbt.com/"

MY_P=${P/_beta/b}
MY_P=${P}
SRC_URI="http://mirrors.m0k.org/transmission/files/${MY_P}.tar.bz2"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE="gtk libnotify"

RDEPEND=">=net-misc/curl-7.16.3
 >=dev-libs/openssl-0.9.8
 gtk? ( >=dev-libs/glib-2.16
>=x11-libs/gtk+-2.6
>=dev-libs/dbus-glib-0.70
 libnotify? ( >=x11-libs/libnotify-0.4.4 ) )"
DEPEND="${RDEPEND}
sys-devel/gettext
>=dev-util/pkgconfig-0.19
>=dev-util/intltool-0.35"

pkg_setup() {
	if ! built_with_use net-misc/curl gnutls && \
		! built_with_use net-misc/curl ssl; then
		eerror "Please rebuild net-misc/curl with the ssl or gnutls USE flag enabled."
		die "net-misc/curl needs ssl or gnutls USE flag"
		fi
}

src_compile() {
	econf $(use_enable gtk) $(use_enable libnotify) --with-wx-config=no || die "configure failed"
	emake || die "build failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
dodoc AUTHORS NEWS

doinitd "${FILESDIR}"/transmission
newconfd "${FILESDIR}"/transmission-confd transmission
diropts -m 755 -o nobody -g nogroup
dodir /var/transmission/config
dodir /var/transmission/downloads
elog ""
elog "Check and configure options by editing /etc/conf.d/transmission"
elog ""
}
