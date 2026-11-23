"
Representa el vehículo controlado por el jugador dentro de la pista de carreras.
Su responsabilidad es mantener su posición actual (carril) y su velocidad, 
gestionando los desplazamientos laterales dentro de los límites de la pista 
y las variaciones de velocidad por aceleración o penalizaciones.
"
Class {
	#name : 'VehiculoJugador',
	#superclass : 'Object',
	#instVars : [
		'carril',
		'vidas',
		'velocidad',
		'tieneEscudo',
		'tiempoPenalizacionPozo'
	],
	#category : 'CarreraModelo',
	#package : 'CarreraModelo'
}

{ #category : 'actions' }
VehiculoJugador >> activarEscudo [
	tieneEscudo := true.
]

{ #category : 'actions' }
VehiculoJugador >> actualizarPenalizacionConPaso: milisegundos [
	tiempoPenalizacionPozo > 0 ifTrue: [
		tiempoPenalizacionPozo := (tiempoPenalizacionPozo - milisegundos) max: 0.
		tiempoPenalizacionPozo = 0 ifTrue: [ velocidad := 10 ].
	].
]

{ #category : 'accessing' }
VehiculoJugador >> carril [
	^ carril
]

{ #category : 'actions' }
VehiculoJugador >> consumirEscudo [
	tieneEscudo := false.
]

{ #category : 'initialization' }
VehiculoJugador >> initialize [
	carril := 2.
	vidas := 3.
	velocidad := 10.
	tieneEscudo := false.
	tiempoPenalizacionPozo := 0.
]

{ #category : 'actions' }
VehiculoJugador >> moverDerecha [
	"Mueve el vehículo un carril hacia la derecha, siempre que no esté en el borde derecho (carril 3)"
	carril < 3 ifTrue: [
		carril := carril + 1.
	].
]

{ #category : 'actions' }
VehiculoJugador >> moverIzquierda [
	"Mueve el vehículo un carril hacia la izquierda, siempre que no esté en el borde izquierdo (carril 1)"
	carril > 1 ifTrue: [
		carril := carril - 1.
	].
]

{ #category : 'actions' }
VehiculoJugador >> reducirVelocidad [
	tieneEscudo ifTrue: [
		self consumirEscudo.
		^ self ].
	velocidad := (velocidad - 2) max: 2.
	tiempoPenalizacionPozo := 2000.
]

{ #category : 'accessing' }
VehiculoJugador >> tieneEscudo [
	^ tieneEscudo
]

{ #category : 'accessing' }
VehiculoJugador >> velocidad [
	^ velocidad 
]

{ #category : 'accessing' }
VehiculoJugador >> velocidad: unValor [
	velocidad := unValor
]
