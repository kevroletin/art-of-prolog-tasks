/*
    transform(State1,State2,Plan) :-
	Plan is a plan of actions to transform State1 into State2. */

contain(add(A, _), A).
contain(add(_, A), A).
contain(sub(A, _), A).
contain(sub(_, A), A).

transform(State1,State2,Plan) :- 
        transform(State1,State2,[State1],Plan).

transform(State,State,_,[]).
transform(State1,State2,Visited,[Action|Actions]) :-
   legal_action(Action,State1),
%        choose_action(Action, State1, State2),
        update(Action,State1,State), 
        \+ member(State,Visited),
        transform(State,State2,[State|Visited],Actions).

choose_action(Action, State1, State2) :-
        suggeset(Action, State2),
        legal_action(Action, State1).
choose_action(Action, State1, _) :-
        legal_action(Action, State1).
suggeset(to_place(X, _, Z), State) :-
        member(on(X, Z), State), place(Z).
suggeset(to_block(X, _, Z), State) :-
        member(on(X, Z), State), block(Z).

get_data(Reg, [reg(Reg, Data) | _], Data).
get_data(Reg, [reg(AnothreReg, _)| Xs], Data) :-
        \==(AnothreReg, Reg),
        get_data(Reg, Xs, Data).

set_data(Reg, NewData, [reg(Reg, _) | Xs], [reg(Reg, NewData) | Xs]).
set_data(Reg, NewData, [reg(AnothreReg, Data) | Xs], [reg(AnothreReg, Data) | Res]) :-
        Reg \== AnothreReg,
        set_data(Reg, NewData, Xs, Res).     

substruct(A, A, 0).
substruct(A, B, sub(A, B)) :- A \== B.

perform_action(add(Reg), State, NewState) :-
        Reg \== accum,
        get_data(Reg, State, RegData),
        get_data(accum, State, AccumData),
        set_data(accum, add(AccumData, RegData), State, NewState).

perform_action(sub(Reg), State, NewState) :-
        Reg \== accum,
        get_data(Reg, State, RegData),
        get_data(accum, State, AccumData),
        substruct(AccumData, RegData, SubsRes),
        set_data(accum, SubsRes, State, NewState).

perform_action(load(Reg), State, NewState) :-
        Reg \== accum,
        get_data(Reg, State, RegData),
        set_data(accum, RegData, State, NewState).

perform_action(store(Reg), State, NewState) :-
        Reg \== accum,
        get_data(accum, State, AccumData),
        set_data(Reg, AccumData, State, NewState).

perform_actions([], State, State).
perform_actions([Act | Xs], State, NewState) :-
        perform_action(Act, State, State2),
        perform_actions(Xs, State2, NewState).

unit_test_data(_, [reg(accum, 0), reg(r1, c1), reg(r2, c2), reg(r3, c3), reg(r4, c4)]).
unit_test_actions(test1, [load(r1)]).
unit_test_actions(test2, [store(r1)]).
unit_test_actions(test3, [load(r1), add(r2)]).
unit_test_actions(test4, [load(r1), sub(r2)]).
unit_test_actions(test5, [load(r1), add(r2), add(r3)]).
unit_test_actions(test6, [load(r1), add(r2), add(r3), store(r4)]).
unit_test_actions(test7, [load(r1), add(r2), sub(r2)]).
unit_test_actions(test8, [load(r1), add(r2), add(r3), store(r4), sub(r4)]).
unit_test_result(test1, [reg(accum, c1), reg(r1, c1), reg(r2, c2), reg(r3, c3), reg(r4, c4)]).
unit_test_result(test2, [reg(accum, 0), reg(r1, 0), reg(r2, c2), reg(r3, c3), reg(r4, c4)]).
unit_test_result(test3, [reg(accum, add(c1, c2)), reg(r1, c1), reg(r2, c2), reg(r3, c3), reg(r4, c4)]).
unit_test_result(test4, [reg(accum, sub(c1, c2)), reg(r1, c1), reg(r2, c2), reg(r3, c3), reg(r4, c4)]).
unit_test_result(test5, [reg(accum, add(add(c1, c2), c3)), reg(r1, c1), reg(r2, c2), reg(r3, c3), reg(r4, c4)]).
unit_test_result(test6, [reg(accum, add(add(c1, c2), c3)), reg(r1, c1), reg(r2, c2), reg(r3, c3), reg(r4, add(add(c1, c2), c3))]).
unit_test_result(test7, [reg(accum, sub(add(c1, c2), c2)), reg(r1, c1), reg(r2, c2), reg(r3,c3), reg(r4,c4)]).
unit_test_result(test8, [reg(accum, 0), reg(r1, c1), reg(r2, c2), reg(r3, c3), reg(r4, add(add(c1, c2), c3))]).


