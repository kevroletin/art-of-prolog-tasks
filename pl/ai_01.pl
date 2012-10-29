%analogy(A is_to B, C is_to X, Answers) :-
analogy(A, B, C, X, Answers) :-
        match(A, B, Operation),
        match(C, X, Operation),
        member(X, Answers).

match(inside(Figure1, Figure2), inside(Figure2, Figure1), invert).
match(above(Figure1, Figure2), above(Figure2, Figure1), invert).
match(on_right_side(Figure1, Figure2), inside(Figure1, Figure2), moved_left).
match(inside(Figure1, Figure2), inside(Figure1, nothing), internal_removed).
match(inside(F1, F2), inside(F1, inside(F2, F1)), deep_nested).

test_analogy(Name, X) :-
        figures(Name, A, B, C),
        answers(Name, Answers),
        analogy(A, B, C, X, Answers).

figures(test1, inside(square, triangle),
               inside(triangle, square),
               inside(circle, square)).

answers(test1, [inside(circle, triangle),
                inside(square, circle),
                inside(triangle, square)]).

figures(test2, on_right_side(triangle, square),
               inside(triangle, square),
               on_right_side(left_half_circle, square)).

answers(test2, [above(bottom_half_circle, square),
                on_right_side(left_half_circle, square),
                inside(left_half_circle, square),
                inside(nothing, square),
                on_left_side(left_half_circle, square)]).

figures(test3, inside(triangle, triangle),
               inside(triangle, nothing),
               inside(circle, square)).

answers(test3, [inside(circle, circle),
                inside(nothing, square),
                inside(circle, triangle),
                inside(circle, nothing),
                inside(triangle, nothing)]).

figures(test4, inside(circle, circle),
               inside(circle, inside(circle, circle)),
               inside(square, square)).

answers(test4, [inside(nothing, square),
                inside(square, square),
                inside(square, inside(square, square)),
                inside(square, inside(nothing, square)),
                inside(square, nothing)]).
