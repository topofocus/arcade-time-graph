module Tg
  class  Tag  < Tg::TimeBase

    ## not implemented (jet)
#    def die_stunde h
#      h.to_i >0 && h.to_i<31 ? out_tg_time_of[h].in : nil
#    end
#
    # 
   # def stunde *key
   #   if key.empty?
   #     out_tg_time_of.in
   #   else
   #     key=  key.first		if key.is_a?(Array) && key.size == 1
   #     nodes( :out, via: Tg::TimeOf, where: { value: key } ).execute
   #   end
   # end
    def accepted_methods
      super + [ :monat, :datum ]
    end

   # returns a Tg::Monat record
    def monat
      query.nodes( :in, via: Tg::DayOf ).query.select_result.first
    end

    def datum
      # three queries are fired
      # todo
      # formulate a match query providing anything in just one query
      m = monat
      Date.new m.jahr.w, m.w, w #   "#{ value}.#{m.value}.#{m.jahr.value}"
    end

=begin
 Fetches the vertex corresponding to the given date

 (optional:  executes the provided block on the vertex )

 Example:

  start_date=  Date.new(2018,4,25)
  TG::Tag.fetch( start_date).datum.to_s
  => "25.4.2018"
=end
    def self.fetch datum , &b  # parameter: a date
      #		query_database( "select  expand (out_tg_day_of.in[value = #{datum.day}]) from (select  expand (out_tg_month_of.in[value = #{datum.month}]) from (select from tg_jahr where value = #{datum.year} ) ) ") &.first
      q = Arcade::Query.new  from: Tg::Jahr, where: { w: datum.year }
      w = Arcade::Query.new  from: q
      w.nodes :out, via: Tg::MonthOf, where: { w: datum.month }, expand: true
      x = Arcade::Query.new  from: w
      x.nodes :out, via: Tg::DayOf, where: { w: datum.day }
      puts x.to_s
      x.query.select_result.first
    end
  end
end
