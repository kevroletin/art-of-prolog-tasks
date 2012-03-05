% |
% || 1 2 3 4 5 6 7 8 9
% | 
%    ---------------->

on(block2, block1).
on(block3, block2).
on(block4, block3).
on(block5, block4).

above(Block1, Block2) :- on(Block1, Block2).
above(Block1, Block2) :- on(Block1, X), above(X, Block2).
