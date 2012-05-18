subterm(Term, Term).

subterm(Sub, Term) :-
        compound(Term),
        functor(Term, _, N),
        subterm(Sub, Term, N).

subterm(Sub, Term, N) :-
        N > 1,
        N1 is N - 1,
        subterm(Sub, Term, N1).

subterm(Sub, Term, N) :-
        arg(N, Term, Arg),
        subterm(Sub, Arg).

:- begin_tests(subterm).

test(test01) :-
        subterm(null, null), !.
test(test02) :-
        subterm(node(null, null), node(1, node(null, null))), !.
test(test03) :- \+
        subterm(null, not_null), !.
test(test04) :- \+
        subterm(node(1, 2), node(3, 4)), !.

:- end_tests(subterm).

ocurences(Sub, Term, N):-
        ocurences(Sub, Term, 0, N).

ocurences(Sub, Term, CurrnN, N):-
        compound(Term),
        functor(Term, _, ArgsCnt),
        ocurences(Sub, Term, ArgsCnt, CurrnN, N).

ocurences(Term, Term, CurrN, NewCurrN) :-
        NewCurrN is CurrN + 1.

ocurences(_, _, CurrN, CurrN).

ocurences(_, _, 0, CurrN, CurrN).

ocurences(Sub, Term, ArgNum, CurrN, N) :- 
        ArgNum > 0,
        compare(=, Sub, Term),
        NewCurrN is CurrN + 1,
        NextArg is ArgNum - 1,
        ocurences(Sub, Term, NextArg, NewCurrN, N).

ocurences(Sub, Term, ArgNum, CurrN, N) :- 
        ArgNum > 0,
        \+ compare(=, Sub, Term),
        arg(ArgNum, Term, Arg),        
        ocurences(Sub, Arg, SubInArg),
        NewCurrN is CurrN + SubInArg,
        NextArg is ArgNum - 1,
        ocurences(Sub, Term, NextArg, NewCurrN, N).

:- begin_tests(ocurences).

test(t01) :-
        ocurences(a, a, 1), !.
test(t02) :-
        ocurences(a, b, 0), !.
test(t03) :-
        ocurences(a, [a, a], 2), !.
test(t04) :-
        ocurences(a, node(node(a, a), node(a, null)), 3), !.
test(t05) :-
        ocurences(a, node(null, null), 0).
test(t06) :-
        ocurences(node(a, b), node(node(a, b), node(a, node(a, b))), 2).

:- end_tests(ocurences).

position(Term, Term, []).

position(Sub, Term, Result) :-
        compound(Term),
        functor(Term, _, N),
        position(Sub, Term, N, Result).

position(Sub, Term, N, Result) :-
        N > 1,
        N1 is N - 1,
        position(Sub, Term, N1, Result).

position(Sub, Term, N, [N | Result]) :-
        arg(N, Term, Arg),
        position(Sub, Arg, Result).

:- begin_tests(position).

test(test01) :-
        position(null, null, []), !.
test(test02) :-
        position(a, node(a), [1]), !.
test(test03 [true(X cmp [2, 1], [2, 2])]) :-
        position(a, node(b,node(a,a)), X), !.
test(test04) :- \+
        position(a, node(b, c), X), !.

:- end_tests(position).

