require 'chingu'
include Gosu

class Game < Chingu::Window
  def initialize
    super(600, 150)
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
    self.input = [ :holding_left, :holding_right, :holding_up, :holding_down ]
  end

  def holding_left; @parallax.camera_x -= 2; end;
  def holding_right; @parallax.camera_x += 2; end;
  def holding_up; @parallax.camera_y -=2; end;
  def holding_down; @parallax.camera_y +=2; end;
end

Game.new.show