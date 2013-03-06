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
  (P == 'r' -> PlayerCells = RedCells;
              PlayerCells = BlueCells),
  findall([A, B, NewA, NewB],
       (member([A, B], PlayerCells),
        neighbour_position(A, B, [NewA, NewB]), % 
        \+ member([NewA, NewB], RedCells),  % Can't occupy an occupied cell
        \+ member([NewA, NewB], BlueCells)),
        PossibleMoves).

run_move('r', [BlueCells, RedCells], Move, CrankedNewBoard) :-
  alter_board(Move, RedCells, NewRedCells),
  next_generation([BlueCells, NewRedCells], CrankedNewBoard).
  
run_move('b', [BlueCells, RedCells], Move, CrankedNewBoard) :-
  alter_board(Move, BlueCells, NewBlueCells),
  next_generation([NewBlueCells, RedCells], CrankedNewBoard).


%% Trace through all neighbour positons of a given A,B cell
% neighbour_position -- Realised Unneeded as it's already implemented
% neighbour_position(X, Y, NewX, NewY) :-
%   (X = NewX; X + 1 = NewX; X - 1 = NewX),
%   (Y = NewY; Y + 1 = NewY; Y - 1 = NewY),
%   NewX >= 0, NewX =< 8, NewY >= 0, NewY =< 8.


%%%%%
%% Utility Function for 1-Look-Ahead Strategies

%% Base case
pick_move_single_lookhead(PlayerColour, _, Board, [Move], CrankedNewBoard, [Move]) :-
  run_move(PlayerColour, Board, Move, CrankedNewBoard).

%% Recursive case  
pick_move_single_lookhead(PlayerColour, StategyBoardFitnessFunction, Board, [MoveA, MoveB | MoveList], CrankedNewBoard, ChosenMove) :-
  run_move(PlayerColour, Board, MoveA, CrankedNewBoardA),
  run_move(PlayerColour, Board, MoveB, CrankedNewBoardB),
  % Compare the two board states
  board_fitness_function(PlayerColour, StategyBoardFitnessFunction, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove),
  % Recurse Down
  pick_move_single_lookhead(PlayerColour, StategyBoardFitnessFunction, Board, [BestMove | MoveList], CrankedNewBoard, ChosenMove).

%% Support for 1 ply Strategies
board_fitness_function(PlayerColour, bloodlust_board_fitness, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove) :-
  bloodlust_board_fitness(PlayerColour, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove).
board_fitness_function(PlayerColour, self_preservation_board_fitness, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove) :-
  self_preservation_board_fitness(PlayerColour, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove).
board_fitness_function(PlayerColour, land_grab_board_fitness, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove) :-
  land_grab_board_fitness(PlayerColour, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove).
board_fitness_function(PlayerColour, minimax_board_fitness, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove) :-
  minimax_board_fitness(PlayerColour, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove).

opposite_colour('r', 'b').
opposite_colour('b', 'r').
%%%%%


%%%%%%%%
%% Bloodlust Strategy

bloodlust(PlayerColour, Board, NextBoard, PlayerMove) :-
  calc_possible_moves(PlayerColour, Board, PossibleMoves),
  pick_move_single_lookhead(PlayerColour, bloodlust_board_fitness, Board, PossibleMoves, NextBoard, PlayerMove).

%% Fitness function
bloodlust_board_fitness('b', MoveA, [_, RedA], MoveB, [_, RedB], BestMove) :-
  length(RedA, CountRedA),
  length(RedB, CountRedB),
  (CountRedA < CountRedB -> BestMove = MoveA; BestMove = MoveB).

bloodlust_board_fitness('r', MoveA, [BlueA, _], MoveB, [BlueB, _], BestMove) :-
  length(BlueA, CountBlueA),
  length(BlueB, CountBlueB),
  (CountBlueA < CountBlueB -> BestMove = MoveA; BestMove = MoveB).
%%%%%%%%%%%%%%%%
%%%%%%%%
%% Self Preservation strategy
%%%%%%%%

self_preservation(PlayerColour, Board, NextBoard, PlayerMove) :-
  calc_possible_moves(PlayerColour, Board, PossibleMoves),
  pick_move_single_lookhead(PlayerColour, self_preservation_board_fitness, Board, PossibleMoves, NextBoard, PlayerMove).

