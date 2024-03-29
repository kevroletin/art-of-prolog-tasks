plus(X, Y, Z) :-
        nonvar(X), nonvar(Y), Z is X + Y.

plus(X, Y, Z) :-
        nonvar(X), nonvar(Z), Y is Z - X.

plus(X, Y, Z) :-
        nonvar(Y), nonvar(Z), X is Z - Y.

plus(X, Y, Z) :-
        nonvar(Z),
        between(0, Z, X),
        Y is Z - X.

plus(X, Y, Z) :-
        nonvar(Y),
        inc_inc(Y, X, Z).

plus(X, Y, Z) :-
        nonvar(X),
        inc_inc(X, Y, Z).

inc_inc(X, Y, Z) :-
        inc_inc(0, X, Y, Z).

inc_inc(Y, Z, Y, Z).

inc_inc(Y, Z, RY, RZ) :-
        Z > 0,
        Y1 is Y + 1,
        Z1 is Z + 1,
        inc_inc(Y1, Z1, RY, RZ).
