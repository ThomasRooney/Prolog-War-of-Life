universe        = vanilla
executable      = /usr/bin/python
 
output          = /dev/null
input           = /dev/null
error           = /dev/null
 
log             = /dev/null
 
arguments       = "/vol/bitbucket/tr111/Prolog-War-of-Life/condor_prolog_multiprocess.py"

### If using overnight, reqire stuff, else simply use condor_release -all regularly
## requirements = regexp("^(pixel|edge|fusion|glyph|matrix|visual|project)..", TARGET.Machine)

queue 500
