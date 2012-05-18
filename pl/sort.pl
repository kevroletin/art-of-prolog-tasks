insert([], X, [X]).
insert([X | Xs], Z, [X | Ys]) :-
        list(Xs),
        >(X, Z),
        insert(Xs, Z, Ys).
insert([X | Xs], Z, [Z, X | Xs]) :-
        list(Xs),
        =<(X, Z).

sorted([]).
sorted([ _ ]).
sorted([X, Y]) :-
        >(X, Y).
sorted([X, Y | Xs]) :-
        >(X, Y),
        sorted(Xs).

ins_sort([], []).
ins_sort([X | Xs], Ys) :-
        ins_sort(Xs, Zs),
        insert(Zs, X, Ys).

quick_sort([], []).
quick_sort([X | Xs], Ys) :-
        partition(Xs, X, L1, L2),
        quick_sort(L1, S1),
        quick_sort(L2, S2),
        append(S1, [X | S2], Ys).

partition([], _, [], []).
partition([X | Xs], Y, [X | L1], L2) :-
        >(X, Y),
        partition(Xs, Y, L1, L2).
partition([X | Xs], Y, L1, [X | L2]) :-
        =<(X, Y),
        partition(Xs, Y, L1, L2).

        
        
