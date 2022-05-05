import wollok.game.*
    
const velocidad = 100

object juego{

	method configurar(){
		game.width(17)
		game.height(11)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(fruta)
		game.addVisual(iconoSalud)
		game.addVisual(marcadorSalud)
	    game.boardGround("fondo Juego.jpg")
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
		
	} 
	
	method  iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		fruta.iniciar()
		iconoSalud.iniciar()
		musica.iniciar()
		}
		
	
	
 method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
		fruta.detener()
		musica.detener()
		
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object cactus {
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "Cactus 1.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad*0.8,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		if (dino.verSalud()> 10){
		 dino.lastimar()
		 game.say(dino,"Aauch!")}
		else{
		juego.terminar()
		game.say(iconoSalud,"Perdiste")}
		
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo1.png"
}


object dino {
	var vivo = true
	var salud = 100
	var position = game.at(1,suelo.position().y())
	
	method image() = "dino 1.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*2.2,{self.bajar()})
		}
	}
	
	method aumentarSalud(){
		salud +=10 }
    
    method lastimar(){
    	salud -=10
    }
		
	method subir(){
		position = position.up(2)
	}
	
	method bajar(){
		position = position.down(2)
	}
	method morir(){
		vivo = false
	}
	method iniciar() {
		vivo = true
		salud=100
	}
	method estaVivo() {
		return vivo
	}
	method verSalud(){
		return salud
	}
	method tieneSalud(){
	return salud > 10
	}
}
object fruta{
	const posicionInicial = game.at(game.width()-1,3)
	var position = posicionInicial

	method image() = "fruta.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad*1.4,"moverFruta",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		dino.aumentarSalud()
		game.say(iconoSalud,"+ 10 salud")
	}
    method detener(){
		game.removeTickEvent("moverFruta")
	}
}
object marcadorSalud{
	
	method text()= dino.verSalud().toString()
	method position()= game.at(16,9)
	
	
	}
	

object iconoSalud{
	method image()="salud.png"
	method position()= game.at(16,10)
	method iniciar(){
		
	}
}

object musica{
	const fondo = game.sound("Musica fondo.mp3")
	
	method iniciar(){
		fondo.shouldLoop(true)
	game.schedule(500, { fondo.play()} )
}
     method detener(){
 	  fondo.stop()
 }
}
/*object danio{ 
	const golpe= game.sound("Daño.mp3")
	
	method golpe(){
		return golpe
	}
}*/
