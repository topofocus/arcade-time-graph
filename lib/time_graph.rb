#require 'time'

module Tg

class TimeGraph
	class << self   # singleton class
		## we populate the graph with a 1:n-Layer
		# (year -->) n[month] --> n[day] ( --> n[hour] ])
		# thus creating edges is providing a static :from-vertex to numerous :to-vertices
		# the to:vertices are first created and fenced in an array. Then all edges are created at once.
		# In Rest-Mode this is much quicker.
		def populate years = (1900 .. 2050), delete: true

			count_gridspace = -> do
				[Tg::Jahr,Tg::Monat,Tg::Tag,Tg::Stunde].map{|x|  "#{x.to_s} -> #{x.count}" }
			end

			if delete
				puts count_gridspace[].join('; ')
				puts "deleting content"
				[Tg::Jahr,Tg::Monat,Tg::Tag,Tg::Stunde].each{|x| x.delete all: true}
				puts "checking .."
				puts count_gridspace[].join('; ')
			end

			kind_of_grid = if years.is_a? Range
											 'daily'
										 else
											 years = years.is_a?(Fixnum) ? [years]: years
											 'hourly'
										 end

			### switch logger level
      previous_logger_level = Arcade::Database.logger.level
#			Arcade::Database.logger.level = 2
			### NOW WHERE THE DATABASE IS CLEAN, POPULATE IT WITH A DAILY GRID
			print "Grid: "
			year_grid, month_grid, day_grid, hour_grid  =  nil
			years.each do | the_year |
				year_vertex = Tg::Jahr.create value: the_year
					puts "YEAR_GRID: #{year_grid.inspect}"
				Tg::GridOf.create( from: year_grid , to: year_vertex ) if year_grid.present?
				year_grid =  year_vertex
				month_vertices = ( 1 .. 12 ).map do | the_month |
					month_vertex= Tg::Monat.create value: the_month
					Tg::GridOf.create( from: month_grid , to: month_vertex ) if month_grid.present?
					month_grid =  month_vertex
					last_month_day =  (Date.new( the_year, the_month+1, 1)-1).day rescue 31  # rescue covers month > 12
					day_vertices = ( 1 .. last_month_day ).map do | the_day |
						day_vertex = Tg::Tag.create value: the_day
						Tg::GridOf.create( from: day_grid , to: day_vertex ) if day_grid.present?
						day_grid =  day_vertex
						if kind_of_grid == 'hourly'
							hour_vertices = (0 .. 23).map do |h|
								hour_vertex =  Stunde.create( value: h)

								Tg::GridOf.create( from: hour_grid , to: hour_vertex ) if hour_grid.present?
								hour_grid =  hour_vertex
								hour_vertex # return_value
							end
							Tg::TimeOf.create from: day_vertex, to: hour_vertices
						end
						day_vertex # return_value
					end
					Tg::DayOf.create from: month_vertex, to: day_vertices
					month_vertex # return_value
				end
				print "#{the_year} "
				Tg::MonthOf.create from: year_vertex, to: month_vertices
			end
			print "\n"
			Arcade::Database.logger.level =  previous_logger_level
		end
	end
end # class
end # Module
## here we start if the file is called from the command-lind
if $0 == __FILE__
	require './config/boot'
	#Tg::Setup.init_database   # --> config/init_db
	Tg::TimeGraph.populate


	print "\n" * 4
	puts '-' * 40
	puts "Features of the DateTime Graph"
	puts '-' * 40
	puts
	puts "Allocated Month   => Monat.first.value:\t\t" + Monat.first.value.to_s
	puts
	puts "Adressing Days    => Monat.first.tag[2].value:\t" + Monat.first.tag[2].value.to_s
	puts
	puts "Display Date      => Monat.first.tag[13].datum:\t"+ Monat.first.tag[13].datum.to_s

	puts "Display next Date => Monat.first.tag[13].next.datum:\t"+ Monat.first.tag[13].next.datum.to_s




end
