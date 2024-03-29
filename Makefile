#
# Copyright (c) 2022 Peter Varkoly Nürnberg, Germany.  All rights reserved.
#
DESTDIR         = /
SHARE           = $(DESTDIR)/usr/share/cranix/
FILLUPDIR       = /usr/share/fillup-templates/
TOPACKAGE       = Makefile etc tools sbin
VERSION         = $(shell test -e ../VERSION && cp ../VERSION VERSION ; cat VERSION)
RELEASE         = $(shell cat RELEASE )
NRELEASE        = $(shell echo $(RELEASE) + 1 | bc )
HERE            = $(shell pwd)
REPO            = /data1/OSC/home:pvarkoly:CRANIX
PACKAGE         = cephalix-client

install:
	mkdir -p $(DESTDIR)/usr/sbin/
	mkdir -p $(DESTDIR)/etc/
	mkdir -p $(SHARE)/tools/
	install -m 755 sbin/*  $(DESTDIR)/usr/sbin/
	install -m 755 tools/* $(SHARE)/tools/
	rsync -a   etc/       $(DESTDIR)/etc/

dist:
	xterm -e git log --raw  &
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

