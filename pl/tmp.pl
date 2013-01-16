/*  
  solve_dfs(State,History,Moves) :-
      Moves is the sequence of moves to reach a desired final state 
	from the current State, where History contains the states 
	visited previously.
*/
solve_dfs(State,History,[]) :- 
	final_state(State).
solve_dfs(State,History,[Move|Moves]) :-
	move(State,Move),
	update(State,Move,State1),
	legal(State1),
	\+ member(State1,History),
	solve_dfs(State1,[State1|History],Moves).

/*  Testing the framework	*/

test_dfs(Moves) :-
        initial_state(State),
        solve_dfs(State,[State],Moves).

%  Program 20.1  A depth-first state-transition framework for problem solving


/* state(WhereTheBoatIs, [H1, W1, H2, W2, ...]) */

initial_state(state(left, [1, 1, 1, 1, 1, 1, 1, 1, 1, 1])).
final_state(state(right, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])).

leave_exact([], _, 0, []).
leave_exact([Num | Arr], Num, Cnt, [Num | Res]) :-
        >(Cnt, 0),
        Cnt1 is Cnt - 1,
        leave_exact(Arr, Num, Cnt1, Res).
leave_exact([Num | Arr], Num, Cnt, [INum | Res]) :-
        invert(Num, INum),
        leave_exact(Arr, Num, Cnt, Res).
leave_exact([NotNum | Arr], Num, Cnt, [NotNum | Res]) :-
        \==(NotNum, Num),
        leave_exact(Arr, Num, Cnt, Res).

change_mask([], [], []).
change_mask([X|Xs], [Y|Ys], [Eq|Res]) :-
        n_is_eq(X, Y, Eq),
        change_mask(Xs, Ys, Res).
n_is_eq(X, X, 0) :- !.
n_is_eq(_, _, 1).

apply_change([], [], []).
apply_change([X|Xs], [1|Ys], [I|Res]) :- !,
        invert(X, I),
        apply_change(Xs, Ys, Res).
apply_change([X|Xs], [0|Ys], [X|Res]) :- apply_change(Xs, Ys, Res).

get_nth([X|_], 0, X) :- !.
get_nth([_|Xs], Num, Res) :-
        Num1 is Num - 1,
        get_nth(Xs, Num1, Res).

get_husb(state(_, Arr), Num, Res) :-
        I is Num * 2,
        get_nth(Arr, I, Res).
get_wife(state(_, Arr), Num, Res) :-
        I is Num * 2 - 1,
        get_nth(Arr, I, Res).

wife_ok(State, Num) :- !,
        get_husb(State, Num, I),
        get_wife(State, Num, I).

wife_ok(State, Num) :-
        get_wife(State, Num, Side),
        invert(Side, ISide),
        get_husb(State, Num, ISide),
        get_husb(State, Num, ISide),
        get_husb(State, Num, ISide),
        get_husb(State, Num, ISide),
        get_husb(State, Num, ISide).
        
side_is_ok(State) :-
        wife_ok(State, 0),
        wife_ok(State, 1),
        wife_ok(State, 2),
        wife_ok(State, 3),
        wife_ok(State, 4).


test(t1) :-
        side_is_ok(state(left,
                         [ 0, 0,
                           0, 0,
                           0, 0,
                           0, 0,
                           0, 0])).
                  
test(t2) :-
        side_is_ok([ 0, 0,
                     1, 1,
                     0, 0,
                     1, 1,
                     0, 0]).

test(t3) :-
        side_is_ok([ 0, 0,
                     0, 1,
                     0, 0,
                     0, 1,
                     0, 0]).



%move(state(left, H, W), move(HM, WM)) :-
        
        
        
%/*
%move(p(isle, I, _), move([], [])):-       /* Move one person from isle to bank     */
%  rest(I, P1, _).
%move(p(isle, I, _), [P1,P2]):-    /* Move two people from isle to bank     */
%  rest(I, P1, I1), rest(I1, P2, _), 
%  legal_1([P1,P2]).
%move(p(isle, I, _), [P1,P2,P3]):- /* Move three people from isle to bank   */
%  rest(I, P1, I1), rest(I1, P2, I2), rest(I2, P3, _), 
%  legal_1([P1,P2,P3]).
%move(p(bank, _, B), [P1]):-       /* Move one person from bank to isle     */
%  rest(B, P1, _).
%move(p(bank, _, B), [P1,P2]):-    /* Move two people from bank to isle     */
%  rest(B, P1, B1), rest(B1, P2, _), 
%  legal_1([P1,P2]).
%move(p(bank, _, B), [P1,P2,P3]):- /* Move three people from bank to isle   */
%  rest(B, P1, B1), rest(B1, P2, B2), rest(B2, P3, _), 
%  legal_1([P1,P2,P3]).
%*/
update(state(Side, H, W), move([HM, WM]), state(SideR, HR, WR)):-
        invert(Side, SideR),
        invert(H, HM, HR),
        invert(W, WM, WR).

invert(0, 1).
invert(1, 0).
invert(right, left).
invert(left, right).
invert([X|Xs], [Y|Ys]) :-
        invert(X, Y),
        invert(Xs, Ys).
invert([], []).

        
legal(p(_, Xs, Ys)):-legal_1(Xs), legal_1(Ys).

legal_1(Xs):-only_wives(Xs), !.
legal_1(Xs):-wives_with_husbands(Xs, Xs).

only_wives([]).
only_wives([W|Xs]):-couple(_, W), only_wives(Xs).

wives_with_husbands([], _).
wives_with_husbands([H|Xs], Ys):-
  couple(H, _), !, wives_with_husbands(Xs, Ys).
wives_with_husbands([W|Xs], Ys):-
  couple(H, W), rest(Ys, H, _), !, wives_with_husbands(Xs, Ys).
  
couple(h1,w1).
couple(h2,w2).
couple(h3,w3).
couple(h4,w4).
couple(h5,w5). 

/* ordered_delete(Xs, Ys, Zs) is true if Zs is the ordered list obtained   */
/*   by deleting the ordered list Xs from the ordered list Ys.             */
ordered_delete([], Ys, Ys).
ordered_delete([X|Xs], [X|Ys], Zs):-!,
  ordered_delete(Xs, Ys, Zs).
ordered_delete([X|Xs], [Y|Ys], Zs):-
  X > Y, !, Zs = [Y|Ws], ordered_delete([X|Xs], Ys, Ws).
ordered_delete([_|Xs], [Y|Ys], [Y|Zs]):-
  ordered_delete(Xs, Ys, Zs).

/* ordered_insert(Xs, Ys, Zs) is true if Zs is the ordered list obtained   */
/*   by inserting the ordered list Xs in the ordered list Ys.              */
ordered_insert([], Ys, Ys).
ordered_insert([X|Xs], [Y|Ys], Zs):-
  Y =< X, !, Zs = [Y|Ws], ordered_insert([X|Xs], Ys, Ws).
ordered_insert([X|Xs], Ys, [X|Zs]):-
  ordered_insert(Xs, Ys, Zs).

/* rest(Xs, Y, Zs) is true if Zs is the list of elements following the     */
/*   element Y in the list Xs.                                             */
rest([X|Xs], X, Xs).
rest([_|Xs], Y, Zs):-rest(Xs, Y, Zs).

/* length(Xs, L0, L) is true if L is equal to L0 plus the number of        */
/*   elements in the list Xs.                                              */
length([], L, L).
length([_|Xs], L0, L):-L1 is L0 + 1, length(Xs, L1, L).
