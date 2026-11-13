"
Clase abstracta que representa cualquier entidad dinámica que aparece y se desplaza 
verticalmente a lo largo de los carriles de la pista (tanto obstáculos como ítems beneficiosos).
Su responsabilidad es gestionar la posición (carril y coordenada vertical) y la velocidad de 
avance comunes, delegando a sus subclases el efecto específico al entrar en contacto con 
el vehículo del jugador mediante el mensaje polimórfico interactuarCon:.
"
Class {
	#name : 'ElementoPista',
	#superclass : 'Object',
	#instVars : [
		'carril',
		'posicionY',
		'velocidad'
	],
	#category : 'CarreraModelo',
	#package : 'CarreraModelo'
}

{ #category : 'movement' }
ElementoPista >> avanzar [
	posicionY := posicionY + velocidad.
]

{ #category : 'accessing' }
ElementoPista >> carril [
	^ carril
]

{ #category : 'initialization' }
ElementoPista >> initialize [
	super initialize.
	carril := 3 atRandom. "Elige un carril al azar entre 1, 2 y 3"
	posicionY := 0.      "Arranca arriba de todo de la pista"
	velocidad := 10.
]

{ #category : 'gameplay' }
ElementoPista >> interactuarCon: unJuego [
	"Cada subclase define qué ocurre cuando el jugador toca este elemento"
	self subclassResponsibility
]

{ #category : 'accessing' }
ElementoPista >> posicionY [
	^ posicionY
]

{ #category : 'movement' }
ElementoPista >> salioDePista [
	"Asumiendo que el largo de la pista es 500"
	^ posicionY > 500
]
