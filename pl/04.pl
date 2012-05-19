/* --- lists --- */

list([]).
list([_ | Xs]) :- list(Xs).

/* 1
   adjacent/3 и last/2 с использованием append. */

adjacent(List, A, B) :-
        list(List),
        append( _ , [A | [ B | _ ] ], List).        

adjacent(List, A, B) :-
        list(List),
        append( _ , [B | [ A | _ ] ], List).        

/* Tests

| ?- adjacent([a, b, c, d, e], X, Y). a
adjacent([a, b, c, d, e], X, Y). a

X = a
Y = b ? 

X = b
Y = c

X = c
Y = d

X = d
Y = e

no

*/

last_(List, X) :-
        list(List),
        append(_, [X], List).

/* Tests
| ?- last_([a, b, c], X).
last_([a, b, c], X).

X = c

yes
| ?- last_([], X).
last_([], X).

no
*/



/* 2
   double/2 */

double(X, Y) :- append(X, X, Y).

/* Tests
| ?- double([a, b, c], X).
double([a, b, c], X).

X = [a,b,c,a,b,c]

yes
| ?- double([], X).
double([], X).

X = []

yes
*/


/* 3
   sum/2 с использованием plus_/3 и без. */

sum([], 0).
sum([X | Xs], Y) :-
        list(Xs),
        plus_(X, Z, Y),
        sum(Xs, Z).

sum_([], 0).
sum_([0 | Xs], Y) :-
        list(Xs),
        sum_(Xs, Y).
sum_([s(X) | Xs], s(Y)) :-
        list(Xs),
        sum_([X | Xs], Y).


natural_number(0).
natural_number(s(X)) :- natural_number(X).

plus_(A, 0, A) :-
        natural_number(A).

plus_(A, s(B), s(Res)) :-
        natural_number(A),
        natural_number(B),
        plus_(A, B, Res).

/*
| ?- sum([s(0)], X). a
sum([s(0)], X). a

X = s(0) ? 

no
| ?- sum([s(s(0))], X). a
sum([s(s(0))], X). a

X = s(s(0)) ? 

no
| ?- sum([s(s(0)), s(0)], X). a
sum([s(s(0)), s(0)], X). a

X = s(s(s(0))) ? 

no
| ?- sum([s(s(0)), s(s(0))], X). a
sum([s(s(0)), s(s(0))], X). a

X = s(s(s(s(0)))) ? 

no
| ?- sum([s(s(0)), s(s(0)), s(0)], X). a
sum([s(s(0)), s(s(0)), s(0)], X). a

X = s(s(s(s(s(0))))) ? 

no
| ?- sum([s(s(0)), s(s(0)), s(0)], X). a

*/

/*

| ?- sum_([s(s(0)), s(s(0)), s(0)], X). a
sum_([s(s(0)), s(s(0)), s(0)], X). a

X = s(s(s(s(s(0))))) ? 

no
| ?- sum_([], X). a
sum_([], X). a

X = 0

yes
| ?-

*/
        
/* 4
   (3.3i) Написать программу для отношения substitute/3. */

substitute(_, _, [], []).
substitute(X, Y, [Z | Xs], [Z | Ys]) :-
        list(Xs),
        \=(X, Z),
        substitute(X, Y, Xs, Ys).
       
substitute(X, Y, [X | Xs], [Y | Ys]) :-
        list(Xs),
        substitute(X, Y, Xs, Ys).

/* Tests

| ?- substitute(a, b, [a, b, c, d, a], X). a
substitute(a, b, [a, b, c, d, a], X). a

X = [b,b,c,d,b] ? 

no
| ?-
*/

/* 5
   (3.3iii) Написать программу для отношения no_doubles/2. */

member_([], _) :- false.
member_([X | _ ], X).
member_([_ | Xs], Y) :-
        list(Xs),
        member_(Xs, Y).

not_member([], _).
not_member([X | _ ], X) :- false.
not_member([X | Xs], Y) :-
        list(Xs),
        \=(X, Y),
        not_member(Xs, Y).

no_doubles([], []).
%no_doubles([X], [X]).
no_doubles([X | Xs], [X | Ys]) :-
        list(Xs),
        not_member(Xs, X),
        no_doubles(Xs, Ys).
        
no_doubles([X | Xs], Ys) :-
        list(Xs),
        member_(Xs, X),
        no_doubles(Xs, Ys).

/* Tests

yes
| ?- no_doubles([a, a, a, b, b, c, b, d, e, e, a], X).
no_doubles([a, a, a, b, b, c, b, d, e, e, a], X).

X = [c,b,d,e,a] ? 


yes
| ?- no_doubles([], X).
no_doubles([], X).

X = []

yes
| ?-

*/
