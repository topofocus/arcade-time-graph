module Tg
  class Vertex  < Arcade::Vertex

	# If the time_graph is used any Vertex class inherents the methods defined below.
	#
	# Thus
	#
	#  if the vertices are connected via "...grid.." edges, they can be accessed by
	#  * next
	#  * prev
	#  * move( count  )
	#  * + (count)
	#  * - (count)
	#
  def next
		nodes( :out, via: Tg::GridOf )
  end
  def prev
		nodes( :in, via: Tg::GridOf )
  end

		# simplified and specialized form of traverse
		#
		# we follow the graph (Direction: out)
		#
		#    start = "1.1.2000".to_tg.nodes( via: /temp/ ).first
    #    or
  	#    start = the_asset.at("1.1.2000")
  	#
		#    start.vector(10)                    ==>  returns an Array of Vertices
    #    start.vector(10){ "w" }             ==>  returns an Array of Hashes :
    #                                             [ { w => 10 }, { w: 11 } ... ]
    #    start.vector(10, function: :median){"mean" }  => returns a single value :   12.5
		#
		# with
		#  function: one of 'eval, min, max, sum abs, decimal, avg, count,mode, median, percentil, variance, stddev'
		# and a block, specifying the  property to work with
		#
		def vector  length, where: nil, function: nil,  start_at: 0
		  dir =  length <0 ? :in : :out ;
			the_vector_query = traverse dir, via: Tg::GridOf, depth: length.abs, where: where, execute: false
#			the_vector_query.while "inE('ml_has_ohlc').out != #{to_tg.rid}  " if to_tg.present?  future use
			t=  Arcade::Query.new from: the_vector_query
			t.where "$depth >= #{start_at}"
      puts "T: #{t.to_s}"
			if block_given?
				if function.present?
					t.projection( "#{function}(#{yield})")
          t.query.select_result.first           # only one value is returned
        else
					t.projection yield
          t.query.select_result                 # returns an array
				end
      else
        t.query.allocate_model                  # returns a list of vertices
			end
		end





=begin
Moves horizontally within the grid
i.e
  the_day =  "4.8.2000".to_tg
  the_day.move(9).datum  # => "13.8.2000"
  the_day.move(-9).datum # => "26.7.2000"
=end
    def move count
      dir =  count <0 ? :in : :out
      edge_class = detect_edges( dir, Tg::GridOf, expand: false )
      q1 =  Arcade::Query.new( kind: :traverse )
        .while( " $depth <= #{count.abs}")
        .from( self )
        .nodes( dir, via: edge_class, expand: false)

      q2= Arcade::Query.new from: q1, where: "$depth = #{count.abs} "
      r =  q2.query.allocate_model
  #    if r.size == 1
  #      r.first
 #     else  # if multible vertices are found, the last one is the date-record, which we want to returna
            # if the behaviour changes, its also possible to explicit return the Tg::Tag -record
        r.last
#      end
    end
=begin
Get the node (item) grids in the future

i.e.
  the_month =  TG::Jahr[2000].monat(8).pop
  the_month.value  # -> 8
  future_month = the_month + 6
  future_month.value # -> 2
=end
    def move_ item
      move item
    end
    alias :+ :move_
=begin
Get the node (item) grids in the past

i.e.
  the_day =  "4.8.2000".to_tg
  past_day = the_day - 6
  past_day.datum #  => "29.7.2000"
=end
    def move__ item
      move -item
    end

    alias :- :move__

    # it is assumed, that any connection to the time-graph is done with an
    # edge-class containing "has", ie: has_temperature, has_ohlc, has_an_appointment_with
    def datum
      nodes( :in, via: Tg::Has ) &.datum
    end


    def to_tg
      nodes( :in, via: Tg::Has )
    end
  end
end
