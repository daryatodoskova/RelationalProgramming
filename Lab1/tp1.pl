%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                     %
% CSE 307: Constraint Logic Programming - F. Fages    %
%                                                     %
%                                                     %
% TP1: initiation to SWI-Prolog                       %
%                                                     %
%      Relational Databases in Datalog                %
%                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is a Prolog file, i.e. containing Prolog facts and Prolog rules

% Comments are lines starting with % or blocks between /*  ...  */

% You can download (and compile) it in the Prolog interpreter at top level (command swipl)

% We ask you to write all answers to the questions in this file (either textual comments or Prolog code)
% and upload your file on the Moodle at the end of the TP

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART I. Relational Database %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prolog facts                                           %
% used below to represent a family database in extension %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

man(pierre).
man(jean).
man(robert).
man(michel).
man(david).
man(benjamin).
man(joel).

woman(catherine).
woman(paule).
woman(lucie).
woman(magali).
woman(deborah).
woman(claudine).
woman(vanessa).

parent(jean, david).
parent(jean, benjamin).
parent(robert, joel).
parent(robert, deborah).
parent(michel, claudine).
parent(michel, vanessa).
parent(pierre, jean).
parent(pierre, lucie).
parent(pierre, michel).
parent(paule, david).
parent(paule, benjamin).
parent(lucie, joel).
parent(lucie, deborah).
parent(magali, claudine).
parent(magali, vanessa).
parent(catherine, jean).
parent(catherine, lucie).
parent(catherine, michel).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prolog rules                                    %
% used below to define new relations in intension %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% p :- q reads as p is implied by q
% p :- q, r reads as p is implied by q and r


% X is a father of Y if X is a man and a parent of Y

father(X, Y):- parent(X, Y), man(X).

% the disequality predicate dif(X,Y) constrains X and Y to be different
% it is used below to define the relation X is the brother of Y

brother(X, Y) :- parent(Z, Y), dif(X, Y), parent(Z, X), man(X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUESTIONS on Relational Databases in Datalog %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
  Let us first play with the interpreter.

  Write Prolog queries for answering the following questions
  and copy them with all Prolog answers below

  Be careful that in Prolog an indentifier starting with a upper case letter denotes a variable !
  Constant names must start with a lower case letter (not a good convention for our database)

1.	Are David and Benjamin brothers ?
Yes, since ?- brother(david,benjamin). returns true

2.	Who are the brothers of Lucie ?
Lucie's brother are Jean and Michel.

3.	Who are the two parents of David ?
David's parents are Jean and Paule.

4.	Are there somebody with two fathers in this family ?
No.

*/

%  Let us now program in Prolog by defining new predicates in this file

%  You will try your definitions by reloading this file in the Prolog interpreter with the query [tp1].

%  Write Prolog rules for defining the following relations


% 5.    mother/2
mother(X,Y) :- parent(X, Y), woman(X).



% 6.    sister/2
sister(X, Y) :- parent(Z, Y), dif(X, Y), parent(Z, X), woman(X).



% 7.	grandparent/2
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).



% 8.	grandparent2/2 (alternative definition)
grandparent2(X, Y) :- parent(X, Z), (father(Z, Y) ; mother(Z, Y)).



% 9.	grandparent3/2 (yet another equivalent definition)
grandparent3(X, Y) :- ((mother(X,Z), parent(Z,Y)) ; (father(X,Z), parent(Z,Y))).


/*
  10.   Are the answers given in the same order ? explain why.

No, because equivalence doesn't preserve the order of the answers (noticeable if you trace the output)
*/

% 11.	uncle/2
uncle(X, Y) :- brother(X, Z), parent(Z, Y).



% 12.   aunt/2
aunt(X, Y) :- sister(X, Z), parent(Z, Y).



% 13.	ancestor/2
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART II. Graphs in Datalog %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 14.	Represent the graph of TP1.pdf in Prolog with a predicate arc/2.

arc(amsterdam,paris).
arc(paris,lyon).
arc(lyon,verone).
arc(lyon,rome).
arc(lausanne,verone).
arc(verone,rome).


% 15.	Define the transitive closure relation path/2 that checks the existence of a path from one vertex to another one in an acyclic graph.


path(X,Y) :- arc(X,Y).
path(X,Y) :- arc(X,Z), path(Z,Y).



/*
  16.	Add a cycle in the graph and give one example of a query where the predicate path does loop

Let's create an arc from Rome back to Lyon. Now when we run path(verone,rome), to create a loop.


  17.	Use the trace/0 directive to trace the resolution of the query and explain what happens

We can notice it doesn’t run out of solutions because it keeps identifying a
new path between verone and rome by looping through Rome and Lyon continuously.


  18.	Prove that your program path/2 terminates on an acyclic graph.
Since, in an acyclic graph, the paths are unidirectional we don’t have any cycles that would trigger
the program path/2 to continuously loop through arcs (it's a transitive closure). We can notice it
by using the trace/0 directive.

*/
