accept(Xs) :- initial(Q), accept(Xs,Q).
accept([X|Xs],Q) :- delta(Q,X,Q1), accept(Xs,Q1).
accept([],Q) :- final(Q).

initial(q0).
final(q4).

delta(q0, a, q1).
delta(q1, b, q2).
delta(q2, c, q4).
delta(q2, W, q3) :- \==(W, c).
delta(q3, c, q4).
delta(q3, W, q3) :- \==(W, c).
delta(q4, c, q4).
delta(q4, W, q3) :- \==(W, c).

test(t1) :- accept([a, b, c]).
test(t2) :- accept([a, b, c, c]).
test(t3) :- accept([a, b, d, c]).
test(t4) :- \+ accept([a, b, c, a]).
test(t5) :- \+ accept([a, b]).
test(t6) :- \+ accept([a]).
test(t7) :- \+ accept([b]).
test(t8) :- \+ accept([]).
test(t9) :- accept([a, b, d, e, c]).

test :-
        test(t1),
        test(t2),
        test(t3),
        test(t4),
        test(t5),
        test(t6),
        test(t7),
        test(t8),
        test(t9).
        
