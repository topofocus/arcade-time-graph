module Tg
  class Jahr <  TimeBase

    # returns a month-node
    #  or an array of months of a given year
    #
    # supports  single values and ranges
    def monat  key=nil
      if key.nil?
        query.nodes( :out, via: Tg::MonthOf )
      else
        q = query.nodes :out, via: Tg::MonthOf, where: { w: key }
      end
      q = yield q if block_given?
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

    def self.db_init
      File.read(__FILE__).gsub(/.*__END__/m, '')
    end

  end
end
 ## The code below is executed on the database after the database-type is created
 ## Use the output of `ModelClass.database_name` as DB type  name
 ##
__END__
 CREATE INDEX  ON tg_jahr ( w ) UNIQUE

