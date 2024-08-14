% Parcial Sueños

% 1)
% a) Generar la base de conocimientos inicial

cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

quiere(gabriel, loteria([5,9])).
quiere(gabriel, futbolista(arsenal)).
quiere(juan, cantante(100000)).
quiere(macarena, cantante(10000)).

% 2) Queremos saber si una persona es ambiciosa
% Persona ambiciosa --> cuando la suma de dificulatades de los sueños
% mayor a 20
% ¿Como se calcula la dificultad de cada sueño?
% ---

ambiciosa(Persona) :-
    dificultadTotal(Persona, SumaDeDificultades),
    SumaDeDificultades > 20.

dificultadTotal(Persona, Total) :-
    quiere(Persona, _),
    findall(Dificultad, (quiere(Persona, Suenio), dificultadSuenio(Suenio, Dificultad)), Dificultades),
    sum_list(Dificultades, Total).

dificultadSuenio(cantante(CantidadDiscos), 6) :- CantidadDiscos > 500000.
dificultadSuenio(cantante(CantidadDiscos), 4) :- CantidadDiscos =< 500000.

dificultadSuenio(loteria(NumerosApostados), Dificultad) :-
    length(NumerosApostados, CantidadNumeros),
    Dificultad is 10 * CantidadNumeros.
    
dificultadSuenio(futbolista(Equipo), 3) :- equipoChico(Equipo).
dificultadSuenio(futbolista(Equipo), 16) :- not(equipoChico(Equipo)).

equipoChico(arsenal).
equipoChico(aldosivi).    

% 3) Queremos saber si un personaje tiene química con una persona. 
% Esto se da si la persona cree en el personaje y...

tieneQuimicaCon(Personaje, Persona) :-
    cree(Persona, Personaje),
    condicionQuimica(Personaje, Persona).

condicionQuimica(campanita, Persona) :-
    quiere(Persona, Suenio),
    dificultadSuenio(Suenio, Dificultad),
    Dificultad < 5.

condicionQuimica(Personaje, Persona) :-
    Personaje \= campanita,     % ojo con esto(porque es para todo el resto, que NO sea campanita)
    todosSuenioPuros(Persona),
    not(ambiciosa(Persona)).

todosSuenioPuros(Persona) :-
    quiere(Persona, _),
    forall(quiere(Persona, Suenio), esPuro(Suenio)).
    
esPuro(futbolista(_)).
esPuro(cantante(CantidadDiscos)) :- CantidadDiscos < 200000.

% 4) 
% - Campanita es amiga de los Reyes Magos y del Conejo de Pascua
% - el Conejo de Pascua es amigo de Cavenaghi, entre otras amistades

amigoDe(campanita, reyesMagos).
amigoDe(campanita, conejoDePascua).
amigoDe(conejoDePascua, cavenaghi).
%amigoDe(conejoDePascua, _).

% Necesitamos definir si un personaje puede alegrar a una persona,
% esto ocurre...

puedeAlegrar(Personaje, Persona) :-
    quiere(Persona, _),     % la Persona tiene algun sueño
    tieneQuimicaCon(Personaje, Persona),
    algunBackupNoEnfermo(Personaje).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).

algunBackupNoEnfermo(Personaje) :-
    not(estaEnfermo(Personaje)).

algunBackupNoEnfermo(Personaje) :-
    amigoDe(Personaje, OtroPersonaje),
    algunBackupNoEnfermo(OtroPersonaje).


