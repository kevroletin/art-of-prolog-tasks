
select(X, [X | Xs], Xs).
select(X, [Y | Ys], [Y | Zs]) :-
        select(X, Ys, Zs).

permutation(Xs, [Z | Zs]) :-
        select(Z, Xs, Ys),
        permutation(Ys, Zs).

permutation([], []).

double(Xs, Ys) :-
        append(Xs, Xs, Zs),
        permutation(Zs, Ys).
