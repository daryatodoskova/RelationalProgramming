%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                         %
% CSE 307: Relational Programming - F. Fages              %
%                                                         %
%                                                         % 
% TP5: Metainterpretation                                 %
%      Metainterpreter for complete search                %
%      Theorem proving in group theory                    %
%                                                         %
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

				
% For integer arithmetic we prefer to use CLP(FD) rather than Prolog evaluable predicates

:- use_module(library(clpfd)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART I. Meta interpreter for complete search %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 The following meta-interpreter mimics the Prolog strategy for answering pure Prolog queries (without builtin predicates), i.e.
 - selection of the left-most subgoal of the goal to solve
 - rewriting of that subgoal with the body of the first rule with a unifiable head
 - continuation of the resolution and exploration of the other rules by depth-first backtracking search

*/


solve((Goal1, Goal2)) :-
  solve(Goal1),
  solve(Goal2).

solve(Head) :-
  \+ predicate_property(Head, built_in),
  clause(Head, Body),
  solve(Body).

solve(Goal) :-
   predicate_property(Goal, built_in),
   Goal \= (_, _),
   Goal \= (_; _),
   call(Goal).


/*

Question 1.

  Add clauses to that metainterpreter to solve disjunctive goals of the form (Goal1 ; Goal2)
  
*/

solve((Goal1; Goal2)) :- solve(Goal1); solve(Goal2).

%  Not surprinsingly, this meta-interpreter will loop forever without finding the success answer on the following predicate

loop(X, Y):- loop(Y, X).
loop(a, b).

/*

  We thus want to define a metainterpreter which does not loop on such an example and explores all branches of the search tree in a fair manner.

  This is possible by using iterative deepening instead of depth-first search.

  Iterative deepening performs a depth-first search with a bound on the depth of the search tree to be explored.

  That bound on the depth is increased by 1 iteratively, starting at depth 0.

  Each clause resolution step along a branch of the search tree increases the current length of the derivation by one.

  The execution of built-in predicates counts for 0 resolution step and does not increase the length of the derivation.

  

Question 2.

  Define the predicate search(Goal) to solve a Prolog goal by iterative deepening

  using an auxiliary predicate search(Goal, Current_length, Bound_depth, Result_length)

*/

search((Goal1; Goal2), CL, BD, RL):- New is CL + 1, CL #=< BD, (search(Goal1, New, BD, RL); search(Goal2, New, BD, RL)).
search((Goal1, Goal2), CL, BD, RL):- New is CL + 1, CL #=< BD, search(Goal1, New, BD, Foll), search(Goal2, Foll, BD, RL).
search(Head, CL, BD, RL):- \+ predicate_property(Head, built_in), CL #=< BD, clause(Head, Body), search(Body, CL + 1, BD, RL).
search(Goal, CL, _, RL):- predicate_property(Goal, built_in), CL #= RL + 1, Goal \= (_, _), Goal \= (_; _), call(Goal).
search(Goal):- recursive(Goal, 0).
recursive(Goal, N):- search(Goal, 0, N, _); Next is N + 1, recursive(Goal, Next).

  /*
  
Question 3. Show that you can now enumerate the successes of the looping predicate, by copying the execution of your query below
	
	Answer:
	--------------------------------------
	
	There are multiple outputs, below is only listed one:

	search(loop(X, Y)).
	X = a,
	Y = b.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART II. Theorem proving     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   Let us consider group theory, usually presented with the following axioms:

  - existence of a left neutral element e for any element x, we have for all x e*x=x,

  - existence of a left inverse i(x) for any x, we have for all x exists y y*x=e, i.e. by skolemization noting i() that inverse: for all x i(x)*x=e,

  - associativity of the group operator *, we have for all x,y,z (x*y)*z=x(y*z)

  - plus the logical axioms of equality =

  

  A more succinct presentation for automated theorem proving in Prolog without the axioms of equality is however possible,

  without loss of generalization, for proving expressions of the form x*y=z written o(x,y,z)

  In that representation, the axiom of associativity axiom is written as follows:

  for all x,y,z,u,v o(x,y,u) /\ o(y,z,v) ==> (o(u,z,w) <==> o(x,v,w))

  
  
  We can then express the axioms of group theory with the following Prolog program using a binary predicate proof/2

  where the first argument is a proposition to prove and the second is a proof of it, as follows
  
*/

proof(o(e,X,X), e).

proof(o(i(X),X,e), i).

proof(o(U,Z,W), l(P,Q,R)) :-
  proof(o(X,Y,U), P),
  proof(o(Y,Z,V), Q),
  proof(o(X,V,W), R).

proof(o(X,V,W), r(P,Q,R)) :-
  proof(o(X,Y,U), P),
  proof(o(Y,Z,V), Q),
  proof(o(U,Z,W), R).
  
/*


Question 4. Show with 3 simple queries that the left neutral element is right neutral element,
    the left inverse is right inverse and the double inverse is the identity,
    i.e. for any element a, we have o(a,e,a), o(a,i(a),e),  o(i(i(a)),e,a)
	
	Answer:
	--------------------------------------
	
	There are multiple outputs, below is only listed one:

	search(proof(o(a, e, a), ID)).
	ID = l(r(i, i, e), e, r(i, i, e)).

	search(proof(o(a, i(a), e), INV)).
	INV = l(r(i, i, e), e, i).

	search(proof(o(i(i(a)), e, a), D_INV)).
	D_INV = r(i, i, e).
    
Question 5 on proof-based generalization.

    Sometimes the proof of a proposition proves a more general theorem.

    Run the above queries with the proofs computed above as input to get the most general theorems proved as output

	Answer:
	--------------------------------------

	There are multiple outputs, below is only listed one:

	search(proof(Y, l(r(i, i, e), e, r(i, i, e)))).
	Y = o(_A, e, _A).

	search(proof(Y, l(r(i, i, e), e, i))).
	Y = o(_A, i(_A), e).

	search(proof(Y, r(i, i, e))).
	Y = o(i(i(_A)), e, _A).

	---------------------------------------

    Let us now show that any non-empty subset S stable by division (i.e. multiplication by an inverse) is a subgroup.    

    We thus assume the existence of one element a in S with the axiom s(a)

    plus the stability by division axiom, for all x,y  s(x) /\ s(y) ==> s(x,i(y))

    

Question 6. Add clauses to the proof predicate to implement those assumptions and prove properties of S

  */  

/*

Question 7. Show with queries that S is a group.

*/
