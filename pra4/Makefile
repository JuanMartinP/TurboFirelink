all: p4.com

p4.com: p4a.obj
	tlink /t p4a.obj

p4a.obj: p4a.asm
	tasm /zi p4a.asm,,p4a.lst

clean:
	del *.obj
	del *.exe
	del *.lst