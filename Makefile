#
# Copyright (c) 2016 Peter Varkoly Nürnberg, Germany.  All rights reserved.
#
DESTDIR         = /
SHARE           = $(DESTDIR)/usr/share/oss/
FILLUPDIR       = /usr/share/fillup-templates/
TOPACKAGE       = Makefile etc plugins sbin
VERSION         = $(shell test -e ../VERSION && cp ../VERSION VERSION ; cat VERSION)
RELEASE         = $(shell cat RELEASE )
NRELEASE        = $(shell echo $(RELEASE) + 1 | bc )
REQPACKAGES     = $(shell cat REQPACKAGES)
HERE            = $(shell pwd)
REPO            = /data1/OSC/home:varkoly:CRANIX-4-2/
PACKAGE         = cephalix-client

install:
	mkdir -p $(DESTDIR)/usr/sbin/
	mkdir -p $(DESTDIR)/etc/
	install -m 755 sbin/* $(DESTDIR)/usr/sbin/
	rsync -a   etc/       $(DESTDIR)/etc/
	if [ -e plugins ] ; then rsync -a plugins/ $(SHARE)/plugins/ ; fi

dist:
	if [ -e $(PACKAGE) ] ;  then rm -rf $(PACKAGE) ; fi   
	mkdir $(PACKAGE)
	for i in $(TOPACKAGE); do \
	    cp -rp $$i $(PACKAGE); \
	done
	find $(PACKAGE) -type f > files;
	tar jcpf $(PACKAGE).tar.bz2 -T files;
	rm files
	rm -rf $(PACKAGE)
	if [ -d $(REPO)/$(PACKAGE) ] ; then \
            cd $(REPO)/$(PACKAGE); osc up; cd $(HERE);\
            mv $(PACKAGE).tar.bz2 $(REPO)/$(PACKAGE); \
            cd $(REPO)/$(PACKAGE); \
            osc vc; \
            osc ci -m "New Build Version"; \
        fi

