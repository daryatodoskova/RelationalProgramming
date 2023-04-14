%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                     %
% CSE 307: Constraint Logic Programming - F. Fages    %
%                                                     %
%                                                     %
% TP2: Symbolic differentiation in Prolog             %
%                                                     %
%      List processing and road map navigation        %
%                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART I. Symbolic Differentiation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Write a symbolic differentiation predicate differentiate(Expression, Variable, Derivative)

differentiate(X,X,1) :- !.
differentiate(C,_X,0) :- atomic(C). %, (C \= X).
differentiate(C,_,0):- number(C).
differentiate(A+B,X,DA+DB):- differentiate(A,X,DA), differentiate(B,X,DB).
differentiate(A-B,X,DA+DB):- differentiate(A,X,DA), differentiate(B,X,DB).
differentiate(A*B,X,A*DB+B*DA):- differentiate(A,X,DA), differentiate(B,X,DB).
differentiate(e^A,X,DA*e^A):- differentiate(A,X,DA).   %optional

% 2. Write an algebraic simplification predicate simplify(Expression, SimplifiedExpression).

simplify(X,X) :- atom(X).
simplify(N,N) :- number(N).
simplify(A+B,C) :- simplify(A,A1), simplify(B,B1), simplify_sum(A1+B1,C).
simplify(A*B,C) :- simplify(A,A1), simplify(B,B1), simplify_product(A1*B1,C).

simplify_sum(0+A,A).
simplify_sum(A+0,A).
simplify_sum(A+B,C) :- number(A), number(B), C is A+B.
simplify_sum(A+B,A+B).

simplify_product(0*_X,0).
simplify_product(_X*0,0).
simplify_product(1*A,A).
simplify_product(A*1,A).
simplify_product(A*B,C) :- number(A), number(B), C is A*B.
simplify_product(A*B,A*B).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART II. List Processing      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The member/2 predicate can be defined by

member(X, [X|_]).
member(X, [_ | L]):- member(X, L).

% 3. Define the relation remove(L1, X, L2) true if and only if L2 is the list L1 with at most one occurrence of X removed.

remove([X|L], X, L).
remove([H|L], X, [H|L2]) :- remove(L, X, L2).
remove([], _, []).

% 4. Represent the cyclic graph of the TP with predicate arc/2
%    and define a non looping predicate path/3 where the third argument is a list of forbidden intermediate cities
%    (that list may be empty initially

path(X, Y, []) :- X = Y.
path(X, Y, _) :- arc(X, Y).
path(X, Y, L) :- arc(X, A), not(member(A, L)), path(A, Y, [A|L]).
path(X, Y, L) :- arc(A, X), not(member(A, L)), path(A, Y, [A|L]).

/*
 5. Prove that the program path/3 terminates.
  Hint: find a complexity measure on the arguments of path(X, Y, L) and the graph arc/2 and show that this complexity measures strictly decreases at each recursive call.

Take as complexity measure the couple (arc(L) ,s(L)).
Then, 






*/
