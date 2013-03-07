universe        = vanilla
executable      = /usr/bin/python
 
output          = /dev/null
input           = /dev/null
error           = /dev/null
 
log             = /dev/null
 
arguments       = "/vol/bitbucket/tr111/Prolog-War-of-Life/condor_prolog_multiprocess.py"

requirements = regexp("^(edge|fusion|glyph|matrix|visual)..", TARGET.Machine

queue 100
