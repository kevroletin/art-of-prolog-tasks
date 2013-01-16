/*
   solve_best(Frontier,History,Moves) :-
      Moves is the sequence of moves to reach a desired final state 
	from the initial state, where Frontier contains the current 
	states under consideration, and History contains the states 
	visited previously.
*/

solve_best([state(State,Path,Value)|Frontier],History,Moves) :- 
	final_state(State),
        reverse(Path,Moves).
solve_best([state(State,Path,Value)|Frontier],History,FinalPath) :-
        findall(M,move(State,M),Moves),
        updates(Moves,Path,State,States),
        legals(States,States1),
        news(States1,History,States2),
        evaluates(States2,Values),
        inserts(Values,Frontier,Frontier1),
        solve_best(Frontier1,[State|History],FinalPath).

/*
  updates(Moves,Path,State,States) :-
  States is the list of possible states accessible from the 
  current State, according to the list of possible Moves,
  where Path is a path from the initial node to State.
*/

updates([Move|Moves],Path,State,[(State1,[Move|Path])|States]) :-
	update(State,Move,State1), updates(Moves,Path,State,States).
updates([],Path,State,[]).

/*
  legals(States,States1) :-
  States1 is the subset of the list of States that are legal.
*/

legals([(S,P)|States],[(S,P)|States1]) :-
	legal(S), legals(States,States1).
legals([(S,P)|States],States1) :-
	\+ legal(S), legals(States,States1).
legals([],[]).

/*
  news(States,History,States1) :-
  States1 is the list of states in States but not	in History.
*/
news([(State,Path)|States],History,States1) :-
	member(State,History), news(States,History,States1).
news([(State,Path)|States],History,[(State,Path)|States1]) :-
	\+ member(State,History), news(States,History,States1).
news([],History,[]).

/*
  evaluates(States,Values) :- 
  Values is the list of tuples of States augmented by their value.
*/
evaluates([(State,Path)|States],[state(State,Path,Value)|Values]) :-
	value(State,Value),
        evaluates(States,Values).
evaluates([],[]).

/*
  inserts(States,Frontier,Frontier1) :-
  Frontier1 is the result of inserting States into the current Frontier.
*/
inserts([Value|Values],Frontier,Frontier1) :-
	insert(Value,Frontier,Frontier0),
	inserts(Values,Frontier0,Frontier1).
inserts([],Frontier,Frontier).

insert(State,[],[State]).
insert(State,[State1|States],[State,State1|States]) :- 
	less_value(State,State1).        
insert(State,[State1|States],[State1|States1]) :-
	greatereq_value(State,State1), insert(State,States,States1).        

equals(state(S,P,V),state(S,P1,V)).

less_value(state(S1,P1,V1),state(S2,P2,V2)) :- S1 \== S2, V1 =< V2.

greatereq_value(state(S1,P1,V1),state(S2,P2,V2)) :- V1 >= V2.

solve_bfs(Moves) :-
        initial_state(State),
        solve_best([state(State,[],0)],[],Moves).

%  Program 20.6     Best first framework for problem solving


/*
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
*/

% Island (Five Jealous Husbands)
% DFS template

solve_dfs(batch(State, _), _, []) :-
  final_state(State).

solve_dfs(batch(State, Go), History, [Move|Moves]) :-
  move(State, Move),
  update(State, Move, State1),
  legal(State1),
  not(member(State1, History)),
  solve_dfs(batch(State1, [Move|Go]), [State1|History], Moves).

solve_dfs(Moves) :-
  initial_state(State),
  solve_dfs(batch(State, _), [State], Moves).

print_ans([]) :- print('---').
print_ans([X|Xs]) :-
        print_move(X),  
        print_ans(Xs).
print_move([]) :- print('\n').
print_move([X|Xs]) :-
        print_num(X),
        print_move(Xs).

