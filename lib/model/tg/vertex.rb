module Tg
  class Vertex  < Arcade::Vertex


    def to_tg
      nodes( :in, via: Tg::Has )
    end
  end
end
