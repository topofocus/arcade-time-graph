module TimeGridExtensions

  # enable
  # Tg::Jahr[2023].monat(5..8).tag(5)
  #
  #  only for development, fires multible queries
  def monat key=nil
    map{ |y| y.monat(key) }.flatten
  end
  def tag key=nil
    map{ |y| y.tag(key) }.flatten
  end
end

class Array
  include TimeGridExtensions
end
