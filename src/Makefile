lumos.pdf: lumos.asy
	asy -f pdf lumos.asy
	open lumos.pdf
abcd.pdf: abcd.asy
	asy -f pdf abcd.asy
	open abcd.pdf
compile:
	asy -f pdf splitting.asy
see: compile
	open splitting.pdf
clean:
	-rm *pdf 
	-rm -rf splitting_plot

build:
	test -d ../build/ || mkdir ../build
	./build.sh
