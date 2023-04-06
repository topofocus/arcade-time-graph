## We are defining to_tg methods for Strings, Date and DateTiem objects.
## Strings are converted to the time format.
#
class Date
  def to_tg
#		query "select  expand (out_tg_day_of.in[value = #{day}]) from (select  expand (out_tg_month_of.in[value = #{month}]) from (select from tg_jahr where value = #{year} ) ) "
#
    # this is realized in fetch, eg:  query.nodes :in, via :tg_day_of
    Tg::Tag.fetch( self)
  end
end

class DateTime
  def to_tg
#   timegraph is not implemented
#    if Tg.time_graph?
#      Tg::Monat[month].tag(day).stunde(hour).pop.pop
#    else
      Tg::Tag.fetch( self)
#    end
  end
end

class String
  def to_tg
    date =  DateTime.parse(self)
    date.to_tg
  end
end

