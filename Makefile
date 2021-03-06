
NAME=acme

SRC = Acme.ml
LIB = $(patsubst %.ml,%.cma,$(SRC))
LIBX = $(patsubst %.ml,%.cmxa,$(SRC))
LIBOBJ = $(patsubst %.ml,%.cmo,$(SRC))
LIBXOBJ = $(patsubst %.ml,%.cmx,$(SRC))
LIBCMI = $(patsubst %.ml,%.cmi,$(SRC))
LIBA = $(patsubst %.ml,%.a,$(SRC))

REQUIRES=o9p str

all: $(LIB) $(LIBX)

.PHONY: install
install: all
	ocamlfind install $(NAME) $(LIB) $(LIBCMI) $(LIBA) $(LIBX) META

.PHONY: uninstall
uninstall:
	ocamlfind remove $(NAME)

$(LIB): $(LIBCMI) $(LIBOBJ)
	ocamlfind ocamlc -a -o $@ -package "$(REQUIRES)" $(LIBOBJ)

$(LIBX): $(LIBCMI) $(LIBXOBJ)
	ocamlfind ocamlopt -a -o $@ -package "$(REQUIRES)" $(LIBXOBJ)

%.cmo: %.ml
	ocamlfind ocamlc -c $(INCLUDES) -package "$(REQUIRES)" $<

%.cmi: %.mli
	ocamlfind ocamlc -c $(INCLUDES) -package "$(REQUIRES)" $<

%.cmx: %.ml
	ocamlfind ocamlopt -c $(INCLUDES) -package "$(REQUIRES)" $<

.PHONY: clean
clean:
	rm -f *.cmo *.cmx *.cmi *.o \
	  $(LIB) $(LIBX) $(LIBA)
