:- dynamic yes/1,no/1.
:- dynamic nota/3.

agregar(X):-
 write('Digite la nota con valor de dos decimales'),  read(Nota), nl,
 write('Digite la ponderacion de la nota con dos decimales (0 a 1]'),  read(Porcentaje), nl,
 asserta((nota(X,Nota,Porcentaje))),write('¿Desea incluir otra nota? (si/no)'),
 read(Respuesta),nl, ((Respuesta==si)->agregar(X);true).

repetir([]):- true.
repetir([X|Y]):- write('¿Desea incluir una nota para '),write(X),write(' ? (si/no)'),
    read(Respuesta),nl, ((Respuesta==si)->agregar(X);repetir(Y)).

asignaturas(L,Semestre) :- findall(X,(pertenece(X,Semestre)),L).

primerSemestre() :- primero,asignaturas(L1,primer),repetir(L1).
segundoSemestre() :- segundo,asignaturas(L1,segundo),repetir(L1).
tercerSemestre() :- tercero,asignaturas(L1,tercero),repetir(L1).

pertenece(herramientas_matematicas, primer).
pertenece(informatica, primer).
pertenece(bases_de_datos, primer).
pertenece(seminario_investigacion, primer).
pertenece(profundizacion_dos, segundo).
pertenece(profundizacion_tres, segundo).
pertenece(electiva_uno, segundo).
pertenece(tesis_uno, segundo).
pertenece(electiva_dos, tercero).
pertenece(defensa_tesis_1, tercero).
pertenece(defensa_tesis_2, tercero).

suma([],0).
suma([X|Y],R):- suma(Y, R1), R is R1 + X.

notas(L,Materia) :- findall(X*Y,(nota(Materia,X,Y)),L).
progreso(L,Materia) :- findall(Y,(nota(Materia,_,Y)),L).
sumaNotas(Total, Materia) :- notas(L1,Materia),suma(L1,Total).
sumaProgreso(Total, Materia) :- progreso(L1,Materia),suma(L1,Total).
desempenio(Desemp, Materia) :- sumaNotas(Total1,Materia),sumaProgreso(Total2,Materia), Desemp is Total1/(5*Total2).
desempenios(L) :- findall(X,(desempenio(X,_)),L).

long([],0).
long([_|Y],R):- long(Y, R1), R is R1 + 1.

promedioDesempenio(Prom):-desempenios(L1),suma(L1,S),long(L1,T), Prom is S/T.

valorDesempeno(X, Y):-
                      X < 0.8 -> Y = malo;
                      true -> Y = aceptable.

go :- (primerSemestre();segundoSemestre();tercerSemestre()),
      promedioDesempenio(Prom),
      valorDesempeno(Prom,Y),
      write('Su desempeño en la maestria es: '),
      write(Y), nl,
      write('Con un desmpeño del: '),
      write(Prom),
      nl,
      undo.

primero :- verify(cursado_primer_semestre).
segundo :- verify(cursado_segundo_semestre).
tercero :- verify(cursado_tercer_semestre).

/* how to ask questions */
ask(Question) :-
    write('Describa su condicion actual (si(s) o no(n)): '),nl,
    write('¿ '),
    write(Question),
    write('? '),
    read(Response),
    nl,
    ( (Response == si ; Response == s)
      ->
       assert(yes(Question)) ;
       assert(no(Question)), fail).

/* How to verify something*/
verify(S) :-
   (yes(S)
    ->
    true ;
    (no(S)
     ->
     fail ;
     ask(S))).

undo :- nota(_,_,_),fail.
undo.
