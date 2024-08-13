%%%%%%%%%%%%%%%%%%%%%%%%%%% Vocaloid %%%%%%%%%%%%%%%%%%%%%%


canta(megurineLuka, nightFever, 4).
canta(megurineLuka, foreverYoung, 5).
canta(hatsuneMiku, tellYourWorld, 4).
canta(gumi, foreverYoung, 4).
canta(gumi, tellYourWorld, 5).
canta(seeU, novemberRain, 6).
canta(seeU, nightFever, 5).

/*

%canta(nombreVocaloid, cancion)%
canta(megurineLuka, cancion(nightFever, 4)).
canta(megurineLuka, cancion(foreverYoung, 5)).
canta(hatsuneMiku, cancion(tellYourWorld, 4)).
canta(gumi, cancion(foreverYoung, 4)).
canta(gumi, cancion(tellYourWorld, 5)).
canta(seeU, cancion(novemberRain, 6)).
canta(seeU, cancion(nightFever, 5)).

*/


% Punto 1

esNovedoso(Vocaloid):-
    canta(Vocaloid, _, _),
    cantaMin2Canciones(Vocaloid),
    tiempoCorto(Vocaloid, 15).
     
cantaMin2Canciones(Vocaloid):-
    canta(Vocaloid, Cancion1, _),
    canta(Vocaloid, Cancion2, _),
    Cancion1 \= Cancion2.

tiempoCorto(Vocaloid, Cant):-
    findall(Duracion, canta(Vocaloid, _, Duracion), Duraciones),
    sumlist(Duraciones, DuracionTotal),
    DuracionTotal < Cant.

% Punto 2

esAcelerado(Vocaloid):-
    canta(Vocaloid, _, _),
    not((canta(Vocaloid, _, Duracion), Duracion > 4)).

%%%%%%%%%%%%%%%%%%%%%% Conciertos

% Punto 1

concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

% Punto 2

puedeParticipar(hatsuneMiku, Concierto):-
    concierto(Concierto, _, _, _).

puedeParticipar(Vocaloid, Concierto):-
    concierto(Concierto, _, _, Requisito),
    canta(Vocaloid, _, _),
    Vocaloid \= hatsuneMiku,
    cumpleRequisito(Vocaloid, Requisito).

cumpleRequisito(Vocaloid, gigante(CantCanciones, DuracionMin)):-
    not(tiempoCorto(Vocaloid, DuracionMin)),
    cantCanciones(Vocaloid, Cant),
    Cant >= CantCanciones.

cantCanciones(Vocaloid, Cant):-
    findall(Cancion, canta(Vocaloid, Cancion, _), Canciones),
    length(Canciones, Cant).


cumpleRequisito(Vocaloid, mediano(Max)):-
    tiempoCorto(Vocaloid, Max).

cumpleRequisito(Vocaloid, pequenio(Min)):-
    canta(Vocaloid, _, Duracion),
    Duracion > Min. 

% Punto 3

masFamoso(Vocaloid):-
    canta(Vocaloid, _, _),
    nivelFama(Vocaloid, Max),
    forall(canta(V, _, _), 
        (nivelFama(V, Fama), Fama =< Max)).

nivelFama(Vocaloid, NivelFama):-
    findall(Fama, 
        (puedeParticipar(Vocaloid, Concierto), concierto(Concierto, _, Fama, _)), 
        Famas),
    sumlist(Famas, NivelIntermedio),
    cantCanciones(Vocaloid, Cant),
    NivelFama is NivelIntermedio * Cant.

% Punto 4

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

unicoParticipa(Vocaloid, Concierto):-
    puedeParticipar(Vocaloid, Concierto),
    not((conocido(Vocaloid, Conocido), puedeParticipar(Conocido, Concierto))).

conocido(P1, P2):-
    conoce(P1, P2).

conocido(P1, P2):-
    conoce(P1, Intermedio),
    conocido(Intermedio, P2).

% Punto 5

/*
En la solución planteada habría que agregar una claúsula en el predicado 
cumpleRequisitos/2  que tenga en cuenta el nuevo functor con sus 
respectivos requisitos 

El concepto que facilita los cambios para el nuevo requerimiento es el 
polimorfismo, que nos permite dar un tratamiento en particular a cada uno 
de los conciertos en la cabeza de la cláusula.

*/