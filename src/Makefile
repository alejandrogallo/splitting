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
