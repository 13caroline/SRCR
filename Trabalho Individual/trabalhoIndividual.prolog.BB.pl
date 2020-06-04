%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCIONIO - MiEI/3
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Ficheiro que contém a base de conhecimento.
:- include('baseConhecimento.prolog.BB.pl').

% SICStus PROLOG: Declaracoes iniciais
:- set_prolog_flag(toplevel_print_options, [quoted(true), portrayed(true), max_depth(0)]).
:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

% - - - - - - - -- -- -- -- -- ----------------- Calcular um trajeto entre dois pontos ----------------- -- -- -- -- -- - - - - - - -

% Predicado de procura não informada por procura em largura, que calcula um trajeto entre dois pontos.
bfs(Origem, Destino, Final) :- bfsAux([Origem], Destino, [], Caminho), apagaNaoCaminho(Destino, Caminho, [], Final).

bfsAux([Destino|_], Destino, Visitados, [Destino|Visitados]).
bfsAux([Origem|Cauda], Destino, Visitados, Caminho) :- findall(Prox,
																									     			  (adjacente(Origem, Prox),
																											 				 \+member(Prox, Visitados),
																											 			 	 \+member(Prox, Cauda)),
																											 			 	Seguintes),
																											 sort(Seguintes, Ordenados),
																											 append(Cauda, Ordenados, Proximo),
																								 		 	 bfsAux(Proximo, Destino, [Origem|Visitados], Caminho).

% Predicado que verifica se duas paragens são adjacentes.
adjacente(X,Y) :- adjacenciasParagens(X,Y,_); adjacenciasParagens(Y,X,_).

% Predicado que elimina da lista de visitados, as paragens que não fazem parte do caminho.
apagaNaoCaminho(Origem, [], Adjacentes, [Origem|Adjacentes]).
apagaNaoCaminho(Origem, [Primeiro|Caminho], Adjacentes, Final) :- adjacente(Origem, Primeiro) -> apagaNaoCaminho(Primeiro, Caminho, [Origem|Adjacentes], Final);
																																	apagaNaoCaminho(Origem, Caminho, Adjacentes, Final).

% - - - - -- ----------- Selecionar apenas algumas das operadoras de transporte para um determinado percurso ----------- -- - - - - -

% Predicado que verifica se uma paragem pertence à lista de operadoras.
elemOperadora(Paragem, ListaOp) :- getOperadoraGid(Paragem, Op), sublista(Op, ListaOp).

% Predicado que devolve a operadora de uma paragem.
getOperadoraGid(Gid, S) :- findall(Operadora, (paragem(Gid,_,_,_,_,_,Operadora,_,_,_,_)), S).

% Predicado que verifica se uma lista é sublista de outra.
sublista([X],[]) :- !,fail.
sublista([],X).
sublista([X|XS],[Y|YS]) :- X==Y -> sublista(XS,YS); sublista([X|XS],YS).

% Predicado de procura não informada por procura em largura, que seleciona apenas algumas operadoras de transporte para um determinado percurso.
bfsOperadoras(Origem, Destino, Operadoras, Final) :- bfsAuxOperadoras([Origem], Destino, Operadoras, [], Caminho), apagaNaoCaminho(Destino, Caminho, [], Final).

bfsAuxOperadoras([Destino|_], Destino, Operadoras, Visitados, [Destino|Visitados]).
bfsAuxOperadoras([Origem|Cauda], Destino, Operadoras, Visitados, Caminho) :- findall(Prox,
																																							      (adjacente(Origem, Prox),
																																									   \+member(Prox, Visitados),
																																									   \+member(Prox, Cauda),
																																									   elemOperadora(Prox,Operadoras)),
																																										 Seguintes),
																																						 sort(Seguintes, Ordenados),
																																						 append(Cauda, Ordenados, Proximo),
																																						 bfsAuxOperadoras(Proximo, Destino, Operadoras, [Origem|Visitados], Caminho).



% - - - - - -- -- -- ---------------- Excluir um ou mais operadores de transporte para o percurso ---------------- -- -- -- - - - - -

% Predicado de procura não informada por procura em largura, que exclui uma ou mais operadoras de transporte para um determinado percurso.
bfsNaoOperadoras(Origem, Destino, Operadoras, Final) :- bfsAuxNaoOperadoras([Origem], Destino, Operadoras, [], Caminho), apagaNaoCaminho(Destino, Caminho, [], Final).

bfsAuxNaoOperadoras([Destino|_], Destino, Operadoras, Visitados, [Destino|Visitados]).
bfsAuxNaoOperadoras([Origem|Cauda], Destino, Operadoras, Visitados, Caminho) :- findall(Prox,
																																						     			 (adjacente(Origem, Prox),
																																								        \+member(Prox, Visitados),
																																								        \+member(Prox, Cauda),
																																								        nao(elemOperadora(Prox,Operadoras))),
																																								 			  Seguintes),
																																								 sort(Seguintes, Ordenados),
																																								 append(Cauda, Ordenados, Proximo),
																																					 		 	 bfsAuxNaoOperadoras(Proximo, Destino, Operadoras, [Origem|Visitados], Caminho).

% - - - - - -- -- ---------------- Escolher o percurso que passe apenas por abrigos com publicidade ----------------- -- -- - - - - -

%Predicado que verifica se uma paragem tem publicidade.
gid_Publicidade(Gid) :- paragem(Gid,_,_,_,_,yes,_,_,_,_,_).

% Predicado de procura não informada por procura em largura, que escolhe o percurso que passe apenas por paragens cujos abrigos têm publicidade.
bfsParagens(Origem, Destino, Final) :- bfsAuxParagens([Origem], Destino, [], Caminho), apagaNaoCaminho(Destino, Caminho, [], Final).

bfsAuxParagens([Destino|_], Destino, Visitados, [Destino|Visitados]).
bfsAuxParagens([Origem|Cauda], Destino, Visitados, Caminho) :- findall(Prox,
																																	    (adjacente(Origem, Prox),
																																				\+member(Prox, Visitados),
																																			  \+member(Prox, Cauda),
																																			  gid_Publicidade(Prox)
																																			),
																											 								Seguintes),
																											 				 sort(Seguintes, Ordenados),
																											 			   append(Cauda, Ordenados, Proximo),
																								 		 	 	 			 bfsAuxParagens(Proximo, Destino, [Origem|Visitados], Caminho).


% - - - - - -- -- -- ----------------- Escolher o percurso que passe apenas por paragens abrigadas ----------------- -- -- -- - - - -

%Predicado que verifica se uma paragem tem abrigo.
gid_Abrigo(Gid) :- paragem(Gid,_,_,_,"fechado dos lados",_,_,_,_,_,_); paragem(Gid,_,_,_,"aberto dos lados",_,_,_,_,_,_).

% Predicado de procura não informada por procura em largura, que escolhe o percurso que passe apenas por paragens abrigadas.
bfsAbrigos(Origem, Destino, Final) :- bfsAuxAbrigos([Origem], Destino, [], Caminho), apagaNaoCaminho(Destino, Caminho, [], Final).

bfsAuxAbrigos([Destino|_], Destino, Visitados, [Destino|Visitados]).
bfsAuxAbrigos([Origem|Cauda], Destino, Visitados, Caminho) :- findall(Prox,
																									     						   (adjacente(Origem, Prox),
																											 						 		\+member(Prox, Visitados),
																											 								\+member(Prox, Cauda),
																											 								gid_Abrigo(Prox)
																											 								),
																											 				        Seguintes),
																											 				sort(Seguintes, Ordenados),
																											 				append(Cauda, Ordenados, Proximo),
																								 		 	 				bfsAuxAbrigos(Proximo, Destino, [Origem|Visitados], Caminho).


% - - - - -- ----------- Identificar quais as paragens com o maior número de carreiras num determinado percurso ------------ -- - - -

% Predicado de procura não informada por procura em largura, que indica quais as paragens com o maior número de carreiras num percurso.
bfsMaiorNumeroCarreiras(Origem, Destino, S) :- bfs(Origem, Destino, Caminho), ordenaCarreiras(Caminho, S).

% Predicado que ordena uma lista de carreiras.
ordenaCarreiras(Lista, Ordenada) :- gidNumeroCarreirasCaminho(Lista,[],S), ordenar(S, Ordenada).

% Predicado que ordena por ordem decrescente de número de carreiras a lista de paragens.
ordenar([(Gid, Carreira)],[(Gid, Carreira)]).
ordenar([(Gid, Carreira)|T], S) :- ordenar(T, R), addOrdenaDecrescente((Gid,Carreira),R, S).

% Predicado auxiliar ao cálculo da ordenação decrescente do número de carreiras.
addOrdenaDecrescente((Gid, Carreira), [], S) :- S = [(Gid, Carreira)].
addOrdenaDecrescente((Gid, Carreira), [(A,B)|T], S) :- B =< Carreira -> S = [(Gid, Carreira), (A,B)|T]; addOrdenaDecrescente((Gid,Carreira), T, R), S = [(A, B)|R].

% Predicado que obtém uma lista com o número de carreiras de cada paragem.
gidNumeroCarreirasCaminho([], Lista, S) :- S = Lista.
gidNumeroCarreirasCaminho([Gid|T], Lista, S) :- gidNumeroCarreiras(Gid,Carreiras), gidNumeroCarreirasCaminho(T, [(Gid,Carreiras)|Lista],S).

% Predicado que calcula o número de carreiras por paragem.
gidNumeroCarreiras(Paragem, S) :- paragem(Paragem,_,_,_,_,_,_,Carreiras,_,_,_), comp(Carreiras, S).





resolve_aestrela(Nodo, Caminho/Custo) :-
	estima(Nodo, Estima),
	aestrela([[Nodo]/0/Estima], InvCaminho/Custo/_),
	inverso(InvCaminho, Caminho).

aestrela(Caminhos, Caminho) :-
	obtem_melhor(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,goal(Nodo).

aestrela(Caminhos, SolucaoCaminho) :-
	obtem_melhor(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        aestrela(NovoCaminhos, SolucaoCaminho).


obtem_melhor([Caminho], Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).

obtem_melhor([_|Caminhos], MelhorCaminho) :-
	obtem_melhor(Caminhos, MelhorCaminho).

expande_aestrela(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente(Caminho,NovoCaminho), ExpCaminhos).

adjacente([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
	move(Nodo, ProxNodo, PassoCusto),\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCusto,
	estima(ProxNodo, Est).











% - - - -- -- -- --------------------------------------- Predicados Auxiliares --------------------------------------- -- -- -- - - -

% Predicado que calcula o comprimento de uma lista.
comp([],0).
comp([X],1).
comp([H|T],R) :- comp(T,P),
                R is 1 + P.

% Extensão do meta-predicado não.
nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

% Predicado que calcula a distância entre dois pontos de coordenadas através dos seus valores de latitude e longitude.
distancia(Latitude1, Longitude1, Latitude2, Longitude2, Distancia) :-
  P is 0.017453292519943295,
  A is (0.5 - cos((Latitude2 - Latitude1) * P) / 2 + cos(Latitude1 * P) * cos(Latitude2 * P) * (1 - cos((Longitude2 - Longitude1) * P)) / 2),
  Distancia is (12742 * asin(sqrt(A)) / 1000).

% Predicado que calcula a distância Euclidiana entre dois pontos
distanciaEuclidiana(Latitude1, Longitude1, Latitude2, Longitude2, Distancia) :- Distancia is (sqrt((Latitude2-Latitude1)^2 + (Longitude2-Longitude1)^2)) / 1000.