unit_test_get_res(Test, Res) :-
        unit_test_data(Test, Data),
        unit_test_actions(Test, Acts),
        perform_actions(Acts, Data, Res).
unit_test(Test) :-
        unit_test_get_res(Test, Res),
        unit_test_result(Test, GoodRes),
        Res == GoodRes.

unit_tests(_) :-
        unit_test(test1),
        unit_test(test2),
        unit_test(test3),
        unit_test(test4),
        unit_test(test5).
        


%perform_action(load(r1), [reg(accum, 0), reg(r1, c1), reg(r2, c2), reg(r3, c3), reg(r4, c4)], Res).

clear(X,State) :- \+ member(on(_,X),State).
on(X,Y,State) :- member(on(X,Y),State).

update(to_block(X,Y,Z),State,State1) :-
        substitute(on(X,Y),on(X,Z),State,State1).
update(to_place(X,Y,Z),State,State1) :-
        substitute(on(X,Y),on(X,Z),State,State1).

substitute(X,Y,[X|Xs],[Y|Xs]).
substitute(X,Y,[X1|Xs],[X1|Ys]) :- X \== X1, substitute(X,Y,Xs,Ys).


%	Program 14.11: A depth-first planner

  /*  Testing and data  

test_plan(Name,Plan) :-
        initial_state(Name,I), final_state(Name,F), transform(I,F,Plan).

initial_state(test,[on(a,b),on(b,p),on(c,r)]).
final_state(test,[on(a,b),on(b,c),on(c,r)]).

block(a).	block(b).	block(c).
place(p).	place(q).	place(r).

%	Program 14.12: Testing the depth-first planner


/*
    transform(State1,State2,Plan) :-
	Plan is a plan of actions to transform State1 into State2.

transform(State1,State2,Plan) :- 
        transform(State1,State2,[State1],Plan).

transform(State,State,_,[]).
transform(State1,State2,Visited,[Action|Actions]) :-
%   legal_action(Action,State1),
        choose_action(Action, State1, State2),
        update(Action,State1,State), 
        \+ member(State,Visited),
        transform(State,State2,[State|Visited],Actions).

choose_action(Action, State1, State2) :-
        suggeset(Action, State2),
        legal_action(Action, State1).
choose_action(Action, State1, _) :-
        legal_action(Action, State1).
suggeset(to_place(X, _, Z), State) :-
        member(on(X, Z), State), place(Z).
suggeset(to_block(X, _, Z), State) :-
        member(on(X, Z), State), block(Z).

legal_action(to_place(Block,Y,Place),State) :- 
        on(Block,Y,State), clear(Block,State), place(Place), clear(Place,State).
legal_action(to_block(Block1,Y,Block2),State) :- 
        on(Block1,Y,State), clear(Block1,State), block(Block2), 
        Block1 \== Block2, clear(Block2,State).

clear(X,State) :- \+ member(on(_,X),State).
on(X,Y,State) :- member(on(X,Y),State).

update(to_block(X,Y,Z),State,State1) :-
        substitute(on(X,Y),on(X,Z),State,State1).
update(to_place(X,Y,Z),State,State1) :-
        substitute(on(X,Y),on(X,Z),State,State1).

substitute(X,Y,[X|Xs],[Y|Xs]).
substitute(X,Y,[X1|Xs],[X1|Ys]) :- X \== X1, substitute(X,Y,Xs,Ys).


%	Program 14.11: A depth-first planner

  /*  Testing and data  

test_plan(Name,Plan) :-
        initial_state(Name,I), final_state(Name,F), transform(I,F,Plan).

initial_state(test,[on(a,b),on(b,p),on(c,r)]).
final_state(test,[on(a,b),on(b,c),on(c,r)]).

block(a).	block(b).	block(c).
place(p).	place(q).	place(r).

%	Program 14.12: Testing the depth-first planner
*/
