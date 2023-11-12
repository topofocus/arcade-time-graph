module Tg
  class Jahr <  TimeBase

    # returns a month-node
    #  or an array of months of a given year
    #
    # supports  single values and ranges
    def monat  key=nil
      if key.nil?
      nodes( :out, via: Tg::MonthOf ).reverse
      else
      q = query.nodes :out, via: Tg::MonthOf, where: { w: key }
      r= q.query.select_result
      if key.is_a? Integer
        r.first
      else
        r.reverse
      end
    end

    # for IRuby
    def html_attributes
      in_and_out_attributes.merge jahr: w
    end

    def invariant_attributes
      { jahr: w   }
    end
  end
  end
end

