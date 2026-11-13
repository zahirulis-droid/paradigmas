"
Representa un vehículo rival que circula por la pista como obstáculo.
Su responsabilidad es definir una penalización grave al colisionar con el jugador, 
restando una vida y reduciendo la velocidad del vehículo principal.
"
Class {
	#name : 'AutoEnemigo',
	#superclass : 'Obstaculo',
	#category : 'CarreraModelo',
	#package : 'CarreraModelo'
}

{ #category : 'gameplay' }
AutoEnemigo >> aplicarPenalizacionEn: unJuego [
	unJuego restarVida.
	unJuego jugador reducirVelocidad.
]

{ #category : 'accessing' }
AutoEnemigo >> colorVisual [
	^ Color red
]
