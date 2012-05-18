minlist([X | Xs], Y) :- minlist(Xs, X, Y).
minlist([], CurrMin, CurrMin).
minlist([X | Xs], CurrMin, Result) :-
        X < CurrMin,
        minlist(Xs, X, Result).
minlist([X | Xs], CurrMin, Result) :-
        X >= CurrMin,
        minlist(Xs, CurrMin, Result).

/*
minlist([2, 3, 1, 10, 15, 6, 2], X).

X = 1 ? 


yes
| ?-
*/
