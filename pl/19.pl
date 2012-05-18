is_data(X) :-
        number(X).

get_data(node(Data, _, _), Data) :-
        is_data(Data).

is_ordered_tree(leaf(Data)) :-
        is_data(Data).

is_ordered_tree(node(Data, Left, Right)) :-
        is_data(Data),
        check_ordering(Data, Left, Right),
        is_ordered_tree(Left),
        is_ordered_tree(Right).

is_ordered_tree(null).

check_ordering(Data, Left, Right) :-
        check_less_eq_or_null(Data, Right),
        check_greater_or_null(Data, Left).

check_less_eq_or_null(Data, null) :-
        is_data(Data).

check_less_eq_or_null(Data, node(DataNode, _, _)) :-
        is_data(Data),
        =<(Data, DataNode).

check_greater_or_null(Data, null) :-
        is_data(Data).
check_greater_or_null(Data, node(DataNode, _, _)) :-
        is_data(Data),
        >(Data, DataNode).        


:- begin_tests(is_ordered_tree).

test(test01) :-
        is_ordered_tree(node(10, null, null)), !.
test(test02) :-
        is_ordered_tree(null), !.
test(test03) :-
        is_ordered_tree(null), !.
test(test04) :-
        is_ordered_tree(node(10,
                             node(5, null, null),
                             node(15, null, null))), !.
test(test04) :-
        is_ordered_tree(node(10,
                             node(5,
                                  node(0, null, null),
                                  null),
                             node(15,
                                  null,
                                  node(20, null, null)))), !.
test(test04 [false]) :-
        is_ordered_tree(node(10,
                             node(5,
                                  node(0, null, null),
                                  node(0, null, null)),
                             node(15,
                                  null,
                                  node(20, null, null)))), !.
:- end_tests(is_ordered_tree).

