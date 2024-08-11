LoadPackage("nq");
LoadPackage("anupq");

F2 := FreeGroup(2);
F2 := FreeGroup("a", "b", "x");
AssignGeneratorVariables(F2); # tole predpiše vrednosti generatorjem

# nq := NilpotentQuotient(F2 : class := 2); # kaj je pcp-group?
# nq := NilpotentQuotient(F2 : class := 2, idgens := [x]);

# e := 5;

# nq := NilpotentQuotient(F2/[x^e] : class := 2, idgens := [x]);

# # S tem je zaključen prvi del ... 

# k := 2;
# dih := DihedralGroup(2^k);
# exp := Exponent(dih);


# nq := NilpotentQuotient(F2/[x^exp] : class := k - 1, idgens := [x]);
# Print("Pcp predstavitev grupe D", 2^k ," \n");
# PrintPcpPresentation(nq);

# # naredimo tuple
# pairsinG := Tuples(dih, 2);

# # naredimo seznam homomorfizmov
# homphis := List(pairsinG, tup -> GroupHomomorphismByImages(nq, dih, [nq.1, nq.2], [tup[1], tup[2]]));

# # naredimo seznam jeder, ki jih dobimo
# kers := List(homphis, phi -> Kernel(phi));
 
# # grupa zakonov
# zakoni := Intersection(kers);

# Print("Generatorji zakonov v kvocientirani grupi so: ", zakoni);

# interpretacija: zakoni v grupi D8 so generirani zgolj z besedama x^2 ter dvojnim komutatorjem

# k = 4: [ 2, 2 ]
# k = 5: [ 2, 4, 4, 4, 4, 4 ]
# k = 6: [ 4, 8, 8, 8, 8, 8, 4, 8, 8, 8, 8, 8 ]

# allgps := AllSmallGroups(Size, 16);

# tole spodaj bi bilo verjetno bolj optimalno ...

# gap> F := FreeGroup( 3 );                               
# <free group on the generators [ f1, f2, f3 ]>
# gap> t := ExpressionTrees( "a", "b", "x" );
# [ a, b, x ]
# gap> tree := Comm( t[1], t[2] )^3/LeftNormedComm( [t[1],t[2],t[3],t[1]] );
# Comm( a, b )^3/Comm( a, b, x, a )
# gap> EvaluateExpTree( tree, t, GeneratorsOfGroup(F) );
# f1^-1*f2^-1*f1*f2*f1^-1*f2^-1*f1*f2*f1^-1*f2^-1*f1*f2*f1^-1*f3^-1*f2^-1*f1^
# -1*f2*f1*f3*f1^-1*f2^-1*f1*f2*f1*f2^-1*f1^-1*f2*f1*f3^-1*f1^-1*f2^-1*f1*f2*f3


# all_gps := Filtered(List([1..m], n -> AllSmallGroups(Size, n)), G -> true);

# # Get all groups of size m or less
# all_gps := Concatenation(List([1..m], n -> AllSmallGroups(Size, n)));
# # Print(all_gps);

filePath := "C:/Users/jasak/Documents/Jasa/Sola/FMF/3_letnik/Diploma/Program_za_racunsko_iskanje_zakonov/Gap/generatorji_zakonov_v_nilpotentnih_grupah.g";


# spodnja_meja mora biti več kot 1
spodnja_meja := 65;
zgornja_meja := 67;

# all_gps := AllSmallGroups(Size, zgornja_meja);
# all_gps := Filtered(List([spodnja_meja..zgornja_meja], n -> AllSmallGroups(Size, n)), G -> true);
all_gps := Concatenation(List([spodnja_meja..zgornja_meja], n -> AllSmallGroups(Size, n)));
velikost_vseh := Length(all_gps);

all_nilpotent_gps := Filtered(all_gps, G -> IsNilpotent(G) and Size(G) >= spodnja_meja and Size(G) <= zgornja_meja);

# Get all groups of size m or less

Print("Število vseh grup moči v razponu: ", spodnja_meja, "-", zgornja_meja, ": ", velikost_vseh , " od tega nilpotentnih: ", Length(all_nilpotent_gps), "\n\n");

