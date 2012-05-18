hanoi(s(0), A, B, C, [[A, to, B]]).
hanoi(s(N), A, B, C, Moves) :-
        hanoi(N, A, C, B, R1),
        hanoi(N, C, B, A, R2),
        append(R1, [[A, to, B] | R2], Moves).
