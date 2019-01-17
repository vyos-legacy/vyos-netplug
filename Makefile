version := $(shell awk '/define version/{print $$3}' netplug.spec)

DESTDIR ?=

prefix ?=
bindir ?= $(prefix)/sbin
etcdir ?= $(prefix)/etc/netplug
initdir ?= $(prefix)/etc/rc.d/init.d
scriptdir ?= $(prefix)/etc/netplug
mandir ?= $(prefix)/usr/share/man

install_opts :=

CFLAGS += -Wall -std=gnu99 -DNP_ETC_DIR='"$(etcdir)"' \
	-DNP_SCRIPT_DIR='"$(scriptdir)"' -ggdb3 -O3 -DNP_VERSION='"$(version)"'

netplugd: config.o netlink.o lib.o if_info.o main.o
	$(CC) $(LDFLAGS) -o $@ $^

install:
	install -d $(install_opts) -m 755 \
	$(DESTDIR)/$(bindir) \
	$(DESTDIR)/$(etcdir) \
	$(DESTDIR)/$(scriptdir) \
	$(DESTDIR)/$(initdir) \
	$(DESTDIR)/$(mandir)/man8
	install $(install_opts) -m 755 netplugd $(DESTDIR)/$(bindir)
	install $(install_opts) -m 644 etc/netplugd.conf $(DESTDIR)/$(etcdir)
	install $(install_opts) -m 755 scripts/netplug $(DESTDIR)/$(scriptdir)
	install $(install_opts) -m 755 scripts/rc.netplugd $(DESTDIR)/$(initdir)/netplugd
	install $(install_opts) -m 444 man/man8/netplugd.8 $(DESTDIR)/$(mandir)/man8

clean:
	-rm -f netplugd *.o *.tar.bz2
