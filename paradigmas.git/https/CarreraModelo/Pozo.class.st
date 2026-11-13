"
Representa un bache o imperfección fija en el asfalto de la pista.
Su responsabilidad es definir una penalización leve al ser atravesado por el jugador, 
sumando tiempo disponible de carrera y reduciendo la velocidad del vehículo.
"
Class {
	#name : 'Pozo',
	#superclass : 'Obstaculo',
	#category : 'CarreraModelo',
	#package : 'CarreraModelo'
}

{ #category : 'gameplay' }
Pozo >> aplicarPenalizacionEn: unJuego [
	unJuego sumarTiempo: 20.
	unJuego jugador reducirVelocidad.
]

{ #category : 'accessing' }
Pozo >> colorVisual [
	^ Color darkGray
]
