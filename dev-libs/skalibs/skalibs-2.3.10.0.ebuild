# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="skarnet.org general-purpose libraries"
HOMEPAGE="http://www.skarnet.org/software/skalibs/index.html"
SRC_URI="http://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6 static-libs"

DEPEND=">=sys-devel/make-3.81"
RDEPEND=""

src_prepare() {
	# Remove QA warning about LDFLAGS addition
	sed -i "s~tryldflag LDFLAGS_AUTO -Wl,--hash-style=both~:~" "${S}/configure" || die
	eapply_user
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_enable static-libs static) \
		--dynlibdir=/$(get_libdir) \
		--libdir=/usr/$(get_libdir)/${PN} \
		--datadir=/etc \
		--sysdepdir=/usr/$(get_libdir)/${PN} \
		--enable-force-devr
}

src_install() {
	default
	dodir /etc/ld.so.conf.d/
	echo "/$(get_libdir)/${PN}" > ${ED}/etc/ld.so.conf.d/10${PN}.conf || die

	use doc && dohtml -r doc/*
}
