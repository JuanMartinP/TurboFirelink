all: p4a.exe p4b.exe

p4a.exe: p4a.obj
	tlink /t p4a.obj
	
p4b.exe: p4b.obj
	tlink /v p4b.obj

p4a.obj: p4a.asm
	tasm /zi p4a.asm
	
p4b.obj: p4b.asm
	tasm /zi p4b.asm

clean:
	del *.obj
	del *.exe
	del *.lst