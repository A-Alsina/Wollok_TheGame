object manzana{
    var property position = game.at(7,9)
    method image() = "manzana.png"
    
    method posicionRandom(snake){
    const a = new Position(x= 0.randomUpTo(49).floor(), y= 0.randomUpTo(49).floor())

    if (snake.partes().any({c => (c.position().x() == a.x() && c.position().y() == a.y()) }))  {
        self.posicionRandom(snake)       
    }
    else {
        position = a
    }
    }

    method efectoComida(snake){
        snake.aumentarLongitud()
        self.posicionRandom(snake)
    }

}

class Parte {

    var property position 

    var property image = "cola.png"

}


object snake{
   var longitud = 1
   var property partes = [new Parte(position = game.at(5,5), image = "snake.png")]
 

    method aumentarLongitud(){
    // Obtenemos la posición del *último* segmento actual.
    const posUltimoSegmento = partes.last().position()
    
    // Creamos el nuevo segmento EN ESA MISMA POSICIÓN.
    const nuevaCola = new Parte (position = posUltimoSegmento)
    
    // Lo agregamos a la lista y al juego.
    partes.add(nuevaCola)
    game.addVisual(nuevaCola)
    
    longitud += 1
}


    method visualSnake() {
        partes.forEach( {c => game.addVisual(c)}) 
      
    }

    method longitud() = longitud


    method comer(comida){
    comida.efectoComida(self)
    }

    method move(nuevaPosicion){
    // 1. Guardamos la posición que el siguiente segmento deberá ocupar.
    //    Empezamos con la posición *actual* de la cabeza (antes de moverla).
    var proximaPosicion = nuevaPosicion

    if(nuevaPosicion.x() > 49 || nuevaPosicion.y() > 49 || nuevaPosicion.x() < 0 || nuevaPosicion.y() < 0){
     game.stop()
    }

    // 2. Recorremos la cola
    partes.forEach({ unSegmento =>
        // Guardamos la posición *actual* de ESTE segmento,
// porque será la que ocupe el segmento que le sigue.
    const posActualDelSegmento = unSegmento.position()
        
        // Movemos ESTE segmento a la posición del segmento de adelante (o la cabeza).
        unSegmento.position(proximaPosicion)
        
        // Actualizamos la variable para la *siguiente* iteración del forEach.
        proximaPosicion = posActualDelSegmento
    })
    
}
  
}


object clock{
    var direccion = [right,down,left,up]
    var property rotor = right

    method rotarDerecha() {
        rotor = direccion.head()
        direccion.remove(direccion.head())
        direccion.add(rotor)
    }

     method rotarIzquierda() {
        direccion = direccion.reverse()
        self.rotarDerecha()
        direccion = direccion.reverse()
    }

    method movimiento() {direccion.head().mover()}
    
}


object right {
    method mover() {snake.move(snake.partes().first().position().right(1))}
}

object left {
    method mover() {snake.move(snake.partes().first().position().left(1))}
}

object down {
    method mover() {snake.move(snake.partes().first().position().down(1))}
}

object up {
    method mover() {snake.move(snake.partes().first().position().up(1))}
}