
min_elem([[Sym1, Freq1], [Sym2, Freq2] | Xs], Result, [[Sym2, Freq2] | Rest ]) :-
        Freq1 =< Freq2,
        min_elem([[Sym1, Freq1] | Xs], Result, Rest).

min_elem([[Sym1, Freq1], [Sym2, Freq2] | Xs], Result, [[Sym1, Freq1] | Rest ]) :-
        Freq1 > Freq2,
        min_elem([[Sym2, Freq2] | Xs], Result, Rest).

min_elem([[Sym1, Freq1] | []], [Sym1, Freq1], []).

haffman_tree([], []).

haffman_tree([Elem], Elem).

haffman_tree(List, Result) :-
        min_elem(List, [Sym1, Freq1], Rest1),
        min_elem(Rest1, [Sym2, Freq2], Rest2),
        (NewFreq is Freq1 + Freq2),
        haffman_tree([[node(Sym1, Sym2), NewFreq] | Rest2], Result).

haffman_tree_to_codes(node(Left, Right), CurrCodes, Result) :-
        haffman_tree_to_codes(Left, [0 | CurrCodes], Res1),
        haffman_tree_to_codes(Right, [1 | CurrCodes], Res2),
        append(Res1, Res2, Result).

haffman_tree_to_codes(X, CurrCodes, [[X, CurrCodes]]).

haffman(List, Result) :-
        haffman_tree(List, [Nodes, _]),
        haffman_tree_to_codes(Nodes, [], Result).


