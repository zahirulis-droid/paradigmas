"
Representa una moneda recolectable en la pista que otorga puntos al jugador al ser recogida 
"
Class {
	#name : 'ItemMoneda',
	#superclass : 'ElementoPista',
	#category : 'CarreraModelo',
	#package : 'CarreraModelo'
}

{ #category : 'gameplay' }
ItemMoneda >> colorVisual [
	^ Color yellow
]

{ #category : 'gameplay' }
ItemMoneda >> interactuarCon: unJuego [
	unJuego sumarPuntos: 10.
]
