watch:
	@spago run --watch

build:
	@spago build --watch

repl:
	@spago repl

install:
	@spago install

debug:
	@node -e "require('./output/Main/index.js').main()" --inspect-brk
