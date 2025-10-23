object manzana{
    var property position = game.at(7,9)
    method image() = "manzana.png"
    
    method posicionRandom(snake){
    const a = new Position(x= 0.randomUpTo(50).floor(), y= 0.randomUpTo(50).floor())

    if (snake.cola().any({c => (c.position().x() == a.x() && c.position().y() == a.y()) }))  {
        self.posicionRandom(snake)       
    }
    else {
        position = a
    }
    }

}

class Cola {

    var property position 

    method image() = "cola.png"

}


object snake{
var longitud = 1
   var property position = game.at(5,5)
   var property cola = [new Cola(position = game.at(4,5))]
 

    method aumentarLongitud(){
    // Obtenemos la posición del *último* segmento actual.
    var posUltimoSegmento = cola.last().position()
    
    // Creamos el nuevo segmento EN ESA MISMA POSICIÓN.
    var nuevaCola = new Cola (position = posUltimoSegmento)
    
    // Lo agregamos a la lista y al juego.
    cola.add(nuevaCola)
    game.addVisual(nuevaCola)
    
    longitud += 1
}


    method visualSnake() {
        game.addVisual(self)
        cola.forEach( {c => game.addVisual(c)}) 
      
    }

    method longitud() = longitud

    method image() = "snake.png"



    method move(nuevaPosicion){
    // 1. Guardamos la posición que el siguiente segmento deberá ocupar.
    //    Empezamos con la posición *actual* de la cabeza (antes de moverla).
    var proximaPosicion = self.position()
    
    // 2. Recorremos la cola
    cola.forEach({ unSegmento =>
        // Guardamos la posición *actual* de ESTE segmento,
// porque será la que ocupe el segmento que le sigue.
const posActualDelSegmento = unSegmento.position()
        
        // Movemos ESTE segmento a la posición del segmento de adelante (o la cabeza).
        unSegmento.position(proximaPosicion)
        
        // Actualizamos la variable para la *siguiente* iteración del forEach.
        proximaPosicion = posActualDelSegmento
    })
    
    // 3. Ahora que toda la cola se movió, movemos la cabeza.
    self.position(nuevaPosicion)
    
}
  
}