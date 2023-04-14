:- use_module(library(clpfd)).
:- include(bridgeData).

durations(H,D):-
  sum_list(D, X).

length_durations(L):-
  durations(D),
  length(D, L).

-- make variables
starting_dates_aux([],[]).
make_vars([H|T],[[H,D,A]|R]):-
  durations(H,D),
  -- domain from 0 to sum of the durations of all tasks.
  fd_domain(A,0,271),
  starting_dates_aux(T,R).

-- create the list of decision variables giving the starting dates of the tasks
starting_dates(S):-
  length_durations(L),
  starting_dates_aux(S, L).

-- ease access to data by giving the starting date variable & the duration of a job
job(S, Name, Start, Duration):-
  jobs(J),
  nth0(I, J, Name),
  durations(D),
  nth0(I, D, Duration),
  nth0(I, S, Start).

-- post the precedence constraints on the starting date variables of the tasks
post_precedences([],_).
post_precedences([[A,B]|R],L):-
  member([A,Ad,Aa],L),
  member([B,_Bd,Ba],L),
  Ba #>= Aa+Ad,
  post_precedences(R,L).

-- maximum time separation constraints between either start or end dates of 2 tasks
post_delay(S, supdis(Num, e(N1), e(N2))):-
  job(S, N1, S1, D1),
  job(S, N2, S2, D2),
  Num #>= S1 + D1 - (S2 + D2).
post_delay(S, supdis(Num, e(N1), s(N2))):-
  job(S, N1, S1, D1),
  job(S, N2, S2, D2),
  Num #>= S1 + D1 - S2.
post_delay(S, supdis(Num, s(N1), e(N2))):-
  job(S, N1, S1, D1),
  job(S, N2, S2, D2),
  Num #>= S1 - (S2 + D2).
post_delay(S, supdis(Num, s(N1), s(N2))):-
  job(S, N1, S1, D1),
  job(S, N2, S2, D2),
  Num #>= S1 - S2.

-- minimum time separation constraints between either start or end dates of 2 tasks
post_delay(S, infdis(e(N1), e(N2), Num)):-
  job(S, N1, S1, D1),
  job(S, N2, S2, D2),
  S1 + D1 - (S2 + D2) #>= Num.
post_delay(S, infdis(e(N1), s(N2), Num)):-
  job(S, N1, S1, D1),
  job(S, N2, S2, D2),
  S1 + D1 - S2 #>= Num.
post_delay(S, infdis(s(N1), e(N2), Num)):-
  job(S, N1, S1, D1),
  job(S, N2, S2, D2),
  S1 - (S2 + D2) #>= Num.
post_delay(S, infdis(s(N1), s(N2), Num)):-
  job(S, N1, S1, D1),
  job(S, N2, S2, D2),
  S1 - S2 #>= Num.

-- post the delay constraints beteen the tasks
post_delays(_, []).
post_delays(S, [C|R]):-
  post_delay(S, C),
  post_delays(S, R).


bridge(K,End):-
	bridge_run(K,End,Disj),
  --repeatedly calls (post_disjunctions(Disj), fd_min(End,M),End=M) to find a value that minimizes End (the end date)
	%fd_minimize(post_disjunctions(Disj), fd_min(End,M),End=M),End).
	fd_minimize((post_disjunctions(Disj), fd_min(End,M),End=M),End).


bridge_run(K,End,Disj):-
	jobs(L),
	starting_dates_aux(L,K),
	member([stop,_,End],K),
	precedence(M),
	post_precedences(M,K),
  distances(D),
  post_delays(S,D),
	resources(R),
	disj1(R,K,[],Disj1),
	reverse(Disj1,Disj).

-- using disjunctions

disj1([],_R,D,D).
disj1([[_H,R]|T],K,Din,Dout):-
	end_list(R,K,R1),
	disj1(R1,Din,D1),
	disj1(T,K,D1,Dout).

disj2([],D,D).
disj2([H|T],Din,Dout):-
	disj3(H,T,Din,D1),
	disj2(T,D1,Dout).

disj3(_H,[],D,D).
disj3([A,B],[[C,D]|S],D1,D2):-
	disj3([A,B],S,[[A,B,C,D]|D1],D2).

end_list([],_,[]).
end_list([H|T],L,[[A,D]|S]):-
	member([H,D,A],L),
	end_list(T,L,S).

-- post mutual exclusion constraints between the tasks using the same machine.
post_disjunctions([]).
post_disjunctions([[A,B,C,D]|R]):-
	disjunction(A,B,C,D),
	post_disjunctions(R).

disjunction(Aa,Ad,Ba,_Bd):-
	Ba #>= Aa+Ad.

disjunction(Aa,_Ad,Ba,Bd):-
	Aa #>= Ba+Bd.

schedule(L):-
  label(L),   -- gives solution in any order
  fd_labeling([min(var)], L). -- enumerates solution with minimization of var

label([]).
label([[_A,_Ad,Aa]|R]):-
	fd_labeling(Aa),
	label(R).
