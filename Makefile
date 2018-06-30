DESTDIR =
PREFIX=/usr/local
BINDIR = $(DESTDIR)$(PREFIX)/bin
INSTALL_DIR=$(PREFIX)/bin
AMBER_SYSTEM=$(INSTALL_DIR)/amber
INSTALL = /usr/bin/install

OUT_DIR=$(shell pwd)/bin
AMBER=$(OUT_DIR)/amber
AMBER_SOURCES=$(shell find src/ -type f -name '*.cr')

all: build

build: lib $(AMBER)

lib:
	@shards install --production

$(AMBER): $(AMBER_SOURCES) | $(OUT_DIR)
	@echo "Building amber in $@"
	@crystal build -o $@ src/amber/cli.cr -p --no-debug

$(OUT_DIR) $(INSTALL_DIR):
	@mkdir -p $@

run:
	$(AMBER)

install: build | $(INSTALL_DIR)
	$(INSTALL) -m 0755 -d "$(BINDIR)"
	$(INSTALL) -m 0755 bin/amber "$(BINDIR)"

uninstall:
	rm -f "$(BINDIR)/amber"

link: build | $(INSTALL_DIR)
	@echo "Symlinking $(AMBER) to $(AMBER_SYSTEM)"
	@ln -s $(AMBER) $(AMBER_SYSTEM)

force_link: build | $(INSTALL_DIR)
	@echo "Symlinking $(AMBER) to $(AMBER_SYSTEM)"
	@ln -sf $(AMBER) $(AMBER_SYSTEM)

clean:
	rm -rf $(AMBER)

distclean:
	rm -rf $(AMBER) .crystal .shards libs lib

test:
