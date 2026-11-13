"
CarreraJuego comment: 
'Representa la lógica principal del juego de carreras 2D. 
Administra las condiciones de victoria y derrota, el tiempo de supervivencia restante, 
la cantidad de vidas del jugador y la coordinación del ciclo de juego (tick).'
"
Class {
	#name : 'CarreraJuego',
	#superclass : 'Object',
	#instVars : [
		'vidas',
		'tiemporestante',
		'jugador',
		'pista',
		'obstaculos',
		'estado'
	],
	#category : 'CarreraModelo',
	#package : 'CarreraModelo'
}

{ #category : 'gameplay' }
CarreraJuego >> estaEnJuego [
	^ estado = #enJugada
]

{ #category : 'accessing' }
CarreraJuego >> estado [
	^ estado
]

{ #category : 'gameplay' }
CarreraJuego >> generarObstaculo [
	| hayEspacioLibre azar nuevoElemento |
	"Verifica que todos los elementos actuales hayan bajado al menos 140 px (2 autos de alto)"
	hayEspacioLibre := obstaculos allSatisfy: [ :elem | elem posicionY >= 140 ].
	hayEspacioLibre ifFalse: [ ^ self ].

	azar := 10 atRandom.
	azar <= 4 ifTrue: [
		nuevoElemento := (azar = 1)
			ifTrue: [ ItemEscudo new ]
			ifFalse: [
				(2 atRandom = 1)
					ifTrue: [ AutoEnemigo new ]
					ifFalse: [ Pozo new ] ].
		obstaculos add: nuevoElemento.
	].
]

{ #category : 'initialization' }
CarreraJuego >> initialize [
	super initialize.
	vidas := 3.
	tiemporestante := 120. "Tiempo X estipulado para la victoria"
	jugador := VehiculoJugador new.
	pista := Pista new.
	obstaculos := OrderedCollection new.
	estado := #enJugada.
]

{ #category : 'accessing' }
CarreraJuego >> jugador [
	^ jugador
]

{ #category : 'gameplay' }
CarreraJuego >> moverObstaculos [
	obstaculos do: [ :obs | obs avanzar ].
	obstaculos removeAllSuchThat: [ :obs | obs salioDePista ].
]

{ #category : 'accessing' }
CarreraJuego >> obstaculos [
	^ obstaculos
]

{ #category : 'gameplay' }
CarreraJuego >> restarTiempo: unosSegundos [
	tiemporestante := (tiemporestante - unosSegundos) max: 0.
]

{ #category : 'gameplay' }
CarreraJuego >> restarVida [
	jugador tieneEscudo ifTrue: [
		jugador consumirEscudo.
		^ self
	].
	vidas := vidas - 1.
	vidas <= 0 ifTrue: [ estado := #derrota ].
]

{ #category : 'gameplay' }
CarreraJuego >> sumarTiempo: unosSegundos [
	jugador tieneEscudo ifTrue: [
		jugador consumirEscudo.
		^ self
	].
	tiemporestante := tiemporestante + unosSegundos.
]

{ #category : 'gameplay' }
CarreraJuego >> tick [
	self estaEnJuego ifFalse: [ ^ self ].
	
	tiemporestante := tiemporestante - 1.
	self verificarCondicionVictoria.
	self generarObstaculo.
	self moverObstaculos.
	self verificarColisiones.
]

{ #category : 'accessing' }
CarreraJuego >> tiemporestante [
	^ tiemporestante
]

{ #category : 'gameplay' }
CarreraJuego >> verificarColisiones [
	| tocados |
	tocados := obstaculos select: [ :elem |
		(elem carril = jugador carril) and: [ elem posicionY between: 420 and: 480 ]
	].
	tocados do: [ :elem |
		elem interactuarCon: self.
		obstaculos remove: elem.
	].
]

{ #category : 'gamepla' }
CarreraJuego >> verificarCondicionVictoria [
	tiemporestante <= 0 ifTrue: [ estado := #victoria ].
]

{ #category : 'accessing' }
CarreraJuego >> vidas [
	^ vidas
]
