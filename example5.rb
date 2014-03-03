require 'chingu'
include Gosu

class Game < Chingu::Window
  def initialize
    super(600, 200)
    switch_game_state(Backgrounds)
  end
end

class Backgrounds < Chingu::GameState
  def initialize
    super
    @parallax = Chingu::Parallax.create(:x=> 0, :y=> 0, :rotation_center=> :top_left)
    @parallax << {:image => "Parallax-scroll-example-layer-0.png"}
    @parallax.add_layer(:image => "Parallax-scroll-example-layer-1.png")
    @parallax.add_layer(:image => "Parallax-scroll-example-layer-2.png")
    @parallax.add_layer(:image => "Parallax-scroll-example-layer-3.png")
    #self.input = [ :holding_left, :holding_right, :holding_up, :holding_down ]
    Robot.create(:x=> 50, :y =>150)
  end

  def holding_left; @parallax.camera_x -= 2; end;
  def holding_right; @parallax.camera_x += 2; end;
  def holding_up; @parallax.camera_y -=2; end;
  def holding_down; @parallax.camera_y +=2; end;
end

class Robot < Chingu::GameObject
  traits :velocity
  attr_accessor :last_x
  def initialize(options = {})
    super
    self.zorder = 1000
    self.scale = 3
    self.input = [:holding_left, :holding_right]
    @animations = Chingu::Animation.new(:file => "droid_11x15.bmp")
    @animations.frame_names = {:stand => 0..5, :left => 10..11, :right=> 12..13}
    @animation = @animations[:stand]
  end

  def holding_left
    @x -= 5
    @animation = @animations[:left]
  end

  def holding_right
    @x += 5
    @animation = @animations[:right]
  end

  def update
    @image = @animation.next

    if outside_window?; @x = @last_x; end

    @animation = @animations[:stand] unless moved?
    @last_x = @x
  end
end

Game.new.show