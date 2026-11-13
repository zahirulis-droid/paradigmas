"
Representa la interfaz gráfica 2D del juego desarrollada sobre el framework Morphic.
Su responsabilidad es mantener una referencia al modelo de dominio (CarreraJuego) para 
renderizar visualmente en pantalla la pista, el vehículo del jugador, los obstáculos y el 
estado de la partida, así como capturar las entradas del teclado y controlar el bucle de 
actualización visual (stepping) sin contener lógica de negocio.
"
Class {
	#name : 'CarreraMorph',
	#superclass : 'BorderedMorph',
	#instVars : [
		'juego',
		'lineasPistaOffset'
	],
	#category : 'CarreraUI',
	#package : 'CarreraUI'
}

{ #category : 'drawing' }
CarreraMorph >> drawOn: aCanvas [
	| anchoCarril jugadorX jugadorRect |
	super drawOn: aCanvas.
	anchoCarril := self width // 3.
	
	"1. Dibujar líneas punteadas de los carriles en movimiento"
	1 to: 2 do: [ :linea |
		| x |
		x := self left + (linea * anchoCarril).
		lineasPistaOffset to: self height by: 40 do: [ :y |
			aCanvas
				fillRectangle: (x - 2 @ (self top + y) extent: 4 @ 20)
				color: Color white.
		].
	].
	
	"2. Dibujar Elementos en Pista (Enemigos, Pozos y Escudos)"
	juego obstaculos do: [ :elem |
		| centroX elemRect colorElem |
		centroX := self left + ((elem carril - 1) * anchoCarril) + (anchoCarril // 2).
		elemRect := (centroX - 22) @ (self top + elem posicionY) extent: 44 @ 55.
		
		colorElem := elem colorVisual.
		aCanvas fillRectangle: elemRect color: colorElem.
		aCanvas frameRectangle: elemRect width: 2 color: Color white.
	].
	
	"3. Dibujar Vehículo del Jugador (en posicionY = 440)"
	jugadorX := self left + ((juego jugador carril - 1) * anchoCarril) + (anchoCarril // 2).
	jugadorRect := (jugadorX - 24) @ (self top + 440) extent: 48 @ 65.
	
	"Si tiene escudo activo, dibuja un aura celeste alrededor"
	juego jugador tieneEscudo ifTrue: [
		aCanvas
			fillOval: (jugadorRect expandBy: 10)
			color: (Color cyan alpha: 0.45).
	].
	
	aCanvas fillRectangle: jugadorRect color: Color yellow.
	aCanvas frameRectangle: jugadorRect width: 2 color: Color black.
	
	"4. Panel superior (HUD: Vidas y Tiempo)"
	aCanvas
		drawString: ('VIDAS: ', juego vidas printString, '   |   TIEMPO: ', juego tiemporestante printString)
		at: (self left + 20) @ (self top + 12)
		font: nil
		color: Color white.
	
	"5. Cartel de Victoria o Derrota al finalizar"
	juego estaEnJuego ifFalse: [
		| cartelRect mensaje |
		cartelRect := (self left + 30) @ (self top + 200) extent: (self width - 60) @ 110.
		aCanvas fillRectangle: cartelRect color: (Color black alpha: 0.85).
		aCanvas frameRectangle: cartelRect width: 2 color: Color yellow.
		
		mensaje := (juego estado = #victoria)
			ifTrue: [ '¡VICTORIA! Llegaste a la meta' ]
			ifFalse: [ 'GAME OVER - Sin vidas' ].
			
		aCanvas drawString: mensaje at: (self left + 65) @ (self top + 225) font: nil color: Color yellow.
		aCanvas drawString: 'Presiona ESPACIO para jugar de nuevo' at: (self left + 45) @ (self top + 265) font: nil color: Color white.
	].
]

{ #category : 'event handling' }
CarreraMorph >> handlesKeyboard: anEvent [
	^ true
]

{ #category : 'event handling' }
CarreraMorph >> handlesMouseOver: anEvent [
	^ true
]

{ #category : 'initialization' }
CarreraMorph >> initialize [
	super initialize.
	self extent: 360 @ 540.
	self color: (Color r: 0.18 g: 0.18 b: 0.22). "Color asfalto oscuro"
	self borderWidth: 3; borderColor: Color black.
	juego := CarreraJuego new.
	lineasPistaOffset := 0.
]

{ #category : 'event handling' }
CarreraMorph >> keyStroke: anEvent [
	| tecla |
	tecla := anEvent keyCharacter.

	"Flecha izquierda (ASCII 28) o letra 'a'"
	(tecla = Character arrowLeft or: [ tecla = $a ]) ifTrue: [
		juego jugador moverIzquierda.
		self changed.
	].

	"Flecha derecha (ASCII 29) o letra 'd'"
	(tecla = Character arrowRight or: [ tecla = $d ]) ifTrue: [
		juego jugador moverDerecha.
		self changed.
	].

	"Barra espaciadora para reiniciar si terminó la partida"
	(tecla = Character space and: [ juego estaEnJuego not ]) ifTrue: [
		juego := CarreraJuego new.
		self changed.
	].
]

{ #category : 'event handling' }
CarreraMorph >> mouseEnter: anEvent [
	anEvent hand newKeyboardFocus: self
]

{ #category : 'stepping' }
CarreraMorph >> step [
	juego estaEnJuego ifTrue: [
		juego tick.
		lineasPistaOffset := (lineasPistaOffset + 25) rem: 40.
	].
	self changed.
]

{ #category : 'stepping' }
CarreraMorph >> stepTime [
	^ 60
]
