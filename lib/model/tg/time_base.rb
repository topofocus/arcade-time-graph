module  Tg
  class TimeBase  < Tg::Vertex

      def self.db_init
         File.read(__FILE__).gsub(/.*__END__/m, '')
       end
=begin
Searches for specific value records 

Examples
  Monat[8]  --> Array of all August-month-records
  Jahr[1930 .. 1945]
=end
  def self.[] *key
#    result = OrientSupport::Array.new( work_on: self, 
#						work_with: db.execute{ "select from #{ref_name} #{db.compose_where( value: key.analyse)}" } )
		key=  key.first		if key.is_a?(Array) && key.size == 1 
    q= query.where( value: key).query.allocate_model
#		result= query_database q
#		result.size == 1 ? result.first : result # return object if only one record is fetched
  end
#
  end
#=begin
#Moves horizontally within the grid
#i.e
#  the_day =  "4.8.2000".to_tg
#  the_day.move(9).datum  # => "13.8.2000" 
#  the_day.move(-9).datum # => "26.7.2000"
#=end
#  def move count
#    dir =  count <0 ? 'in' : 'out' 
#    r= db.execute {  "select from ( traverse #{dir}(\"tg_grid_of\") from #{rrid} while $depth <= #{count.abs}) where $depth = #{count.abs} " }  
#    if r.size == 1
#      r.first
#    else
#      nil
#    end
#  end
#
#
#  def analyse_key key    # :nodoc:
#
#    new_key=  if key.first.is_a?(Range) 
#			   key.first
#			elsif key.size ==1
#			 key.first
#			else
#			  key
#			end
#  endpt 
#=begin
#Get the nearest horizontal neighbours
#
#Takes one or two parameters. 
#
#  (TG::TimeBase.instance).environment: count_of_previous_nodes, count_of_future_nodes
#
#Default: return the previous and next 10 items
#
#   "22.4.1967".to_tg.environment.datum
#    => ["12.4.1967", "13.4.1967", "14.4.1967", "15.4.1967", "16.4.1967", "17.4.1967", "18.4.1967", "19.4.1967", "20.4.1967", "21.4.1967", "22.4.1967", "23.4.1967", "24.4.1967", "25.4.1967", "26.4.1967", "27.4.1967", "28.4.1967", "29.4.1967", "30.4.1967", "1.5.1967", "2.5.1967"]
#
#It returns an  OrientSupport::Array of TG::TimeBase-Objects
#
#
#
#=end
#
##  def environment previous_items = 10, next_items = nil
##    next_items =  previous_items  if next_items.nil?  # default : symmetric fetching
##
##    my_query =  -> (count) do
##			dir =  count <0 ? 'in' : 'out'   
##			db.execute {  "select from ( traverse #{dir}(\"tg_grid_of\") from #{rrid} while $depth <= #{count.abs}) where $depth >=1 " }   # don't fetch self and return an Array
##		end
##   prev_result = previous_items.zero? ?  []  :  my_query[ -previous_items.abs ] 
##   next_result = next_items.zero? ?  []  : my_query[ next_items.abs ] 
##   # return a collection suitable for further operations
##   OrientSupport::Array.new work_on: self, work_with: (prev_result.reverse <<  self  | next_result )
##
##  end
##
#
#  def environment previous_items = 10, next_items = nil
#    _environment(previous_items, next_items).execute
#	end
#
#  def _environment previous_items, next_items = nil
#		q = ->(**p){  OrientSupport::OrientQuery.new **p }
#     
#    next_items =  previous_items  if next_items.nil?  # default : symmetric fetching
#		local_var = :a
#		statement = q[]
#		{ in: previous_items , out: next_items}.each do | dir, items|
#				traverse_query = query kind: 'traverse', while: "$depth <= #{items}" 
#				traverse_query.nodes dir, via: TG::GRID_OF, expand: false
#				
#				statement.let  local_var =>  q[ from: traverse_query, where: '$depth >=1' ] 
#				local_var =  local_var.succ
#		end
#    statement.let  '$c= UNIONALL($a,$b) '
#    statement.expand( '$c')  # returns the statement
#	end
#
#end
end
 ## The code below is executed on the database after the database-type is created
 ## Use the output of `ModelClass.database_name` as DB type  name
 ##
__END__
 CREATE PROPERTY pg_time_base.value_string STRING
 CREATE PROPERTY pg_time_base.value INTEGER
 CREATE INDEX  ON pg_time_base ( value ) NOTUNIQUE
