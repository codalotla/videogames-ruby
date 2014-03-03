require 'chingu'
include Gosu

class Game < Chingu::Window
  def initialize
    super
    self.caption = "Hola, este es mi primer juego en Ruby!"
    self.input = {:escape => :exit}
    push_game_state(Inicio)
  end
end

class Player < Chingu::GameObject
  traits :collision_detection, :bounding_circle
  def initialize(options = {})
    super
    @image = Image["spaceship.png"]
  end

  def holding_left; @x -= 3; end  
  def holding_right; @x += 3; end   
  def holding_up; @y -= 3; end  
  def holding_down; @y += 3; end 
  def space
    Bullet.create(:x => @x, :y=> @y)
    Bullet.create(:x => @x - 20, :y=> @y)
    Bullet.create(:x => @x + 20, :y=> @y)
  end 
end 

class Meteor < Chingu::GameObject
  traits :velocity, :collision_detection, :bounding_circle
  def initialize(options={})
    super
    @image = Image["meteorito.png"]
    self.velocity_x = rand(-1..1)
    self.velocity_y = rand(-1..1)
  end

  def update
    if @x < 0 || @x>$window.width; @x %= $window.width; end
    if @y < 0 || @y>$window.height; @y %= $window.height; end
  end
end

class Bullet < Chingu::GameObject
  traits :collision_detection, :bounding_circle
  def initialize(options = {})
    super
    @image = Image["fire_bullet.png"]
  end

  def update
    @y -= 2
    if outside_window?
      self.destroy
    end
  end
end

class Inicio < Chingu::GameState
  def initialize
    super
    Chingu::Text.create(:text => "Aprieta F1 para iniciar el juego", :x=> 200, :y => $window.height/2, :size=>30)
    self.input = {:f1 => Play}
  end
end

class Play < Chingu::GameState
  def initialize
    super
    Chingu::Text.create(:text => "Aprieta P para pausa, R para resetear")
    @player = Player.create(:x => 200, :y => 200)
    @player.input = [ :holding_left, :holding_right, :holding_up, :holding_down, :space ]
    self.input = {:p => Pause, :r => :reset_game}
    4.times { Meteor.create(:x=> rand($window.width), :y=> rand($window.height)) } 
  end

  def reset_game
    Meteor.destroy_all
    Bullet.destroy_all
    @player.x = $window.width/2
    @player.y = $window.height * 0.95
    4.times { Meteor.create(:x=> rand($window.width), :y=> rand($window.height)) }
  end

  def update
    super
    Bullet.each_collision(Meteor) do |bullet, meteor| bullet.destroy; meteor.destroy; end
    Player.each_collision(Meteor) do |player, meteor| push_game_state(Lose) end
  end
end

class Lose < Chingu::GameState
  def initialize
    super
    Chingu::Text.create(:text => "Aprieta c para continuar", :size=> 30, :y => $window.height/2, :x=> 200)
    self.input = {:c => lambda{ pop_game_state }}
  end
end

class Pause < Chingu::GameState
  def initialize
    super
    self.input = {:p => :sinpause}
  end

  def sinpause
    pop_game_state
  end

  def draw
    super
    previous_game_state.draw
  end
end

Game.new.show