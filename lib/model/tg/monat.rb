module Tg
  class Monat < Tg::TimeBase
	# starts at a given month-entry
	#   tg_monat.in tg_month_of out --> tg_jahr

    def accepted_methods
      super + [ :tag, :abs_value, :jahr ]
    end


  # returns the day node or an array of days out of a range
  # thus enables the use as
  #   Monat[9].tag(9)
  #   Monate[9].tag( 2 .. 12 )
  def tag key=nil
    if key.nil?
      nodes( :out, via: Tg::DayOf ).reverse
    else
      q = query.nodes :out, via: Tg::DayOf, where: { w: key }
      r= q.query.select_result
      if key.is_a? Integer
        r.first
      else
        r.reverse
      end
    end
  end

 # 
  def jahr
    nodes( :in, via: Tg::MonthOf ).first
  end

    # for IRuby

    def html_attributes
      in_and_out_attributes.merge monat: w
    end

    def invariant_attributes
      { monat: w }
    end

	def self.fetch datum   # parameter: a date
#		query_database( "select  expand (out_tg_day_of.in[value = #{datum.day}]) from (select  expand (out_tg_month_of.in[value = #{datum.month}]) from (select from tg_jahr where value = #{datum.year} ) ) ") &.first
		q = Query.new  from: Tg::Jahr, where: { w: datum.year }
		w = Query.new  from: q
		w.nodes :out, via: Tg::MonthOf, where: { w: datum.month }
    w.query.select_result.first

	end

#TG::Monat.fetch Date.new(2000,4,5)
#21.06.(06:29:11) INFO->select  expand (  outE('tg_month_of').in[ value = 4 ]  ) from  ( select from tg_jahr where value = 2000  )
# => #<TG::Monat:0x00000000032fbe28 @metadata={:type=>"d", :class=>"tg_monat", :version=>34, :fieldTypes=>"out_tg_day_of=g,in_tg_month_of=g,in_tg_grid_of=g,out_tg_grid_of=g", :cluster=>132, :record=>225, :edges=>{:in=>["tg_month_of", "tg_grid_of"], :out=>["tg_day_of", "tg_grid_of"]}}, @d=nil, @attributes={:out_tg_day_of=>["#158:6859", "#159:6859", "#160:6859", "#153:6860", "#154:6860", "#155:6860", "#156:6860", "#157:6860", "#158:6860", "#159:6860", "#160:6860", "#153:6861", "#154:6861", "#155:6861", "#156:6861", "#157:6861", "#158:6861", "#159:6861", "#160:6861", "#153:6862", "#154:6862", "#155:6862", "#156:6862", "#157:6862", "#158:6862", "#159:6862", "#160:6862", "#153:6863", "#154:6863", "#155:6863"], :in_tg_month_of=>["#164:225"], :value=>4, :in_tg_grid_of=>["#173:7103"], :out_tg_grid_of=>["#172:7107"]}>
  end
end
