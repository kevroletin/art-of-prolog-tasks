fl(Xs, Ys) :- fl(Xs, [], Ys).

fl([X |Xs], S, [X | Res]) :-
        \+ list(X),
        fl(Xs, S, Res).

fl([X | Xs], S, Res) :-
        list(X),
        fl(X, [Xs | S] , Res).

fl([], [X | Xs], Res) :-
        fl(X, Xs, Res).

fl([], [], []).


