"
Representa un ítem recolectable en la pista que otorga protección al jugador.
Al ser recogido, activa un escudo en el vehículo principal que absorbe el impacto 
de la próxima colisión contra un obstáculo sin perder vidas ni velocidad.
"
Class {
	#name : 'ItemEscudo',
	#superclass : 'ElementoPista',
	#category : 'CarreraModelo',
	#package : 'CarreraModelo'
}

{ #category : 'accessing' }
ItemEscudo >> colorVisual [
	^ Color cyan
]

{ #category : 'gameplay' }
ItemEscudo >> interactuarCon: unJuego [
	unJuego jugador activarEscudo.
]
