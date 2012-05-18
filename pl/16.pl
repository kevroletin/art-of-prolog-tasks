length_(List, Length) :-
        length_(List, Length, 0).

length_([], Length, Length).

length_([_ | Xs], Length, CurrLen) :-
        (NextLen is CurrLen + 1),
        length_(Xs, Length, NextLen).
