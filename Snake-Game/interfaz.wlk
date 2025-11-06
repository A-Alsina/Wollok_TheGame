import wollok.game.*
import juego.*
import sonidos.*


object interfazJuegoReal{

    method pararJuego(){
    game.schedule(500, {sonidoGameOver.play()})
    

    game.removeTickEvent("movimiento")
    game.removeTickEvent("bomba")
    game.removeTickEvent("manzanaDorada")
    game.schedule(1000, {sonidoMusicaFondo.stop()})
    game. addVisual(reinicio)
    game.addVisual(gameOver)
    //game.addVisual(score)
    keyboard.y().onPressDo({
            game.clear()
            setJuego.setInicio()

        })

    keyboard.n().onPressDo({    
    game.addVisual(pantallaFinal)
    game.schedule(2000, {game.stop()})})
    
    }
}

object setJuego{
    method setInicio(){
    sonidoMusicaFondo.playLoop()
    // Resetear lista de partes a la  configuración inicia
    snake.partes([ new Cabeza(position = game.at(5,5), direccion = right),
 		new Cuerpo(position = game.at(4,5), direccion = right)])



    // VISUALES
    snake.visualSnake()
    snake.inicializarImagenes()
    game.addVisual(manzana)
    
    game.onTick(200, "movimiento", {clock.movimiento()})
    keyboard.up().onPressDo({clock.redireccionar(up)})
    keyboard.down().onPressDo({clock.redireccionar(down)})
    keyboard.left().onPressDo({clock.redireccionar(left)})
    keyboard.right().onPressDo({clock.redireccionar(right)})

    game.onCollideDo(snake.partes().first(),{objetoSuelo => objetoSuelo.chocar(snake)})

    game.addVisual(bomba)
    game.onTick(10000,"bomba" ,{=> bomba.posicionRandom(snake) }) 
    game.onTick(10000, "manzanaDorada", { =>manzanaDorada.aparecer(snake)})
    }

    method reset(){
        game.clear()
    }
}

object imagenesNumeros {
  method listaImagenesNumeros() =
   ["num0.png", "num1.png", "num2.png", "num3.png", "num4.png", "num5.png",
    "num6.png", "num7.png", "num8.png", "num9.png"]

}

class Digito {
    var property image = null 
    var property valor = 0
    const position

    method position() = position


    
    method mostrar() {
        image = imagenesNumeros.listaImagenesNumeros().get(valor)
    }

    
    method enCero() = valor == 0

    
    method incrementar() {
        valor += 1
        
        const debeLlevar = valor > 9
        
        if (debeLlevar) {
            valor = 0
        }
        
        self.mostrar() 
        
        return debeLlevar
    }
}

object scored {
    const x = 15
    const y = 14
    
    const centena = new Digito (position = game.at(x-2, y))
    const decena = new Digito(position=game.at(x-1, y))
    const unidad = new Digito(position=game.at(x, y))

    const digitos = [unidad, decena , centena]

    method initialize() {
        digitos.forEach({ unDigito => 
          unDigito.mostrar() 
          game.addVisual(unDigito)
        })
    }

    method aumentarScore(){
        var carry = true
        
        digitos.forEach({ unDigito =>
            if (carry) {
                carry = unDigito.incrementar()
            }
        })
    }
}

