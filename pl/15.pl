
between(I, J, K) :-
        I < J,
        (I1 is I + 1),
        between(I1, J, K).

between(I, _, I).

/*
between(10, 15, X). a

X = 15 ? 

X = 14

X = 13

X = 12

X = 11

X = 10

yes
| ?-
*/

scalar_mult(List1, List2, Res) :-
        scalar_mult(List1, List2, Res, 0).

scalar_mult([], [], Res, Res).

scalar_mult([X | Xs], [Y | Ys], Result, CurrRes) :-
        (NewCurrRes is X * Y + CurrRes),
        scalar_mult(Xs, Ys, Result, NewCurrRes).
