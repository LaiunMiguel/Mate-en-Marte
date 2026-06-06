## Interfaz base para todos los estados: No hace nada en si mismo
## pero fuerza a pasar los argumentos correctos a los métodos
## de abajo y se asegura de que cada objeto que extienda de esta clase
## tenga todos los métodos marcados con @abstract
@abstract
class_name AbstractState 
extends Node


## Señal que se llama al terminar el estado actual y que recibe como
## parámetro el estado siguiente a transicionar
@warning_ignore("unused_signal")
signal finished(next_state_name: StringName)


## ID del estado. Debe de ser único entre todos los estados
## que conforman a la máquina de estados actual.
@export var state_id: String


# Inicializa el estado. Por ej, cambiar la animación
@abstract
func enter() -> void


# Limpia el estado. Por ej, reiniciar valores de variables o detener timers
@abstract
func exit() -> void


# Callback derivado de _input
@abstract
func handle_input(event: InputEvent) -> void


# Callback derivado de _physics_process
@abstract
func update(delta: float) -> void
