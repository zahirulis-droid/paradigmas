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
		'velocidad',
		'tieneEscudo'
	],
	#category : 'CarreraModelo',
	#package : 'CarreraModelo'
}

{ #category : 'as yet unclassified' }
VehiculoJugador >> activarEscudo [
	tieneEscudo := true.
]

{ #category : 'accessing' }
VehiculoJugador >> carril [
	^ carril
]

{ #category : 'as yet unclassified' }
VehiculoJugador >> consumirEscudo [
	tieneEscudo := false.
]

{ #category : 'initialization' }
VehiculoJugador >> initialize [
	super initialize.
	carril := 2.
	velocidad := 25.
	tieneEscudo := false.
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
	tieneEscudo ifTrue: [ ^ self ].
	velocidad := (velocidad - 5) max: 2.
]

{ #category : 'accessing' }
VehiculoJugador >> tieneEscudo [
	^ tieneEscudo
]

{ #category : 'accessing' }
VehiculoJugador >> velocidad [
	^ velocidad 
]
