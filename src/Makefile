lumos.pdf: lumos.asy
	asy -f pdf lumos.asy
	evince lumos.pdf
abcd.pdf: abcd.asy
	asy -f pdf abcd.asy
	open abcd.pdf
splitting.pdf: splitting.asy
	asy -f pdf splitting.asy
	open splitting.pdf

clean:
	-rm *pdf
	-rm -rf splitting_plot

build:
	test -d ../build/ || mkdir ../build
	./build.sh
