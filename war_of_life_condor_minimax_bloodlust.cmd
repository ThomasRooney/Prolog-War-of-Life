universe        = vanilla
executable      = /usr/bin/sicstus
 
output          = /vol/bitbucket/tr111/Prolog-War-of-Life/minimax_bloodlust.$(Process).out
input           = /dev/null
error           = /vol/bitbucket/tr111/Prolog-War-of-Life/minimax_bloodlust.$(Process).err
 
log             = /vol/bitbucket/tr111/Prolog-War-of-Life/minimax_bloodlust.log
 
arguments       = "-l '/vol/bitbucket/tr111/Prolog-War-of-Life/my_wol.pl' --goal 'test_strategy(500,minimax,bloodlust).'"
 
queue 1
