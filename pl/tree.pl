bin_tree(void).
bin_tree(tree(Element, Left, Right)) :-
        bin_tree(Left),
        bin_tree(Right).

tree_member(X, tree(X, _, _)).
tree_member(X, tree(_, Left, _)) :-
        tree_member(X, Left).
tree_member(X, tree(_, _, Right)) :-
        tree_member(X, Right).

tree_substitute(_, _, void, void).
tree_substitute(X, Y, tree(X, Left, Right), tree(Y, NLeft,NRight)) :-
        tree_substitute(X, Y, Left, NLeft),
        tree_substitute(X, Y, Right, NRight).
tree_substitute(X, _, tree(Z, Left, Right), tree(Z, NLeft,NRight)) :-
        \=(X, Z),
        tree_substitute(X, Y, Left, NLeft),
        tree_substitute(X, Y, Right, NRight).

heapyfy(void, void).
heapyfy(tree(X, Lt, Rt), Heap) :-
        heapyfy(Lt, Left),
        heapyfy(Rt, Right),
        adjast(X, Left, Right, Heap).

adjast(X, Left, Right, tree(X, Left, Right)) :-
        greater(X, Left),
        greater(X, Right).
adjast(X, tree(Y, YLt, YRt), Right, tree(X, Left, Right)) :-
        >=(Y, X),
        greater(Y, Right),
        adjast(X, Ylt, YRt, Left).
adjast(X, Left, tree(Y, YLt, YRt), tree(X, Left, Right)) :-
        >=(Y, X),
        greater(Y, Left),
        adjast(X, Ylt, YRt, Right).

greater(X, void).
greater(X, tree(Node, _, _)) :-
        >=(X, Node).

