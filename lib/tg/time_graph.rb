#require 'time'

module Tg

class TimeGraph
	class << self   # singleton class
		## we populate the graph with a 1:n-Layer
		# (year -->) n[month] --> n[day] ( --> n[hour] ])
		# thus creating edges is providing a static :from-vertex to numerous :to-vertices
		# the to:vertices are first created and fenced in an array. Then all edges are created at once.
		# In Rest-Mode this is much quicker.
    def populate years, delete: true

      years =  2020 .. 2050 if years.blank?
      count_gridspace = -> do
        [Tg::Jahr,Tg::Monat,Tg::Tag].map{|x|  "#{x.to_s} -> #{x.count}" }
      end

      if delete
        puts count_gridspace[].join('; ')
        puts "deleting content"
        db = Arcade::Init.db
        [Tg::Jahr,Tg::Monat,Tg::Tag].each{|x|  db.transmit{ "delete from `#{x.database_name}`" }  }
        [ Tg::DateOf, Tg::TimeOf, Tg::DayOf, Tg::MonthOf, Tg::GridOf, Tg::Has ].each{|x|  db.transmit{ "delete from `#{x.database_name}`" }  }
        puts "checking .."
        puts count_gridspace[].join('; ')
      end

      #     kind_of_grid = if years.is_a?( Range ) || years.is_a? ( Array )
      #											 'daily'
      #										 else
      #											 years = years.is_a?(Integer) ? [years]: years
      #											 'hourly'
      #										 end
      #

    #  hourly_vertexes = ->  do 
    #    hour_vertices = (0 .. 23).map do |h|
    #      hour_vertex =  Stunde.create( w: h)

    #      Tg::GridOf.create( from: hour_grid , to: hour_vertex ) if hour_grid.present?
    #      hour_grid =  hour_vertex
    #      hour_vertex # return_value
    #    end
    #    Tg::TimeOf.create from: day_vertex, to: hour_vertices

    #  end



      kind_of_grid = 'daily'
      ### switch logger level
      previous_logger_level = Arcade::Database.logger.level
      Arcade::Database.logger.level =  Logger::ERROR
      ### NOW THE DATABASE IS CLEAN, LET's POPULATE IT WITH A DAILY GRID
      print "Grid: "
      daily_threads = []
      last_year_vertex, last_month_vertex, last_day_vertex, last_hour_vertex  =  nil
      years.each do | the_year |
        year_vertex = Tg::Jahr.insert w: the_year
        last_year_vertex.assign via: TG::GridOf,  vertex: year_vertex  unless last_year_vertex.nil?
        last_year_vertex =  year_vertex
        last_month_vertex, last_day_vertex = create_monthly_vertexes year_vertex, last_month_vertex, last_day_vertex
        print "#{the_year} "
      end
      print "\n"
      Arcade::Database.logger.level =  previous_logger_level
    end
    def create_monthly_vertexes  year_vertex, last_month_vertex, last_day_vertex
      month_vertices = ( 1 .. 12 ).map do | the_month |
        month_vertex= Tg::Monat.insert w: the_month
        last_month_vertex.assign via: Tg::GridOf, vertex: month_vertex  unless last_month_vertex.nil?
        #          daily_threads << Thread.new do
        last_day_vertex = create_daily_vertexes year_vertex.w, month_vertex, last_day_vertex
        last_month_vertex =  month_vertex
      end
      Tg::MonthOf.create from: year_vertex, to: month_vertices

      [ last_month_vertex, last_day_vertex ] # return_value
    end

    def create_daily_vertexes year, month_vertex, last_day_vertex
      the_month = month_vertex.w
      ldv =  last_day_vertex
      last_month_day =  (Date.new( year, the_month+1, 1)-1).day rescue 31  # rescue covers month > 12
      day_vertices = ( 1 .. last_month_day ).map do | the_day |
        day_vertex = Tg::Tag.insert w: the_day
        ldv.assign via: Tg::GridOf, vertex: day_vertex  unless ldv.nil?
        ldv =  day_vertex
        #              if kind_of_grid == 'hourly'  #  not implemented
        #                hourly_vertexes[]
        #              end
        day_vertex # return_value
      end
      Tg::DayOf.create from: month_vertex, to: day_vertices
      ldv  #  return value

    end

    #   select
    #
    #   t=TG::TimeGraph.select( months: 5..9, days: 3..19 ){ |y| y.nodes :out, via: HasOrder  }
    #   Q: select out('has_order') from
    #             ( select  expand ( out('tg_day_of')[ w between 3 and 19 ] ) from
    #             ( select  expand ( out('tg_month_of')[ w between 5 and 9 ] ) from
    #             ( select from tg_jahr where w=2023 )
    #             )
    #             )
    #   gets connected HasOrder-Nodes for the specified days of the selected month of the current year
    #
    #   returns an Arcade::Query unless "execute: true" ist specified or a block is provided
    #
    def select years: Date.today.year, months: Date.today.month, days: 0 , execute: false

      q1 = TG::Jahr.at years
      q2 = Arcade::Query.new from: q1
      q2.nodes :out, via: TG::MonthOf, expand: true, where: { w: months }

      the_q = unless days.is_a?(Integer) && days.zero?
        q3 = Arcade::Query.new from: q2
        q3.nodes :out, via: TG::DayOf, expand: true, where: { w: days  }
        q3
      else
        q2
      end

      if block_given?
        q4 = Query.new from: the_q
        yield( q4 ).execute.select_result
      elsif  execute
        the_q.execute.select_result
      else
        the_q
      end
    end

    # generates a match statement that exhibits the correponding timegrid nodes.
    #
    # the day-vertices are exposed through day
    # and
    # the month-verttices through month.
    #
    # grid returns a Match-Object thus further nodes can be addressed
    #
    # i.e.  TG::TimeGraph.grid( 2020, 7..9, 5 ).out( HasOhlc ).node( as: :contract ).execute.select_result(:contract)
    #       returns all contracts connected to the timegrid on the 5th July, August and September 2020 
    def grid years = Date.today.year, months =  Date.today.month, days = 0 , execute: false

      # select monthly time-grid-node
      z= Arcade::Match.new( type: TG::Jahr, where: { w: years  } )
                      .out( TG::MonthOf ).node( where: { w: months }, as: :month )

      # select daily time-grid-node if days is specified
      if days in (1 .. 31)
        z= z.out( TG::DateOf  ).node( where: { w: days }, as: :day )
        result =  :day
      else
        result =  :month
      end
      execute ? z.execute.select_result( result ) : z
    end



  end ## << self
end # class
end # Module
