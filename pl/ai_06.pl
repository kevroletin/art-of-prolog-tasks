
solve_dfs(State, _,[]) :- 
	final_state(State).
solve_dfs(State,History,[Move|Moves]) :-
	move(State,Move),
	update(State,Move,State1),
	legal(State1),
	\+ member(State1,History),
	solve_dfs(State1,[State1|History],Moves).

test_dfs(Moves) :-
        initial_state(State), solve_dfs(State,[State],Moves).

initial_state(jugs(0,0)).

final_state(jugs(4,_)).            
final_state(jugs(_,4)).

move(jugs(_,_),fill_and_transfer(1)).
move(jugs(_,_),fill(1)).	        
move(jugs(_,_),fill(2)).
move(jugs(_,_),empty(1)).	
move(jugs(_,_),empty(2)).
move(jugs(_,_),transfer(2,1)).	
move(jugs(_,_),transfer(1,2)).

update(jugs(V1,V2),fill_and_transfer(1), jugs(0,V)) :-
        capacity(1, C1),
        capacity(2, C2),
        >(C1, C2),
        V is (C1 + V2) mod C2.
update(jugs(_,V2),fill(1),jugs(C1,V2)) :- capacity(1,C1).
update(jugs(V1,_),fill(2),jugs(V1,C2)) :- capacity(2,C2).
update(jugs(_,V2),empty(1),jugs(0,V2)).
update(jugs(V1,_),empty(2),jugs(V1,0)).
update(jugs(V1,V2),transfer(2,1),jugs(W1,W2)) :-
	capacity(1,C1),
	Liquid is V1 + V2,
	Excess is Liquid - C1,
	adjust(Liquid,Excess,W1,W2).
update(jugs(V1,V2),transfer(1,2),jugs(W1,W2)) :-
	capacity(2,C2),
        Liquid is V1 + V2,
        Excess is Liquid - C2,
        adjust(Liquid,Excess,W2,W1).

adjust(Liquid, Excess,Liquid,0) :- Excess =< 0.
adjust(Liquid,Excess,V,Excess) :- Excess > 0, V is Liquid - Excess.

legal(jugs(_,_)).

capacity(1,8).		
capacity(2,5).

%  Program 20.3    Solving the water jugs problem
