"
Clase abstracta que representa cualquier elemento que entorpece el paso del jugador en la pista.
Su responsabilidad es mantener la posición (carril y coordenada vertical) y velocidad de avance 
comunes a todos los obstáculos, delegando a sus subclases el efecto específico de penalización 
mediante el método polimórfico aplicarPenalizacionEn:.
"
Class {
	#name : 'Obstaculo',
	#superclass : 'ElementoPista',
	#category : 'CarreraModelo',
	#package : 'CarreraModelo'
}

{ #category : 'gameplay' }
Obstaculo >> aplicarPenalizacionEn: unJuego [
	"Cada subclase definirá qué penalización aplica al chocar"
	self subclassResponsibility
]

{ #category : 'movement' }
Obstaculo >> avanzar [
	posicionY := posicionY + velocidad.
]

{ #category : 'accessing' }
Obstaculo >> carril [
	^ carril
]

{ #category : 'initialization' }
Obstaculo >> initialize [
	super initialize.
	carril := 3 atRandom. "Elige un carril al azar entre 1, 2 y 3"
	posicionY := 0.      "Arranca arriba de todo de la pista"
	velocidad := 10.
]

{ #category : 'gameplay' }
Obstaculo >> interactuarCon: unJuego [
	self aplicarPenalizacionEn: unJuego
]

{ #category : 'accessing' }
Obstaculo >> posicionY [
	^ posicionY
]

{ #category : 'movement' }
Obstaculo >> salioDePista [
	"Asumiendo que el largo de la pista es 500"
	^ posicionY > 500
]
