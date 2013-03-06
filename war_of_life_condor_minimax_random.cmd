universe        = vanilla
executable      = /usr/bin/sicstus
 
output          = /vol/bitbucket/tr111/Prolog-War-of-Life/minimax_random.$(Process).out
input           = /dev/null
error           = /vol/bitbucket/tr111/Prolog-War-of-Life/minimax_random.$(Process).err
 
log             = /vol/bitbucket/tr111/Prolog-War-of-Life/minimax_random.log
 
arguments       = "-l '/vol/bitbucket/tr111/Prolog-War-of-Life/my_wol.pl' --goal 'test_strategy(500,minimax,random).'"
 
queue 1
