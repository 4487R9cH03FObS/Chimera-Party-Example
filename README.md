# minijuego de Chimera Party
 
## Avances

* EventManager
* Orquestra de spawning

* Player
	* Desgaste de HP a través de colisiones
	* Implementadas las físicas de los juegadores
	* ejercer impulso en choque
	* Death
	* Fix bug: asimetría en impulse,damage dealing

* Sonido
	* SoundManager.

* Sistema de Puntajes
	* se asocia puntaje a la muerte de jugadores

* Sprites
	* Asteroides

## To Do

* Dreadnought:
	* Ataques
	* Coreografía

* Sonidos
	* SFX
	* Música
	* Entorno

* Sprites
	* Jugadores
	* Dreadnaught

* Player:

* Ataques:
	* Laser:
		area2d con auto free al salir de la pantalla
	* Bullet:
		rigid body 2d con autofree
	* WideBeam Dreadnaught:
		"" raycast desde player a dreadnaught.
		
* Sistema de Puntajes
	* puntajes a GUI
	* puntajes al finalizar

* GUI:
	* mostrar puntajes
	* comportamientos de puntajes dependiendo del estado de los jugadores
