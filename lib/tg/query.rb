module Arcade
   module TimeGridIncludes

     def monat *key
       Query.new from: nodes( :out, via: TG::MonthOf, where: { w: key })
     end

     def tag *key
       nodes :out, via: TG::DayOf, where: { w: key }
     end
   end

   class Query
     include TimeGridIncludes
   end
end
