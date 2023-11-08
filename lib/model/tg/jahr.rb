module Tg
  class Jahr <  TimeBase
    # returns a single month record
    def single_month m
      query.nodes( :out, via: TG::MonthOf, where: { w: m } ).execute &.select_result &.first
    end

    # returns an array of  month-records
    # thus enables the use a
    #   Monat[9].tag[9]
    #
    # supports  single values, ranges and arrays
    def monat  *key
      if key.blank?
        out_tg_month_of.in
      else
        key=  key.first		if key.is_a?(Array) && key.size == 1
        #	out_tg_month_of[key].in
        nodes( :out, via: TG::MonthOf , where: { w: key } )
      end
    end
  end
end