lista_razredov := List(all_nilpotent_gps, G -> NilpotencyClassOfGroup(G));

# Print(all_nilpotent_gps);

# od tod naprej delaš dalje !!!

# tole Crashne ...

# nq_poskus := NilpotentQuotient(F2/[x^13]: idgens := [x]);
# F2exp := F2 / [x^exp];
# Print("Kvocient F2 / F2^exp: ", Size(nq));



results := [];

for G in all_nilpotent_gps do
    # Step 1: Generate all pairs of elements in the group G
    # Start timing
    start_time := Runtime();

    pairsinG := Tuples(G, 2);

    exp := Exponent(G);
    razred_nilpotentnosti := NilpotencyClassOfGroup(G);
    nq := NilpotentQuotient(F2/[x^exp] : class := razred_nilpotentnosti, idgens := [x]);

    # Step 2: Create a list of homomorphisms from a fixed group nq (which must be defined before) to G
    homphis := List(pairsinG, tup -> GroupHomomorphismByImages(nq, G, [nq.1, nq.2], [tup[1], tup[2]]));

    # Step 3: Calculate the kernels of these homomorphisms
    kers := List(homphis, phi -> Kernel(phi));

    # Step 4: Find the intersection of all kernels (the "laws" of the group)
    zakoni := Intersection(kers);
    quotient_group := FactorGroup(nq, zakoni);

    zakoni := PcGroupToPcpGroup(zakoni);
    # nq := PcGroupToPcpGroup(nq);

    # Step 5: Print or store the results for this group
    Print("Struktura nilpotentne grupe G: << ", StructureDescription(G), " >>\n");
    Print("Grupa G je moči ", Size(G), " in razreda nilpotentnosti ", razred_nilpotentnosti, "\n");
    Print("Grupa zakonov kvocienta nq = F2 / (F2^exp gama_", razred_nilpotentnosti + 1, "(F2)): ", zakoni, "\n");
    PrintPcpPresentation(zakoni);
    Print("Generatorji kvocienta: ", GeneratorsOfGroup(zakoni), "\n");
    # Print("PCP prezentacija kvocienta: ", PcpPresentation(zakoni), "\n\n");

    
    Print("Kvocient nq/zakoni: <<< ", StructureDescription(quotient_group), " >>>\n");
    Print("Indeks podgrupe zakoni v nq: ", Size(quotient_group), "\n");
    Print("Generatorji kvocienta nq/zakoni: ", GeneratorsOfGroup(quotient_group), "\n");

    end_time := Runtime();
    elapsed_time := end_time - start_time;
    Print("Izračunano v: ", elapsed_time, " ms\n");
    Print("\n");
    
    
    # Optional: Store the results in a list or dictionary if needed
    # results := Add(results, rec(group := G, laws := zakoni));

    Append(results, [rec(
        group := G,
        laws := zakoni,
        quotient := quotient_group
    )]);
    Print("\n");
od;

# Construct the filename dynamically
filename := Concatenation("C:/Users/jasak/Documents/Jasa/Sola/FMF/3_letnik/Diploma/Program_za_racunsko_iskanje_zakonov/Gap/Rezultati/zakoni_za_nilpotentne_grupe_velikosti (", 
                          String(spodnja_meja), "-", String(zgornja_meja), ").txt");

# Open or create the text file with the constructed filename
outputFile := OutputTextFile(filename, false);

# Iterate over the results list and write each entry to the file
for result in results do
    # Write the group information
    AppendTo(outputFile, Concatenation("Grupa moči ", String(Size(result.group)), 
             " razreda nilpotentnosti ", String(NilpotencyClassOfGroup(result.group)), "\n"));
    # Write the laws information
    AppendTo(outputFile, Concatenation("Struktura grupe: ", String(StructureDescription(result.group)), "\n"));
    AppendTo(outputFile, Concatenation("Zakoni v kvocientni grupi: ", String(result.laws), "\n\n"));
od;

# Close the file when done
CloseStream(outputFile);


