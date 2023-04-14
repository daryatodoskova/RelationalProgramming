%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                         %
% CSE 307: Relational Programming - F. Fages              %
%                                                         %
%                                                         %
% TP3: Constraint Logic Programming over the reals CLP(R) %
%      Fourier example                                    %
%      Production planning and cost benefit analysis      %
%                                                         %
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART I. Fourier example          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The following CLP(R) program solves the mechanical problem given by Fourier in his lecture in 1823
% for placing a weight P at position (X,Y)
% on a triangular table with 3 legs A,B,C placed at coordinates (0,0), (20,0), (0,20) respectively
% each leg supporting 1 weight unit


:- use_module(library(clpr)).


fourier(A,B,C,P,X,Y):-
    {0=<A, A=<1, 0=<B, B=<1, 0=<C, C=<1},
    {A+B+C=P},
    {P*X=20*B},
    {P*Y=20*C}.

/*
 Question 1. Query the program to determine the area and the extreme points where a weight of 2.5 unit can be placed
  Show your queries and explain the results

fourier(A,B,C,2.5,X,Y).
{Y=20.0-8.0*A-8.0*B, X=8.0*B, C=2.5-A-B, A+B>=1.5, B=<1.0, A=<1.0}.
when solving with p=2.5, no contradiction is satisfiable, thus:
the solved form gives {X=8.0*B, Y=8.0*C, A=2.5-B-C, B=<1.0, 2-C=<B, 0=<C, C=<1}
which gives the placement area : 16-y=<x=<8 with 0=<y=<8.

Now, for the extreme points where a weight of 2.5 unit can be placed are:

fourier(A,B,C,2.5,X,Y), minimize(X).
A = C, C = 1.0,
B = 0.5,
X = 4.0,
Y = 8.0.

fourier(A,B,C,2.5,X,Y), minimize(Y).
A = B, B = 1.0,
C = 0.5,
X = 8.0,
Y = 4.0.

fourier(A,B,C,2.5,X,Y), maximize(B+C).
A = 0.5,
B = C, C = 1.0,
X = Y, Y = 8.0.

Thus, the extreme vertices are given by:
min(X)=min(B)=0 with C=1, Y=8, A=1
min(Y)=min(C)=0 with B=1, X=8, A=1
max(X+Y)=max(B+C)=2 with B=C=1, X=Y=8, A=0
*/




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART II. Production planning     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
  Let us consider that a company makes two products: bands and coils, where

  the maximum quantity of bands that can be produced is 6000 tonnes, and 4000 tonnes for coils,

  the profit per tonne of bands produced is 25, and 30 for coils,

  200 tonnes of bands can be produced per hour, and 140 tonnes of coils per hour,

  and 40h are available for the production

  Question 2. Define in CLP(R) the predicate production(B, C) to determine

  - the time B allocated to the production of bands

  - and the time C allocated to the production of coils

  - that maximize the profit
*/

production(B, C):-
    {B * 200 =< 6000, C * 140 =< 4000, B + C = 40, P = B * 200 * 25 + C * 140 * 30},
    maximize(P).

  /*
    Question 3. Show and interpret the result

?- production(B, C).
    B = 30.0,
    C = 10.0.

The result seems logic since more bands are produced within the hour than coils, and that the profit difference isn't that big.
  */


  /*

  Let us now generalize the problem to any company that makes a list of products,

  where each product is given with

  - the profit per tonne of product produced

  - the maximum quantity of that product that can be produced

  - the number of tonnes produced per hour

  - the total available time for the production

  The data about the products will be given by a list of quadruples of the form
    (product name, profit per tonne, maximum production, tonnes produced per hour)

  for instance [ (band, 25, 6000, 200), (coil, 30, 4000, 140) ] in the previous example


  Question 4.   Define in CLP(R) the predicate production(Time, Data, Plan)

where Plan is a list of production times allocated for each product (decision variables)
    -  satisfying the production data constraints
    -  the maximum Time for the production
    -  and maximizing the profit

  We recall that the relation length(L, N) gives the length of a list, and that variables named _ are ignored

    You will have to compute linear expressions as Prolog terms (like in previous TP for symbolic differentiation),
    and pass those linear terms to form linear constraints between curly brackets in CLP(R)

    Test your predicate with the goal production(40, [ (band, 25, 6000, 200), (coil, 30, 4000, 140) ], Plan)

  */

/* Doesn't work yet */

each((_, PT, MP, TPH), T, P):- {TPH * T =< MP, P = PT * T}.

predicates([], [], []).
predicates([F|R], LstT, LstP):-
    each(F, T, P),
    predicates(R, FollT, FollP),
    LstT = [T|FollT], LstP = [P|FollP].

sum([X], X):-!.

sum([X|R], Res):-
sum(R, Foll), {Res=X+Foll}.

production(Time, Data, Plan):-
    preds(Data, Plan, ConsP),
  	{sum(Plan) =< Time, Profit = sum(ConsP)},
  maximize(Profit).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART III. Cost-benefit analysis  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*

  Back to the problem and data of question 2, we would like now to solve the dual problem

  of estimating the respective values of our production capacities,

  i.e. of our maximum production time (40 hours), and of the production capacity of each product (6000 and 4000),

  Those positive "shadow prices" represent the minimum price at which we would like to sell them.

  They are determined by minimizing the sum of values of our current capacities (since we want minimum prices)

  but with a unit price for each resource such that their selling is greater or equal to the profit we would make by using them in production.


  Question 5. Define in CLP(R) the predicate price(Vt, Vb, Vc) to determine the shadow prices of our capacities

  i.e. of one time unit more, of one more tonne of bands production capacity, and one more tonne of coils production capacity.

*/

/* doesn't work yet, returns false */

predicate(t, b, c):-
    {P = B1 * 200 * b + C1 * 140 * c, Values = CB + CC, B1 * 200 =< CB, C1 * 140 =< CC, B1 + C1 = 40 + t},
    maximize(P), minimize(Values).

/*

Question 6. Interpret the result

The predicate price allows us to find the shadow prices of our capacities,
in order to simultaneously maximize profits and minimize the price at which we sell the products.

*/

/*
    Question 7. Observe with queries that the optimal cost are the same in the primal production and dual price models.









*/
