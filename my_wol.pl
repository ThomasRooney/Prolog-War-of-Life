:- ensure_loaded( 'war_of_life.pl'),
   use_module(library(system)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wrapper for play, run's multiple games
test_strategy(N, FirstPlayerStrategy, SecondPlayerStrategy) :-
  integer(N),
  write('--------- War of Life ---------'), write('\n'),
  write('First Player Strategy : '), write(FirstPlayerStrategy), write('\n'),
  write('Second Player Strategy: '), write(SecondPlayerStrategy), write('\n'),
  play_list(N, FirstPlayerStrategy, SecondPlayerStrategy, MovesList, WinnerList, RunningTimeList),
  count(b, WinnerList, P1Wins),
  count(r, WinnerList, P2Wins),
  max(MovesList, LongestGame),
  min(MovesList, ShortestGame),
  mean(RunningTimeList, AverageGameTime),
  mean(MovesList, AverageGameLength),
  write('Player 1 Wins: '), write(P1Wins), write('\n'),
  write('Player 2 Wins: '), write(P2Wins), write('\n'),
  write('Longest Game: '), write(LongestGame), write(' moves\n'),
  write('Shortest Game: '), write(ShortestGame), write(' moves\n'),
  write('Average Game Length: '), write(AverageGameLength), write(' moves \n'),
  write('Average Game Time: '), write(AverageGameTime), write(' seconds \n'),
  write('-------------------------------'), write('\n').

play_list(0, _, _, [], [], []).

play_list(N, FirstPlayerStrategy, SecondPlayerStrategy, [Moves | MovesList], [Winner | WinnerList], [RunningTime | RunningTimeList]) :-
  N > 0,
  now(InitialTime),
  play(quiet, FirstPlayerStrategy, SecondPlayerStrategy, Moves, Winner),
  now(EndTime),
  RunningTime is EndTime - InitialTime,
  NDec is N - 1,
  play_list(NDec, FirstPlayerStrategy, SecondPlayerStrategy, MovesList, WinnerList, RunningTimeList).


count(_, [], 0) :- !.
count(X, [X|T], N) :- 
    count(X, T, N2), 
    N is N2 + 1.     

count(X, [Y|T], N) :- 
    X \= Y,          
    count(X, T, N).  

sum( [], 0 ).
sum( [V|L], Sum ) :-
    sum( L, SumL ),
    Sum is SumL + V.

min([A],A).
min([A,B|L], Min) :-
  A < B -> min([A|L], Min);
  min([B|L], Min).

max([A],A).
max([A,B|L], Min) :-
  A > B -> max([A|L], Min);
  max([B|L], Min).

mean(ListVals, Mean) :-
  length(ListVals, Length),
  sum(ListVals, Sum),
  Mean is Sum / Length.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 500 Games - Player 1 wins 234, Player 2 wins 232 Therefore:
%% no.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Utility function
% calculate possible moves for a given Player
calc_possible_moves(P, [BlueCells, RedCells], PossibleMoves) :-
  findall([A, B, NewA, NewB],
       (member([A, B], P),
        neighbour_position(A,B,[NewA,NewB]), % 
        \+ member([NewA, NewB], RedCells),  % Can't occupy an occupied cell
        \+ member([NewA, NewB], BlueCells)),
        PossMoves),

%% Bloodlust Strategy

bloodlust(PlayerColour, [BlueCells,RedCells], NextBoard, PlayerMove) :-
  calc_possible_moves(PlayerColour, BoardState, PossibleMoves),

