natural_number(0).
natural_number(s(X)) :- natural_number(X).

lt(0, X) :-
        \=(0, X),
        natural_number(X).
lt(s(X), s(Y)) :-
        natural_number(X),
        natural_number(Y),
        lt(X, Y).

gt(X, 0) :-
        \=(X, 0),
        natural_number(X).
gt(s(X), s(Y)) :-
        natural_number(X),
        natural_number(Y),
        gt(X, Y).

odd(0).
even(s(X)) :-
        natural_number(X),
        \+ odd(X).
        
odd(s(X)) :-
        natural_number(X),
        \+ even(X).

plus(0, X, X) :-
        natural_number(X).
plus(s(X),Y,s(Z)) :-
        plus(X, Y, Z).

times(0, X, 0) :-
        natural_number(X).
times(s(A), B, C) :-
        times(A, B, Z),
        plus(Z, B, C).

exp(X, 0, s(0)) :-
        natural_number(X).
exp(X, s(Pow), Res) :-
        exp(X, Pow, Z),
        times(Z, X, Res).

fib(s(0), s(0)).
fib(s(s(0)), s(0)).
fib(s(s(N)), F) :-
        fib(N, Fnn),
        fib(s(N), Fn),
        plus(Fnn, Fn, F).


/*
  yes
| ?- times(0, 0, 0).
times(0, 0, 0).

yes
| ?- times(0, 0, 1).
times(0, 0, 1).

no
| ?- times(0, s(0), s(0)).
times(0, s(0), s(0)).

no
| ?- times(0, s(0), 0).
times(0, s(0), 0).

yes
| ?- times(s(0), s(0), 0).
times(s(0), s(0), 0).

no
| ?- times(s(0), 0, 0).
times(s(0), 0, 0).

yes
| ?- times(s(0), s(0), s(0)).
times(s(0), s(0), s(0)).

yes
| ?- times(s(0), s(s(0)), s(0)).
times(s(0), s(s(0)), s(0)).

no
| ?- times(s(0), s(s(0)), s(s(0))).
times(s(0), s(s(0)), s(s(0))).

yes
| ?- times(s(s(0)), s(s(0)), s(s(0))).
times(s(s(0)), s(s(0)), s(s(0))).

no
| ?- times(s(s(0)), s(s(0)), s(s(s(s(0))))).
times(s(s(0)), s(s(0)), s(s(s(s(0))))).

yes
| ?- times(s(s(0)), s(s(0)), s(s(s(s(0))))).
  */

/*
| ?- exp(s(s(0)), s(s(0)), s(s(s(s(0))))).
exp(s(s(0)), s(s(0)), s(s(s(s(0))))).
*/

/*

| ?- fib(s(s(s(s(s(0))))), X).
fib(s(s(s(s(s(0))))), X).

X = s(s(s(s(s(0))))) ? .
.
Action (; for next solution, a for all solutions, RET to stop) ? 

yes
| ?- fib(s(s(s(s(s(s(s(s(0)))))))), X).
fib(s(s(s(s(s(s(s(s(0)))))))), X).

X = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(0))))))))))))))))))))) ?


*/
