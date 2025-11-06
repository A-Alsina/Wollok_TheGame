import sonidos.*

object inicio {
    method image()= "fotoInicio.png"
    method position() = game.at(0,0)
}

class ObjetoSuelo{
    var property position 
    method image() 

    method chocar(snake)

    method posicionRandom(snake){
        const a = new Position(x= 0.randomUpTo(game.width()-1).floor(), y= 0.randomUpTo(game.height()-1).floor())
        if (snake.partes().any({c => (c.position().x() == a.x() && c.position().y() == a.y()) }))  {
            self.posicionRandom(snake)       
        }
        else {
            position = a
        }
    }
}


object manzana inherits ObjetoSuelo(position = game.at(7,9)){
    override method image() = "manzana.png"

    override method chocar(snake){
        snake.aumentarLongitud()
        self.posicionRandom(snake)
        sonidoComerManzana.play()
    }



}

object bomba inherits ObjetoSuelo(position = game.at(game.width() - 3, game.height()-3)){
    override method image() = "bomba.png"

    override method chocar(snake){
        sonidoBomba.play()
        interfazJuego.pararJuego()
    }

}



class Parte {
    var property position 
    var property image = "RPartePH.png"

    method chocar(snake){ 
        interfazJuego.pararJuego()
    }

    method redireccionarImagen(direccion){
    self.image(direccion.letra() + image.drop(1))
    }

}


object snake{
   var longitud = 1
   var property partes = [new Parte(position = game.at(5,5), image = "RcabezaPH.png"), new Parte(position = game.at(4,5))]
 

    method aumentarLongitud(){
    
    const posUltimoSegmento = partes.last().position()
    
   
    const nuevaCola = new Parte (position = posUltimoSegmento)
    
    
    partes.add(nuevaCola)
    game.addVisual(nuevaCola)
    
    longitud += 1
}


    method visualSnake() {
        partes.forEach( {c => game.addVisual(c)}) 
      
    }

    method longitud() = longitud



    method move(nuevaPosicion){
   var proximaPosicion = nuevaPosicion

    if(nuevaPosicion.x() > game.width()-1 || nuevaPosicion.y() > game.width()-1|| nuevaPosicion.x() < 0 || nuevaPosicion.y() < 0){
     interfazJuego.pararJuego()
      
    }

 
    if ( self.longitud() > 3 and partes.any({unSegmento => unSegmento.position()==(nuevaPosicion)})){
        interfazJuego.pararJuego()
    }
    partes.forEach({ unSegmento =>
        const posActualDelSegmento = unSegmento.position()
        unSegmento.position(proximaPosicion)
        proximaPosicion = posActualDelSegmento
    })
    
}
  
}


object clock{
    var property direccion = right
    var property sePuedeRedireccionar = true  

    method movimiento(){
         sePuedeRedireccionar = true
         direccion.mover()}
      

    method redireccionar(nuevaDireccion){
        if(sePuedeRedireccionar){
        if(nuevaDireccion != self.direccion().opuesto() && direccion != nuevaDireccion){
            direccion = nuevaDireccion
            snake.partes().forEach({parte => parte.redireccionarImagen(nuevaDireccion)})
        }
        sePuedeRedireccionar = false
        }
    }
}


object right {
    method letra() = "R"

    method mover() {snake.move(snake.partes().first().position().right(1))}
    

    method opuesto() = left
}

object left {
    method letra() = "L"

    method mover() {snake.move(snake.partes().first().position().left(1))}

    method opuesto() = right
}

object down {
    method letra() = "D"

    method mover() {snake.move(snake.partes().first().position().down(1))}

    method opuesto() = up
}

object up {
    method letra() = "U" 

    method mover() {snake.move(snake.partes().first().position().up(1))}

    method opuesto() = down
}

object interfazJuego{

    method pararJuego(){
    game.schedule(500, {sonidoGameOver.play()})
    

    game.removeTickEvent("movimiento")
    game.schedule(1000, {sonidoMusicaFondo.stop()})
    game.schedule(2000, {game.stop()})
    
    }
}


