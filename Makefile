.PHONY: all clean install build
all: build doc

J=4

export OCAMLRUNPARAM=b

setup.bin: setup.ml
	@ocamlopt.opt -o $@ $< || ocamlopt -o $@ $< || ocamlc -o $@ $<
	@rm -f setup.cmx setup.cmi setup.o setup.cmo

setup.data: setup.bin
	@./setup.bin -configure --enable-tests

build: setup.data setup.bin rrdd/version.ml
	@./setup.bin -build -j $(J)

doc: setup.data setup.bin
	@./setup.bin -doc -j $(J)

install: build
	install -m 755 xcp_rrdd.native $(DESTDIR)$(SBINDIR)/xcp-rrdd

uninstall:
	rm -f $(DESTDIR)$(SBINDIR)/xcp-rrdd

test: setup.bin build
	@./setup.bin -test

rrdd/version.ml: VERSION
	echo "let version = \"$(shell cat VERSION)\"" > rrdd/version.ml

clean:
	@ocamlbuild -clean
	@rm -f setup.data setup.log setup.bin
