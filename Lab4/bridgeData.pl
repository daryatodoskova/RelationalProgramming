% Original Source: Martin Bartusch. Optimierung von Netzplänen mit Anordnungsbeziehungen bei knappen Betriebsmitteln. PhD thesis, 1983.

/* Data for the bridge scheduling problem */

jobs([pa,a1,a2,a3,a4,a5,a6,p1,p2,ue,s1,s2,s3,s4,s5,s6,b1,b2,b3,b4,b5,b6,ab1,
    ab2,ab3,ab4,ab5,ab6,m1,m2,m3,m4,m5,m6,l,t1,t2,t3,t4,t5,ua,v1,v2,pe]).

durations([0,4,2,2,2,2,5,20,13,10,8,4,4,4,4,10,1,1,1,1,1,1,1,1,1,1,1,1,16,8,
    8,8,8,20,2,12,12,12,12,12,10,15,10,0]).

precedences([
[pa,p1],
[pa,p2],
[pa,a1],
[pa,a2],
[pa,a5],
[pa,a6],
[pa,ue],
[pa,l],

[p1,a3],
[p2,a4],

[a1,s1],
[a2,s2],
[a3,s3],
[a4,s4],
[a5,s5],
[a6,s6],

[s1,b1],
[s2,b2],
[s3,b3],
[s4,b4],
[s5,b5],
[s6,b6],

[b1,ab1],
[b2,ab2],
[b3,ab3],
[b4,ab4],
[b5,ab5],
[b6,ab6],

[ab1,m1],
[ab2,m2],
[ab3,m3],
[ab4,m4],
[ab5,m5],
[ab6,m6],

[m1,t1],
[m2,t1],
[m2,t2],
[m3,t2],
[m3,t3],
[m4,t3],
[m4,t4],
[m5,t4],
[m5,t5],
[m6,t5],

[l,t1],
[l,t2],
[l,t3],
[l,t4],
[l,t5],

[ue,ua],
[ua,pe],

[m1,v1],
[t1,v1],
[m6,v2],
[t5,v2],

[v1,pe],
[t1,pe],
[t2,pe],
[t3,pe],
[t4,pe],
[t5,pe],
[v2,pe]
]).

ressources([
[pile_driver,[p1,p2]],
[crane,[l,t1,t2,t3,t5,t4]],
[bricklaying,[m1,m2,m3,m4,m5,m6]],
[carpentary,[s1,s2,s3,s4,s5,s6]],
[excavator,[a1,a2,a3,a4,a5,a6]],
[caterpillar,[v1,v2]],
[concrete_mixer,[b1,b2,b3,b4,b5,b6]]
]).

/*
supdis(4,e(b1),e(s1)) is 4>=b1 + db1 - (s1 + ds1)
infdis(e(b1),e(s1),3) is b1 + db1 - (s1 + ds1) >=3
*/

distances([

supdis(4,e(b1),e(s1)),
supdis(4,e(b2),e(s2)),
supdis(4,e(b3),e(s3)),
supdis(4,e(b4),e(s4)),
supdis(4,e(b5),e(s5)),
supdis(4,e(b6),e(s6)),

supdis(3,s(s1),e(a1)),
supdis(3,s(s2),e(a2)),
supdis(3,s(s3),e(a3)),
supdis(3,s(s4),e(a4)),
supdis(3,s(s5),e(a5)),
supdis(3,s(s6),e(a6)),

supdis(3,s(s3),e(p1)),
supdis(3,s(s4),e(p2)),

infdis(s(s1),s(ue),6),
infdis(s(s2),s(ue),6),
infdis(s(s3),s(ue),6),
infdis(s(s4),s(ue),6),
infdis(s(s5),s(ue),6),
infdis(s(s6),s(ue),6),

infdis(s(ua),e(m1),-2),
infdis(s(ua),e(m2),-2),
infdis(s(ua),e(m3),-2),
infdis(s(ua),e(m4),-2),
infdis(s(ua),e(m5),-2),
infdis(s(ua),e(m6),-2),

supdis(30,s(l),s(pa)),
infdis(s(l),s(pa),30),

supdis(0,s(ab1),e(b1)),
supdis(0,s(ab2),e(b2)),
supdis(0,s(ab3),e(b3)),
supdis(0,s(ab4),e(b4)),
supdis(0,s(ab5),e(b5)),
supdis(0,s(ab6),e(b6)),

infdis(s(ab1),e(b1),0),
infdis(s(ab2),e(b2),0),
infdis(s(ab3),e(b3),0),
infdis(s(ab4),e(b4),0),
infdis(s(ab5),e(b5),0),
infdis(s(ab6),e(b6),0)

]).