print_num(11) :- print('h1 ').
print_num(12) :- print('h2 ').
print_num(13) :- print('h3 ').
print_num(14) :- print('h4 ').
print_num(15) :- print('h5 ').
print_num(21) :- print('w1 ').
print_num(22) :- print('w2 ').
print_num(23) :- print('w3 ').
print_num(24) :- print('w4 ').
print_num(25) :- print('w5 ').

% Problem
/* p(Boat, Isle, Bank)
* Boat - bank with boat (isle || bank)
* Isle - content of the island
* Bank - content of the bank
*/

%value(p(_, _, Xs), Res) :- length(Xs, Res).
value(p(_, _, Xs), 0).

initial_state(p(isle, [11, 12, 13, 14, 15, 21, 22, 23, 24, 25], [])).
final_state(p(mainland, [], [11, 12, 13, 14, 15, 21, 22, 23, 24, 25])).

% rest

rest([X|Xs], X, Xs).
rest([_|Xs], Y, Zs) :- rest(Xs, Y, Zs).

% move

move(p(isle, I, _), [P1]):-
  rest(I, P1, _).
move(p(isle, I, _), [P1, P2]):-
  rest(I, P1, I1), rest(I1, P2, _),
  legal_content([P1, P2]).
move(p(isle, I, _), [P1, P2, P3]):-
  rest(I, P1, I1), rest(I1, P2, I2), rest(I2, P3, _),
  legal_content([P1, P2, P3]).
move(p(mainland, _, M), [P1]):-
  rest(M, P1, _).
move(p(mainland, _, M), [P1, P2]):-
  rest(M, P1, M1), rest(M1, P2, _),
  legal_content([P1, P2]).
move(p(mainland, _, M), [P1, P2, P3]):-
  rest(M, P1, M1), rest(M1, P2, M2), rest(M2, P3, _),
  legal_content([P1, P2, P3]).

% legal_content

legal_content(Xs) :- only_wives(Xs), !.
legal_content(Xs) :- wives_with_husbands(Xs, Xs).

% only_wives

only_wives([]).
only_wives([W|Xs]) :- couple(_, W), only_wives(Xs).

% wives_with_husbands

wives_with_husbands([], _).
wives_with_husbands([H|Xs], Ys):-
  couple(H, _), !, wives_with_husbands(Xs, Ys).
wives_with_husbands([W|Xs], Ys):-
  couple(H, W), rest(Ys, H, _), !, wives_with_husbands(Xs, Ys).
  
% couple

couple(11, 21).
couple(12, 22).
couple(13, 23).
couple(14, 24).
couple(15, 25).

% update

update(p(isle, I, M), Boat, p(mainland, I1, M1)) :-
  ordered_delete(Boat, I, I1),
  ordered_insert(Boat, M, M1).
update(p(mainland, I, M), Boat, p(isle, I1, M1)) :-
  ordered_delete(Boat, M, M1),
  ordered_insert(Boat, I, I1).

% ordered_delete

ordered_delete([], Ys, Ys).
ordered_delete([X|Xs], [X|Ys], Zs) :- !,
  ordered_delete(Xs, Ys, Zs).
ordered_delete([X|Xs], [Y|Ys], Zs) :-
  X > Y, !, Zs = [Y|Ws], ordered_delete([X|Xs], Ys, Ws). %Zs is [Y|Ws].
ordered_delete([_|Xs], [Y|Ys], [Y|Zs]) :-
  ordered_delete(Xs, Ys, Zs).

% ordered_insert

ordered_insert([], Ys, Ys).
ordered_insert(Xs, [], Xs).
ordered_insert([X|Xs], [Y|Ys], Zs) :-
  X >= Y, !, Zs = [Y|Ws], ordered_insert([X|Xs], Ys, Ws).
ordered_insert([X|Xs], Ys, [X|Zs]) :-
  ordered_insert(Xs, Ys, Zs).

% legal

legal(p(_, Xs, Ys)) :-
  legal_content(Xs), legal_content(Ys).


% ******************************************************************

/*	
    queue(S) :-
p	S is a sequence of enqueue and dequeue operations,
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


