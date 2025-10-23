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

    var posUltimoSegmento = cola.last().position()
    

    var nuevaCola = new Cola (position = posUltimoSegmento)
    

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

    var proximaPosicion = self.position()

    cola.forEach({ unSegmento =>

const posActualDelSegmento = unSegmento.position()
        

        unSegmento.position(proximaPosicion)
        

        proximaPosicion = posActualDelSegmento
    })
    

    self.position(nuevaPosicion)
    
}
  
}