%% Fitness function
self_preservation_board_fitness('r', MoveA, [_, RedA], MoveB, [_, RedB], BestMove) :-
  length(RedA, CountRedA),
  length(RedB, CountRedB),
  (CountRedA > CountRedB -> BestMove = MoveA; BestMove = MoveB).

self_preservation_board_fitness('b', MoveA, [BlueA, _], MoveB, [BlueB, _], BestMove) :-
  length(BlueA, CountBlueA),
  length(BlueB, CountBlueB),
  (CountBlueA > CountBlueB -> BestMove = MoveA; BestMove = MoveB).
%%%%%%%%%%%%%%%%
%%%%%%%%
%% Land Grab strategy
%%%%%%%%

land_grab(PlayerColour, Board, NextBoard, PlayerMove) :-
  calc_possible_moves(PlayerColour, Board, PossibleMoves),
  pick_move_single_lookhead(PlayerColour, land_grab_board_fitness, Board, PossibleMoves, NextBoard, PlayerMove).

%% Fitness function
land_grab_board_fitness('r', MoveA, [BlueA, RedA], MoveB, [BlueB, RedB], BestMove) :-
  length(RedA, CountRedA),
  length(BlueA, CountBlueA),
  length(RedB, CountRedB),
  length(BlueB, CountBlueB),
  FitnessA is CountRedA - CountBlueA,
  FitnessB is CountRedB - CountBlueB,
  (FitnessA > FitnessB -> BestMove = MoveA; BestMove = MoveB).

land_grab_board_fitness('b', MoveA, [BlueA, RedA], MoveB, [BlueB, RedB], BestMove) :-
  length(RedA, CountRedA),
  length(BlueA, CountBlueA),
  length(RedB, CountRedB),
  length(BlueB, CountBlueB),
  FitnessA is CountBlueA - CountRedA,
  FitnessB is CountBlueB - CountRedB,
  (FitnessA > FitnessB -> BestMove = MoveA; BestMove = MoveB).
%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
%%%%%%%%
%% Naiive Minimax strategy
%%%%%%%%

minimax(PlayerColour, Board, NextBoard, PlayerMove) :-
  %% Look Ahead 1 :-
  findall([Move, LookAheadBoard],
         
          (
            %% For each of our moves, what would the opponent do?
            calc_possible_moves(PlayerColour, Board, PossibleMoves),
            member(PossibleMoves, Move),
            run_move(PlayerColour, Board, Move, CrankedBoard),
            opposite_colour(PlayerColour, OpponentColour),
            calc_possible_moves(OpponentColour, CrankedBoard, PossibleOpponentMoves),
            % Assume the opponent does minimax too
            pick_move_single_lookhead(OpponentColour, minimax_board_fitness,
              CrankedBoard, PossibleOpponentMoves, LookAheadBoard, _)
          ),
          PossibleMoveBoardList),
  %% Look through the moves, one move deep, for the best move via our fitness function.
  minimax_second_lookahead(PlayerColour, PossibleMoveBoardList, NextBoard, PlayerMove).

%% Base case, only one move.
minimax_second_lookahead(_, [Move, Board], Board, Move).

%% Recursive Case, top of two moves
minimax_second_lookahead(PlayerColour, [[MoveA1, BoardA],[MoveB1, BoardB]| MoveBoardTail], NewBoard, NewMove) :-
  calc_possible_moves(PlayerColour, BoardA, PossibleMovesA),
  calc_possible_moves(PlayerColour, BoardB, PossibleMovesB),
  %% Run each move
  pick_move_single_lookhead(PlayerColour, minimax_board_fitness, BoardA, PossibleMovesA, BoardA2, MoveA2),
  pick_move_single_lookhead(PlayerColour, minimax_board_fitness, BoardB, PossibleMovesB, BoardB2, MoveB2),
  %% Compare board_fitness_function
  minimax_board_fitness(PlayerColour, MoveA2, BoardA2, MoveB2, BoardB2, BestMove),
  (BestMove == MoveA2 -> 
    minimax_second_lookahead(PlayerColour, [[MoveA1, BoardA]| MoveBoardTail], NewBoard, NewMove)
    ;
    minimax_second_lookahead(PlayerColour, [[MoveB1, BoardB]| MoveBoardTail], NewBoard, NewMove)).

%% Fitness function is the same as land_grab's fitness function
minimax_board_fitness(PlayerColour, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove) :-
  land_grab_board_fitness(PlayerColour, MoveA, CrankedNewBoardA, MoveB, CrankedNewBoardB, BestMove).

%%%%%%%%%%%%%%%%

