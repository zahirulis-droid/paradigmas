# Carrera Retro 2D 

## 1. Arquitectura del Proyecto

El sistema está dividido en dos paquetes con responsabilidades bien delimitadas:

### Paquete CarreraModelo (Lógica de Dominio)

Contiene las reglas de negocio, mecánicas de movimiento, colisiones, gestión de tiempo/vidas y generación aleatoria de elementos sin dependencias visuales:

**CarreraJuego:** Orquestador principal de la partida. Administra las vidas (3 iniciales), tiemporestante (cuenta regresiva de 120 unidades hasta la meta), la colección de elementos activos (obstaculos), el estado (#enJugada, #victoria, #derrota) y el ciclo de actualización (tick).

**VehiculoJugador:** Representa el móvil controlado por el usuario. Gestiona su carril actual (1 a 3), velocidad y el estado de protección (tieneEscudo), con métodos para desplazarse (moverIzquierda, moverDerecha) y gestionar el escudo (activarEscudo, consumirEscudo).

**Pista:** Modela la estructura lógica de la carretera (cantidadCarriles, largo).

**ElementoPista:** Define el estado y comportamiento común de cualquier entidad móvil que desciende por la pista (carril, posicionY, velocidad, avanzar, salioDePista) y declara el mensaje abstracto interactuarCon:.

**Obstaculo:** Especializa los elementos perjudiciales delegando la penalización concreta a sus subclases mediante aplicarPenalizacionEn:.

**AutoEnemigo:** Obstáculo móvil que resta una vida (restarVida) y reduce la velocidad del vehículo al colisionar.

**Pozo:** Bache en el asfalto que penaliza sumando 20 unidades al tiempo restante hacia la meta (sumarTiempo: 20) y reduciendo la velocidad.

**ItemEscudo:** Ítem recolectable que activa un escudo protector (activarEscudo) en el vehículo del jugador, absorbiendo la próxima colisión contra un AutoEnemigo o Pozo sin sufrir penalizaciones.

### Paquete CarreraUI

**CarreraMorph:** Vista 2D encargada de renderizar la pista de 3 carriles con desplazamiento continuo (drawOn:), dibujar el vehículo del jugador (con aura celeste cuando el escudo está activo), representar polimórficamente los elementos mediante colorVisual, capturar eventos de teclado (keyStroke:) y ejecutar el bucle visual mediante step y stepTime.
