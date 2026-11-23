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
		'lineasPistaOffset',
		'lineaLargadaY'
	],
	#category : 'CarreraUI',
	#package : 'CarreraUI'
}

{ #category : 'drawing' }
CarreraMorph >> drawOn: aCanvas [
	| anchoCarril jugadorX jugadorRect rosaOscuro |
	super drawOn: aCanvas.
	anchoCarril := self width // 3.
	rosaOscuro := Color r: 0.85 g: 0.25 b: 0.55.
	
"0. Banquinas laterales pegadas al borde de la pista (rosa oscuro y blanco)"
	0 to: self height by: 30 do: [ :y |
		| colorBanquina |
		colorBanquina := ((y // 30) even) ifTrue: [ rosaOscuro ] ifFalse: [ Color white ].
		aCanvas fillRectangle: (self left @ (self top + y) extent: 10 @ 30) color: colorBanquina.
		aCanvas fillRectangle: ((self right - 10) @ (self top + y) extent: 10 @ 30) color: colorBanquina.
	].

	"1. Líneas punteadas de los carriles en movimiento"
	1 to: 2 do: [ :linea |
		| x |
		x := self left + (linea * anchoCarril).
		lineasPistaOffset to: self height by: 40 do: [ :y |
			aCanvas
				fillRectangle: (x - 2 @ (self top + y) extent: 4 @ 22)
				color: (Color white alpha: 0.75).
		].
	].

	"1.5 Línea de START (solo al inicio de la partida)"
	(lineaLargadaY ifNil: [ 395 ]) <= self height ifTrue: [
		| altoCuadro anchoCuadro |
		altoCuadro := 10.
		anchoCuadro := 18.
		(self left + 12) to: (self right - 28) by: anchoCuadro do: [ :x |
			| esBlanco |
			esBlanco := (((x - self left) // anchoCuadro) even).
			aCanvas
				fillRectangle: (x @ (self top + lineaLargadaY) extent: anchoCuadro @ altoCuadro)
				color: (esBlanco ifTrue: [ Color white ] ifFalse: [ Color black ]).
			aCanvas
				fillRectangle: (x @ (self top + lineaLargadaY + altoCuadro) extent: anchoCuadro @ altoCuadro)
				color: (esBlanco ifTrue: [ Color black ] ifFalse: [ Color white ]).
		].
		aCanvas
			drawString: 'START'
			at: (self left + (self width // 2) - 22) @ (self top + lineaLargadaY - 18)
			font: nil
			color: Color white.
	].
	
	"2. Obstáculos e Ítems con formas diferenciadas"
	juego obstaculos do: [ :elem |
		| centroX elemRect colorElem |
		centroX := self left + ((elem carril - 1) * anchoCarril) + (anchoCarril // 2).
		elemRect := (centroX - 22) @ (self top + elem posicionY) extent: 44 @ 55.
		colorElem := elem colorVisual.
		
		"Pozo (darkGray) -> Bache ovalado con profundidad"
		(colorElem = Color darkGray) ifTrue: [
			| bache |
			bache := (centroX - 21) @ (self top + elem posicionY + 10) extent: 42 @ 34.
			aCanvas fillOval: bache color: Color black.
			aCanvas frameOval: bache width: 2 color: (Color r: 0.35 g: 0.35 b: 0.35).
			aCanvas fillOval: (bache insetBy: 8) color: (Color r: 0.08 g: 0.08 b: 0.08).
		].
		
		"Escudo (cyan) -> Esfera energética brillante"
		(colorElem = Color cyan) ifTrue: [
			| orb |
			orb := (centroX - 17) @ (self top + elem posicionY + 10) extent: 34 @ 34.
			aCanvas fillOval: (orb expandBy: 4) color: (Color cyan alpha: 0.3).
			aCanvas fillOval: orb color: Color cyan.
			aCanvas frameOval: orb width: 2 color: Color white.
			aCanvas fillOval: (orb insetBy: 10) color: Color white.
		].
		"Moneda (yellow) -> Monedita dorada con brillo"
		(colorElem = Color yellow) ifTrue: [
			| monedaRect |
			monedaRect := (centroX - 14) @ (self top + elem posicionY + 12) extent: 28 @ 28.
			aCanvas fillOval: monedaRect color: (Color r: 1.0 g: 0.84 b: 0.0).
			aCanvas frameOval: monedaRect width: 2 color: (Color r: 0.85 g: 0.55 b: 0.0).
			aCanvas fillOval: (monedaRect insetBy: 7) color: (Color r: 1.0 g: 0.95 b: 0.55).
		].
		"Auto Enemigo (red en modelo -> Pixel-Art Deportivo Morado mirando hacia abajo)"
		(colorElem = Color red) ifTrue: [
			| moradoClaro moradoBase moradoSombra |
			moradoClaro := Color r: 0.72 g: 0.42 b: 0.96.
			moradoBase := Color r: 0.55 g: 0.22 b: 0.85.
			moradoSombra := Color r: 0.28 g: 0.08 b: 0.48.
			
			"4 Ruedas negras sobresaliendo"
			aCanvas fillRectangle: ((elemRect left - 2) @ (elemRect top + 8) extent: 4 @ 11) color: Color black.
			aCanvas fillRectangle: ((elemRect right - 2) @ (elemRect top + 8) extent: 4 @ 11) color: Color black.
			aCanvas fillRectangle: ((elemRect left - 2) @ (elemRect bottom - 19) extent: 4 @ 11) color: Color black.
			aCanvas fillRectangle: ((elemRect right - 2) @ (elemRect bottom - 19) extent: 4 @ 11) color: Color black.
			
			"Cuerpo principal pixel-art escalonado"
			aCanvas fillRectangle: ((elemRect left + 3) @ (elemRect top + 2) extent: 38 @ 51) color: moradoBase.
			aCanvas fillRectangle: ((elemRect left + 1) @ (elemRect top + 6) extent: 42 @ 43) color: moradoBase.
			
			"Bordes iluminados laterales"
			aCanvas fillRectangle: ((elemRect left + 2) @ (elemRect top + 7) extent: 3 @ 40) color: moradoClaro.
			aCanvas fillRectangle: ((elemRect right - 5) @ (elemRect top + 7) extent: 3 @ 40) color: moradoClaro.
			
			"Doble franja racing central (de arriba a abajo)"
			aCanvas fillRectangle: ((centroX - 6) @ (elemRect top + 2) extent: 4 @ 51) color: moradoSombra.
			aCanvas fillRectangle: ((centroX + 2) @ (elemRect top + 2) extent: 4 @ 51) color: moradoSombra.
			
			"Alerón trasero ancho (arriba)"
			aCanvas fillRectangle: ((elemRect left) @ (elemRect top + 1) extent: 44 @ 5) color: moradoSombra.
			aCanvas fillRectangle: ((elemRect left + 2) @ (elemRect top + 2) extent: 40 @ 2) color: moradoClaro.
			
			"Luneta trasera (arriba de la cabina) y parabrisas delantero (abajo)"
			aCanvas fillRectangle: ((elemRect left + 8) @ (elemRect top + 11) extent: 28 @ 5) color: (Color r: 0.10 g: 0.12 b: 0.16).
			aCanvas fillRectangle: ((elemRect left + 7) @ (elemRect bottom - 19) extent: 30 @ 8) color: (Color r: 0.10 g: 0.12 b: 0.16).
			
			"Techo con doble franja"
			aCanvas fillRectangle: ((elemRect left + 9) @ (elemRect top + 16) extent: 26 @ 16) color: moradoClaro.
			aCanvas fillRectangle: ((centroX - 6) @ (elemRect top + 16) extent: 4 @ 16) color: moradoSombra.
			aCanvas fillRectangle: ((centroX + 2) @ (elemRect top + 16) extent: 4 @ 16) color: moradoSombra.
			
			"Faros delanteros (abajo)"
			aCanvas fillRectangle: ((elemRect left + 5) @ (elemRect bottom - 4) extent: 7 @ 3) color: Color yellow.
			aCanvas fillRectangle: ((elemRect right - 12) @ (elemRect bottom - 4) extent: 7 @ 3) color: Color yellow.
		].
		].

"3. Auto Pixel-Art Deportivo del Jugador (rosita pastel con doble franja blanca)"
	jugadorX := self left + ((juego jugador carril - 1) * anchoCarril) + (anchoCarril // 2).
	jugadorRect := (jugadorX - 24) @ (self top + 440) extent: 48 @ 65.
	
	"Aura celeste si tiene escudo activo"
	juego jugador tieneEscudo ifTrue: [
		aCanvas
			fillOval: (jugadorRect expandBy: 12)
			color: (Color cyan alpha: 0.40).
		aCanvas
			frameOval: (jugadorRect expandBy: 12)
			width: 2
			color: Color cyan.
	].
	
	"4 Ruedas negras sobresaliendo"
	aCanvas fillRectangle: ((jugadorRect left - 3) @ (jugadorRect top + 10) extent: 5 @ 13) color: Color black.
	aCanvas fillRectangle: ((jugadorRect right - 2) @ (jugadorRect top + 10) extent: 5 @ 13) color: Color black.
	aCanvas fillRectangle: ((jugadorRect left - 3) @ (jugadorRect bottom - 22) extent: 5 @ 13) color: Color black.
	aCanvas fillRectangle: ((jugadorRect right - 2) @ (jugadorRect bottom - 22) extent: 5 @ 13) color: Color black.
	
	"Cuerpo principal pixel-art escalonado (rosita pastel)"
	aCanvas fillRectangle: ((jugadorRect left + 4) @ (jugadorRect top + 1) extent: 40 @ 62) color: (Color r: 1.0 g: 0.72 b: 0.84).
	aCanvas fillRectangle: ((jugadorRect left + 1) @ (jugadorRect top + 6) extent: 46 @ 52) color: (Color r: 1.0 g: 0.72 b: 0.84).
	
	"Bordes laterales con brillo claro"
	aCanvas fillRectangle: ((jugadorRect left + 2) @ (jugadorRect top + 8) extent: 3 @ 48) color: (Color r: 1.0 g: 0.86 b: 0.92).
	aCanvas fillRectangle: ((jugadorRect right - 5) @ (jugadorRect top + 8) extent: 3 @ 48) color: (Color r: 1.0 g: 0.86 b: 0.92).
	
	"Doble franja racing central blanca (como el auto azul de tu referencia)"
	aCanvas fillRectangle: ((jugadorX - 7) @ (jugadorRect top + 1) extent: 5 @ 62) color: Color white.
	aCanvas fillRectangle: ((jugadorX + 2) @ (jugadorRect top + 1) extent: 5 @ 62) color: Color white.
	
	"Parabrisas delantero oscuro (arriba)"
	aCanvas fillRectangle: ((jugadorRect left + 7) @ (jugadorRect top + 14) extent: 34 @ 9) color: (Color r: 0.10 g: 0.12 b: 0.16).
	
	"Techo / cabina con sombreado rosa y sus dos franjas blancas"
	aCanvas fillRectangle: ((jugadorRect left + 9) @ (jugadorRect top + 23) extent: 30 @ 20) color: (Color r: 0.94 g: 0.54 b: 0.72).
	aCanvas fillRectangle: ((jugadorX - 7) @ (jugadorRect top + 23) extent: 5 @ 20) color: Color white.
	aCanvas fillRectangle: ((jugadorX + 2) @ (jugadorRect top + 23) extent: 5 @ 20) color: Color white.
	
	"Luneta trasera oscura"
	aCanvas fillRectangle: ((jugadorRect left + 9) @ (jugadorRect top + 43) extent: 30 @ 5) color: (Color r: 0.10 g: 0.12 b: 0.16).
	
	"Alerón trasero pixel-art ancho (abajo)"
	aCanvas fillRectangle: ((jugadorRect left) @ (jugadorRect bottom - 6) extent: 48 @ 5) color: (Color r: 0.85 g: 0.35 b: 0.58).
	aCanvas fillRectangle: ((jugadorRect left + 2) @ (jugadorRect bottom - 5) extent: 44 @ 2) color: Color white.
	
	"Faros delanteros blancos (arriba)"
	aCanvas fillRectangle: ((jugadorRect left + 5) @ (jugadorRect top + 2) extent: 8 @ 3) color: Color white.
	aCanvas fillRectangle: ((jugadorRect right - 13) @ (jugadorRect top + 2) extent: 8 @ 3) color: Color white.
	
"4. Panel superior (HUD con íconos gráficos)"
	aCanvas fillRectangle: ((self left + 10) @ self top extent: (self width - 20) @ 36) color: (Color black alpha: 0.72).
	aCanvas fillRectangle: ((self left + 10) @ (self top + 34) extent: (self width - 20) @ 2) color: rosaOscuro.

	"4.1 Corazones de vida (3 corazones: llenos en rosa fuerte, perdidos en gris oscuro)"
	1 to: 3 do: [ :i |
		| hx hy colorCorazon |
		hx := self left + 18 + ((i - 1) * 24).
		hy := self top + 10.
		colorCorazon := (i <= juego vidas)
			ifTrue: [ Color r: 1.0 g: 0.25 b: 0.55 ]
			ifFalse: [ Color r: 0.30 g: 0.30 b: 0.34 ].
		"Dos lóbulos superiores + triángulo inferior"
		aCanvas fillOval: (hx @ hy extent: 9 @ 9) color: colorCorazon.
		aCanvas fillOval: ((hx + 7) @ hy extent: 9 @ 9) color: colorCorazon.
		aCanvas
			drawPolygon: { hx @ (hy + 5) . (hx + 16) @ (hy + 5) . (hx + 8) @ (hy + 16) }
			color: colorCorazon
			borderWidth: 0
			borderColor: colorCorazon.
	].

	"4.2 Ícono de Reloj + Tiempo restante"
	aCanvas fillOval: ((self left + 128) @ (self top + 9) extent: 16 @ 16) color: Color white.
	aCanvas frameOval: ((self left + 128) @ (self top + 9) extent: 16 @ 16) width: 2 color: rosaOscuro.
	aCanvas line: (self left + 136) @ (self top + 17) to: (self left + 136) @ (self top + 12) width: 2 color: Color black.
	aCanvas line: (self left + 136) @ (self top + 17) to: (self left + 140) @ (self top + 17) width: 2 color: Color black.
	aCanvas
		drawString: juego tiemporestante printString
		at: (self left + 149) @ (self top + 10)
		font: nil
		color: Color white.

	"4.3 Ícono de Moneda dorada + Puntos recogidos"
	aCanvas fillOval: ((self left + 235) @ (self top + 9) extent: 16 @ 16) color: (Color r: 1.0 g: 0.84 b: 0.0).
	aCanvas frameOval: ((self left + 235) @ (self top + 9) extent: 16 @ 16) width: 2 color: (Color r: 0.85 g: 0.55 b: 0.0).
	aCanvas fillOval: ((self left + 239) @ (self top + 13) extent: 8 @ 8) color: (Color r: 1.0 g: 0.95 b: 0.55).
	aCanvas
		drawString: (juego puntos ifNil: [ 0 ]) printString
		at: (self left + 256) @ (self top + 10)
		font: nil
		color: (Color r: 1.0 g: 0.84 b: 0.0).
	
	"5. Cartel de Victoria o Derrota al finalizar"
	juego estaEnJuego ifFalse: [
		| cartelRect mensaje textoPuntos |
		cartelRect := (self left + 30) @ (self top + 185) extent: (self width - 60) @ 135.
		aCanvas fillRectangle: cartelRect color: (Color black alpha: 0.88).
		aCanvas frameRectangle: cartelRect width: 2 color: rosaOscuro.
		
		mensaje := (juego estado = #victoria)
			ifTrue: [ '¡VICTORIA! Llegaste a la meta' ]
			ifFalse: [ 'GAME OVER - Sin vidas' ].
		textoPuntos := 'PUNTOS RECOGIDOS: ', (juego puntos ifNil: [ 0 ]) printString.
			
		aCanvas drawString: mensaje at: (self left + 65) @ (self top + 205) font: nil color: (Color r: 1.0 g: 0.72 b: 0.84).
		aCanvas drawString: textoPuntos at: (self left + 85) @ (self top + 240) font: nil color: (Color r: 1.0 g: 0.72 b: 0.84).
		aCanvas drawString: 'Presiona ESPACIO para jugar de nuevo' at: (self left + 45) @ (self top + 280) font: nil color: Color white.
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
	self extent: 380 @ 540.
	self color: (Color r: 0.36 g: 0.37 b: 0.41).
	self borderWidth: 0.
	juego := CarreraJuego new.
	lineasPistaOffset := 0.
	lineaLargadaY := 395.
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
		lineaLargadaY := 395.
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
		lineaLargadaY <= self height ifTrue: [
			lineaLargadaY := lineaLargadaY + 25.
		].
	].
	self changed.
]

{ #category : 'stepping' }
CarreraMorph >> stepTime [
	| tiempoTranscurrido velocidadActual |
	tiempoTranscurrido := 400 - juego tiemporestante.
	velocidadActual := 130 - (tiempoTranscurrido * 2).
	^ velocidadActual max: 35
]
