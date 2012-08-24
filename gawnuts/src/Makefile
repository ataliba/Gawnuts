# BlindSam MakeFile


TALKER			= gawnuts
CC			= gcc
PERMS			= 755

CFLAGS			= -pg -ggdb -O3 -Wall -Wpointer-arith -Wcast-qual -Wcast-align -Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline -Wshadow -Wtraditional 
LIBS			= -lcrypt
LDFLAGS			= 

# you do not need to alter any of the text below

install:	clean $(TALKER)

$(TALKER):	Makefile
	@echo "Linking server .."
	@$(CC) $(LDFLAGS) -o $(TALKER) $(TALKER).c $(LIBS)
	@echo "Installing server .."
	@chmod $(PERMS) $(TALKER)
	@echo "Made install."

clean:
	@rm -f $(TALKER)
	@echo "Made clean (removed objects)"
