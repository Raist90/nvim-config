let current_compiler = "tsc"

CompilerSet makeprg=npx\ tsc\ --noEmit
CompilerSet errorformat=%f\ %#(%l\\,%c):\ %trror\ TS%n:\ %m,
		       \%trror\ TS%n:\ %m,
		       \%-G%.%#
