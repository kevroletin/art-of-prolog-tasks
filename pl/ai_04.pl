/* state(WhereTheBoatIs, MissionariesOnLeft, CannibalsOnLeft)  */
/* move(MissionariesInBoat, CannibalsInBoat)                   */
/* batch(State, Moves)                                         */

:- op(40,xfx,\).
   
find_legal_move(batch(State, Moves), Visited, batch(State1, [Move|Moves])) :-
	move(State, Move),
	update(State, Move, State1),
	legal(State1),
	\+ member(State1, Visited).

solve_bfs(Moves) :-
        initial_state(Init),
        enqueue(batch(Init, []), Q\Q, Q1),
        solve_bfs(Q1, [], Moves).

solve_bfs(Q, _, _) :- empty(Q), !, fail.
solve_bfs(Q, _, Moves) :-
        dequeue(batch(State, Moves), Q, _),
        final_state(State).
solve_bfs(Q, Visited, Res) :-
        dequeue(batch(State, Moves), Q, Q1),
        enqueue_states(batch(State, Moves), [State | Visited], Q1, Q2),
        solve_bfs(Q2, [State | Visited], Res).

empty([]\[]).

enqueue_states(Batch, Visited, Xs\Ys, Xs\Zs) :-
        find_all_dl(NewBatch, find_legal_move(Batch, Visited, NewBatch), Ys\Zs), !.

initial_state(state(left, 3, 3)).

final_state(state(right, 0, 0)).

move(state(left,  M, _), move(1, 0)) :- M >= 1.
move(state(left,  _, C), move(0, 1)) :- C >= 1.
move(state(left,  M, C), move(1, 1)) :- M >= 1, C >= 1.
move(state(left,  M, _), move(2, 0)) :- M >= 2.
move(state(left,  _, C), move(0, 2)) :- C >= 2.
move(state(right, M, _), move(1, 0)) :- (3 - M) >= 1.
move(state(right, _, C), move(0, 1)) :- (3 - C) >= 1.
move(state(right, M, C), move(1, 1)) :- (3 - M) >= 1, (3 - C) >= 1.
move(state(right, M, _), move(2, 0)) :- (3 - M) >= 2.
move(state(right, _, C), move(0, 2)) :- (3 - C) >= 2.

update(state(left, M0, C0), move(MB, CB), state(right, M, C)):-
  M is M0 - MB, C is C0 - CB.
update(state(right, M0, C0), move(MB, CB), state(left, M, C)):-
  M is M0 + MB, C is C0 + CB.

/* Ensures that, on each bank, the cannibals are not outnumbered */
legal(state(_, 3, _)):-!.
legal(state(_, 0, _)):-!.
legal(state(_, M, M)).

/* Check solution */

show_solution([Init|States]) :-
        solve_bfs(Moves),
        initial_state(Init),
        map(Moves, Init, States).

map([Move|Xs], State, [NewState|Res]) :-
        update(State, Move, NewState),
        map(Xs, NewState, Res).
map([], _, []).

% ******************************************************************

/*	
    queue(S) :-
	S is a sequence of enqueue and dequeue operations,
	represented as a list of terms enqueue(X) and dequeue(X).
*/

:- op(40,xfx,\).

queue(S) :- queue(S,Q\Q).

queue([enqueue(X)|Xs],Q) :-
        enqueue(X,Q,Q1), queue(Xs,Q1).
queue([dequeue(X)|Xs],Q) :-
        dequeue(X,Q,Q1), queue(Xs,Q1).
queue([], _).

enqueue(X,Qh\[X|Qt],Qh\Qt).
dequeue(X,[X|Qh]\Qt,Qh\Qt).

%	Program 15.11:	A queue process

/*	
   find_all_dl(X,Goal,Instances) :- Instances is the multiset
	of instances of X for which Goal is true. The multiplicity
	of an element is the number of different ways Goal can be
	proved with it as an instance of X.
*/

:- op(40,xfx,\).

find_all_dl(X, Goal, _) :-
        asserta('$instance'('$mark')),
        Goal,
        asserta('$instance'(X)),
        fail.
find_all_dl(X, _, Xs\Ys) :-
        retract('$instance'(X)),
        reap(X,Xs\Ys), !.

reap(X,Xs\Ys) :-	
        X \== '$mark',
        retract('$instance'(X1)), ! ,
        reap(X1,Xs\[X|Ys]).
reap('$mark',Xs\Xs).

%	Program 16.3 : Implementing an all-solutions predicate using
%			difference-lists, assert and retract

