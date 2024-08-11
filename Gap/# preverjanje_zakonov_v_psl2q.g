# preverjanje_zakonov_v_psl2q

p := 3;
k := 4;
q := 3^k;

G := PSL(2, q);

F2 := FreeGroup(2);   # Free group on 2 generators
a := F2.1;            # First generator of F
b := F2.2;            # Second generator of F

w := x * y^-1 * x;

pairsinG := Tuples(G, 2);

# List(pairsinG, Image(FreeGroupHomomorphismByImages(F2, G, [a, b], [g1, g2]), w);)
seznam := List(pairsinG, tup -> GroupHomomorphismByImages(F2, G, [a, b], [tup[1], tup[2]]));