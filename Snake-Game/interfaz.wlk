import wollok.game.*
import juego.*
import sonidos.*
import score.* 


object interfazJuegoReal{

    method pararJuego(){
    game.schedule(500, {sonidoGameOver.play()})
    

    game.removeTickEvent("movimiento")
    game.schedule(1000, {sonidoMusicaFondo.stop()})
    game. addVisual(reinicio)
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
    }

    method reset(){
        game.clear()
    }
}

