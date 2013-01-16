im_to_right(X, Y, [X,Y|_]).
im_to_right(X, Y, [_|T]) :- im_to_right(X, Y, T).

near(X, Y, L) :- im_to_right(X, Y, L).
near(X, Y, L) :- im_to_right(Y, X, L).

% house(color, nationality, pet, drink, cigarettes)
house(house(_, _, _, _, _)).
structure([A, B, C, D, E]) :- house(A), house(B), house(C), house(D), house(E).

first_house([A, _, _, _, _], A).
middle_house([_, _, C, _, _], C).

clues(Street) :-
        member(house(red, englishman, _, _, _), Street),       % The Englishman lives in the red house
        member(house(_, spaniard, dog, _, _),   Street),       % The Spaniard owns the dog
        member(house(green, _, _, coffee, _),   Street),       % Coffee is drunk in the green house
        member(house(_, ukrainian, _, tea, _),  Street),       % The Ukrainian drinks tea
        im_to_right(house(green, _, _, _, _),
                    house(ivory, _, _, _, _),   Street),       % The green house is immediately to the right (your right) of the ivory house
        member(house(_, _, snails, _, winston), Street),       % The Winston smoker owns snails
        member(house(yellow, _, _, _, kools),   Street),       % Kools are smoked in the yellow house
        middle_house(Street, house(_, _, _, milk, _)),         % Milk is drunk in the middle house
        first_house(Street, house(_, norwegian, _, _, _)),     % The Norwegian lives in the first house on the left
        near(house(_, _, _, _, chesterfields),
             house(_, _, fox, _, _),            Street),       % The man who smokes Chesterfields lives in the house next to the man with the fox
        near(house(_, _, _, _, kools),
             house(_, _, horse, _, _),          Street),       % Kools are smoked in the house next to the house where the horse is kept
        member(house(_, _, _, juice, lucky_strike),   Street), % The Lucky Strike smoker drinks orange juice
        member(house(_, japanese, _, _, parliaments), Street), % The Japanese smokes Parliaments
        near(house(_, norwegian, _, _, _),
             house(blue, _, _, _, _), Street).                 % The Norwegian lives next to the blue house

queries(Street, [[X, 'owns the Zebra'], [Y, 'drinks water']]) :-
        member(house(_, X, zebra, _, _), Street),
        member(house(_, Y, _, water, _), Street).

solve_puzzle(Ans) :-
        structure(Street),
        clues(Street),
        queries(Street, Ans).

/*

| ?- solve_puzzle(X). a
solve_puzzle(X). a

X = [[japanese,'owns the Zebra'],[norwegian,'drinks water']] ? 

(20 ms) no
| ?-

*/
