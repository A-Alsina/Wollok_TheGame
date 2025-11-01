import wollok.game.*

object sonidoMusicaFondo {
    
    const audio = game.sound("musicaFondo.ogg")

    method playLoop() { 
        audio.shouldLoop(true) 
        audio.play()           
    }

    
    method stop() { 
        audio.stop() 
    }
}


object sonidoGameOver{
    method play() {game.sound("gameOverSFX.wav").play()}
}

object sonidoComerManzana{
    method play() {game.sound("comerManzanaSFX.wav").play()}
} 

object sonidoBomba{
    method play() {game.sound("bombaSFX.wav").play()}
}