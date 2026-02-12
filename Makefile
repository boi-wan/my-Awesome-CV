.PHONY: all init-submodules clean docker-build docker-shell cv.pdf

# Main document
TEX := my-cv.tex
PDF := $(TEX:.tex=.pdf)

# XeLaTeX command (--shell-escape is needed to read env vars in LaTeX)
CC := xelatex -halt-on-error -interaction=nonstopmode --shell-escape

# Docker image
DOCKER_IMAGE := texlive/texlive:latest
WORKDIR := /workdir

# Auto-detect Docker
ifeq ($(shell command -v docker 2>/dev/null),)
  USE_DOCKER := false
else
  USE_DOCKER := true
endif

all: init-submodules cv.pdf

init-submodules:
	git submodule update --init --recursive

cv.pdf:
ifdef USE_DOCKER
	docker run --rm \
	  -e CV_EMAIL="$$CV_EMAIL" \
	  -e CV_PHONE="$$CV_PHONE" \
	  -v $$PWD:$(WORKDIR) \
	  -w $(WORKDIR) \
	  $(DOCKER_IMAGE) \
	  /bin/sh -c '\
	    mkdir -p /usr/local/share/fonts/source-sans && \
	    cp $(WORKDIR)/adobe-fonts/source-sans/TTF/*.ttf /usr/local/share/fonts/source-sans/ && \
	    apt-get update -qq && apt-get install -y -qq fonts-roboto >/dev/null 2>&1 && \
	    fc-cache -f && \
	    $(CC) $(TEX) && $(CC) $(TEX)'
else
	$(CC) $(TEX) && $(CC) $(TEX)
endif

clean:
ifdef USE_DOCKER
	docker run --rm \
	  -v $$PWD:$(WORKDIR) \
	  -w $(WORKDIR) \
	  $(DOCKER_IMAGE) \
	  /bin/sh -c 'rm -f *.pdf *.aux *.log *.out *.fls *.fdb_latexmk'
else
	rm -f *.pdf *.aux *.log *.out *.fls *.fdb_latexmk
endif

docker-build:
	docker pull $(DOCKER_IMAGE)

docker-shell:
	docker run --rm -it \
	  -v $$PWD:$(WORKDIR) \
	  -w $(WORKDIR) \
	  $(DOCKER_IMAGE) \
	  /bin/sh
