solve_dfs(State, _, []) :- 
        final_state(State).
solve_dfs(State, History, [Move|Moves]) :-
	move(State,Move),
	update(State, Move, State1),
	legal(State1),
	\+ member(State1,History),
	solve_dfs(State1,[State1|History],Moves).

test_dfs(Problem, Moves) :-
        initial_state(Problem, State),
        solve_dfs(State, [State], Moves).

initial_state(alph, state([], Pattern)) :- pattern(Pattern).
final_state(state([], [])).

move(state(_, [_|_]), inc_prefix).
move(state([_|_], _), match_prefix).

update(state(Prefix, [X|Xs]), inc_prefix, state(NewPrefix, Xs)) :-
        append(Prefix, [X], NewPrefix).
update(state(Prefix, Suffix), match_prefix, state([], Suffix)) :-
        dict(D),
        member(Prefix, D).

legal(_).

show_solution(Moves, Res) :-
        initial_state(alph, State),
        show_solution(Moves, State, [], Res).

show_solution([], _, Res, Res).
show_solution([inc_prefix|Xs], State, CurrRes, Res) :-
        update(State, inc_prefix, NewState),
        show_solution(Xs, NewState, CurrRes, Res).
show_solution([match_prefix|Xs], state(Prefix, Suffix), CurrRes, Res) :-
        update(state(Prefix, Suffix), match_prefix, NewState),
        append(CurrRes, [Prefix], NewCurrRes),
        show_solution(Xs, NewState, NewCurrRes, Res).

dict([['c'], ['a', 't'],
      ['c', 'a', 't'],
      ['i', 's'],
      ['b', 'l', 'a', 'c', 'k']]).

pattern(['c', 'a', 't', 'i', 's', 'b', 'l', 'a', 'c', 'k']).
%pattern(['c', 'a', 't', 'i', 's', 'v', 'e', 'r', 'y', 'b', 'l', 'a', 'c', 'k']).
%pattern(['c', 'a', 't', 'i', 's', 'b', 'l', 'a', 'c', 'k', 'r', 'e', 'a', 'l', 'l', 'y']).

find_best_solution(Res) :-
        findall(X, test_dfs(alph, X), [Fst|Others]),
        choose_best(Others, Fst, Res).

words_cnt(Solution, Res) :-
        show_solution(Solution, Words),
        length(Words, Res).

choose_best([], Res, Res).
choose_best([X|Xs], CurrentBest, Res) :-
        words_cnt(X, NewLen),
        words_cnt(CurrentBest, BestLen),
        NewLen < BestLen,
        choose_best(Xs, X, Res).
choose_best([X|Xs], CurrentBest, Res) :-
        words_cnt(X, NewLen),
        words_cnt(CurrentBest, BestLen),
        NewLen >= BestLen,
        choose_best(Xs, CurrentBest, Res).
        
        
