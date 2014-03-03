require 'chingu'
include Gosu

class Game < Chingu::Window
  def initialize
    super(600, 600)
    switch_game_state(Backgrounds)
  end
end

class Backgrounds < Chingu::GameState
  def initialize
    super
    self.input = { :e => :edit }
    load_game_objects
    Robot.create(:x=> 50, :y =>150)
  end

  def edit
    push_game_state(Chingu::GameStates::Edit)
  end
end

class Robot < Chingu::GameObject
  traits :velocity, :collision_detection, :bounding_box
  attr_accessor :last_x, :last_y
  def initialize(options = {})
    super
    self.zorder = 1000
    self.scale = 3
    self.input = [:holding_left, :holding_right, :holding_up, :holding_down]
    @animations = Chingu::Animation.new(:file => "droid_11x15.bmp")
    @animations.frame_names = {:stand => 0..5, :up => 6..7, :down => 8..9,:left => 10..11, :right=> 12..13}
    @animation = @animations[:stand]
  end

  def holding_left
    @x -= 3
    @animation = @animations[:left]
  end

  def holding_right
    @x += 3
    @animation = @animations[:right]
  end

  def holding_up
    @y -= 3
    @animation = @animations[:up]
  end

  def holding_down
    @y += 3
    @animation = @animations[:down]
  end

  def update
    @image = @animation.next

    if outside_window?; @x = @last_x; end

    @animation = @animations[:stand] unless moved?

    self.each_collision(StoneWall){|robot, stone| 
      @x = @last_x
      @y = @last_y
    }

    @last_x, @last_y = @x, @y
  end
end

class StoneWall < Chingu::GameObject
  traits :collision_detection, :bounding_box
  def setup
    @image = Image["stone_wall.bmp"]
  end
end

Game.new.show