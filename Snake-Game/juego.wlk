import sonidos.*
import interfaz.*

class Pantalla{
    method image() 
    method position() = game.at(0,0)
}


object pantallaFinal inherits Pantalla{
  override method image()= "graciasPorJugar.png"
}

object inicio inherits Pantalla {
    override method image()= "fotoInicio.png"
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
        scored.aumentarScore()
        sonidoComerManzana.play()
    }



}

object bomba inherits ObjetoSuelo(position = game.at(game.width() - 3, game.height()-3)){
    override method image() = "bomba.png"

    override method chocar(snake){
        sonidoBomba.play()
        interfazJuegoReal.pararJuego()
    }

}
object manzanaDorada inherits ObjetoSuelo(position = game.at(9,9)){
    override method image() = "manzanaDorada.png"

    override method chocar(snake){
        sonidoComerManzana.play()
        game.removeVisual(self)
        snake.aumentarLongitud()
        snake.aumentarLongitud()
        snake.aumentarLongitud()
    }

    method aparecer(snake){
        self.posicionRandom(snake)
        game.addVisual(self)
    }

}



class Parte {
    var property position
    var property direccion = right 
    var property image = null

    method chocar(snake) { 
        interfazJuegoReal.pararJuego()
    }
    

    method redireccionarParte(nuevaDireccion) {
        
        const direccionAnt = self.direccion()
        
        
        self.direccion(nuevaDireccion)
        
        self.actualizarImagen(direccionAnt, nuevaDireccion)
    }
    

    method actualizarImagen(direccionAnt, direccionNueva) {
        
    }
    
  
    method inicializarImagen() {
        self.actualizarImagen(self.direccion(), self.direccion())
    }
}

class Cabeza inherits Parte {
    override method actualizarImagen(direccionAnt, direccionNueva) {
        self.image(direccionNueva.imagenCabeza())
    }
}

class Cuerpo inherits Parte {
   override method actualizarImagen(direccionAnt, direccionNueva) {
        if (direccionAnt == direccionNueva) {
          
            self.image(direccionNueva.imagenCuerpoRecto())
        } else {
            self.image(direccionNueva.imagenCuerpoEsquina(direccionAnt))
        }
    }
}


object snake{
 	var longitud = 1
 	var property partes = [
 		new Cabeza(position = game.at(5,5), direccion = right),
 		new Cuerpo(position = game.at(4,5), direccion = right)
 	]
 	
 	method inicializarImagenes(){
 		partes.forEach({parte => parte.inicializarImagen()})
 	}

 	method aumentarLongitud(){
 		const posUltimoSegmento = partes.last().position()
 		const direccionCola = partes.last().direccion()
 		
 		const nuevaCola = new Cuerpo (position = posUltimoSegmento, direccion = direccionCola)
 		nuevaCola.inicializarImagen()

 		partes.add(nuevaCola)
 		game.addVisual(nuevaCola)
 		
 		longitud += 1
    }

 	method visualSnake() {
 		partes.forEach( {c => game.addVisual(c)}) 
 	}

 	method longitud() = longitud


 	method move(nuevaPosicion, nuevaDireccion){
 		

 		if(nuevaPosicion.x() > game.width()-1 || nuevaPosicion.y() > game.height()-1|| nuevaPosicion.x() < 0 || nuevaPosicion.y() < 0){
 			interfazJuegoReal.pararJuego()
 		}
 		if ( self.longitud() > 3 and partes.any({unSegmento => unSegmento.position()==(nuevaPosicion)})){
 			interfazJuegoReal.pararJuego()
 	 	}

 		
 		const cabeza = partes.first()
 		const posCabezaAnt = cabeza.position()
 		const direccionCabezaAnt = cabeza.direccion()

 		
 		cabeza.position(nuevaPosicion)
 		cabeza.redireccionarParte(nuevaDireccion)

 	
 		var posParaSiguiente = posCabezaAnt
 		
 		var direccionParaSiguiente = nuevaDireccion 

 		
 		partes.drop(1).forEach({ parte =>
 			const posActualParte = parte.position()
 			const direccionActualParte = parte.direccion()

 			parte.position(posParaSiguiente)
 			parte.redireccionarParte(direccionParaSiguiente) 

 			
 			posParaSiguiente = posActualParte
 			direccionParaSiguiente = direccionActualParte
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
        }
        sePuedeRedireccionar = false
        }
    }
}


object right {
    method mover() {snake.move(snake.partes().first().position().right(1), self)}
    method opuesto() = left

    method imagenCabeza() = "RcabezaPH.png"
    method imagenCuerpoRecto() = "RcuerpoPH.png"
    method imagenCuerpoEsquina(direccionOrigen){
        if (direccionOrigen == up) {
            return "UResquinaPH.png" 
        } else { 
            return "DResquinaPH.png" 
        }
    }

    
}

object left {
    method mover() {snake.move(snake.partes().first().position().left(1), self)}
    method opuesto() = right

    method imagenCabeza() = "LcabezaPH.png"
    method imagenCuerpoRecto() = "LcuerpoPH.png"
    method imagenCuerpoEsquina(direccionOrigen) {
        if (direccionOrigen == up) {
            return "ULesquinaPH.png"  
        } else { 
            return "DLesquinaPH.png" 
        }
    }
}

object down {
    method mover() {snake.move(snake.partes().first().position().down(1), self)}
    method opuesto() = up

    method imagenCabeza() = "DcabezaPH.png"
    method imagenCuerpoRecto() = "DcuerpoPH.png"
    method imagenCuerpoEsquina(direccionOrigen) {
        if (direccionOrigen == left) {
            return "LDesquinaPH.png"  
        } else {
            return "RDesquinaPH.png" 
        }
    }
}

object up {
    method mover() {snake.move(snake.partes().first().position().up(1), self)}
    method opuesto() = down

    method imagenCabeza() = "UcabezaPH.png"
    method imagenCuerpoRecto() = "UcuerpoPH.png"
    method imagenCuerpoEsquina(direccionOrigen) {
        if (direccionOrigen == left) {
            return "LUesquinaPH.png"  
        } else { 
            return "RUesquinaPH.png" 
        }
    }



}

/*
object interfazJuego{

    method pararJuego(){
    game.schedule(500, {sonidoGameOver.play()})
    

    game.removeTickEvent("movimiento")
    game.schedule(1000, {sonidoMusicaFondo.stop()})
    game. addVisual(reinicio)
    
    keyboard.n().onPressDo({
        game.addVisual(pantallaFinal)
        game.schedule(2000, {game.stop()})
    })
    }
}
*/

object reinicio {
    method image()= "fotoReinicio.png"
    method position() = game.at(game.xCenter()-3,game.yCenter()-2) //hardcode medio raro para orientar la imagen
}

object gameOver{
    method image() = "gameOverGatito.png"
    method position()=game.at(3,3)

}