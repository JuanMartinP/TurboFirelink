all: p4.exe 

p4.exe: p4a.obj
	tlink /v /t p4a.obj

p4a.obj: p4a.asm
	tasm /zi p4a.asm,,p4a.lst
