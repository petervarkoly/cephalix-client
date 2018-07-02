#
# spec file for package cephalix-client
#
# Copyright (c) 2018 Dipl Ing Peter Varkoly, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://www.cephalix.eu/
#

Name:           cephalix-client
Version:	@VERSION@
Release:	@RELEASE@
Vendor:         Dipl.Ing. Peter Varkoly <peter@varkoly.de>
License:	BSD-3-Clause and LGPL-2.1+ and MIT
Summary:	Base package for a cephalix client
Url:		http://www.cephalix.eu/
Group:		Productivity/
Source:		%{name}.tar.bz2
PreReq:		oss-base
BuildRequires:  rsync
BuildRoot:      %{_tmppath}/%{name}-%{version}-build

%description

%prep
%setup -q

%build

%install
make install DESTDIR=%{buildroot} %{?_smp_mflags}

%post

%postun

%files
%defattr(-,root,root)
%config(noreplace) /etc/apache2/vhost.d/cephalix_include.conf
/usr/sbin/oss_*

