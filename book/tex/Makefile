LUALATEX = /Library/TeX/texbin/lualatex --halt-on-error --synctex=1 --shell-escape --interaction=nonstopmode

all: prepare first second

first:
	ulimit -n 1024 && $(LUALATEX) -output-directory=build main.tex

second:
	ulimit -n 1024 && $(LUALATEX) -output-directory=build main.tex

prepare:
	mkdir build
	mkdir build/lectures
	for i in {'L1','L2','L3','L4','L5','L6','L7','L8','L9','L10','L11','L12'}; do mkdir "build/lectures/$$i"; done;

clean:
	rm -rf build
	rm -f main.aux main.out main.pyg main.synctex.gz main.toc path.log pygmentize.spec

build: clean prepare all
