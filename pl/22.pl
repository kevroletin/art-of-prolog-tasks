/*
  
sub(Old, New, Old, New).

sub(Old, _, Term, Term) :-
        atomic(Term),
        \+ compare(=, Old, Term).

sub(Old, New, Term, Term1) :-
        compound(Term),
        functor(Term, F, N),
        functor(Term1, F, N),
        sub(N, Old, New, Term, Term1).

sub(N, Old, New, Term, Term1) :-
        N > 0,
        arg(N, Term, Arg),
        sub(Old, New, Arg, Arg1),
        arg(N, Term1, Arg1),
        N1 is N - 1,
        sub(N1, Old, New, Term, Term1).

sub(0, _, _, _, _).

*/

substitute(Old, New, Old, New).

substitute(Old, _, Term, Term) :-
        atomic(Term),
        \+ compare(=, Old, Term).

substitute(Old, New, Term, Term1) :-
        compound(Term),
        Term =.. [F | Args],
        substitute_each(Old, New, Args, NewArgs),
        Term1 =.. [F | NewArgs].

substitute_each(Old, New, [X | Xs], [Y | Ys]) :-
        substitute(Old, New, X, Y),
        substitute_each(Old, New, Xs, Ys).

/*
substitute_each(Old, New, [ X | Xs], [X | Ys]) :-
        substitute_each(Old, New, Xs, Ys).
*/
substitute_each(_, _, [], []).
        

:- begin_tests(substitute).

test(t01) :-
        substitute(a, b, a, b).
test(t02) :-
        substitute(a, b, c, c).
test(t03) :-
        substitute(a, b, node(a), node(b)).
test(t04) :-
        substitute(a, b, node(a, a), node(b, b)).
test(t05) :-
        substitute(node(a, b), node(c, d),
            node(node(a, b),
                 node(c, d)),
            node(node(c, d),
                 node(c, d))).

:- end_tests(substitute).
