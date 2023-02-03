module Tg
end
TG =  Tg
TimeGraph = TG
require 'arcade'
require_relative 'tg/init_db'

require_relative 'model/tg/vertex'
require_relative 'model/tg/time_base'
require_relative 'model/tg/tag'
require_relative 'model/tg/monat'
require_relative 'model/tg/jahr'
require_relative 'model/tg/stunde'
require_relative 'model/tg/date_of'
require_relative 'model/tg/time_of'
require_relative 'model/tg/month_of'
require_relative 'model/tg/grid_of'
require_relative 'model/tg/day_of'
require_relative 'model/tg/has'

require_relative 'tg/time_graph'
require_relative 'support'

#loader =  Zeitwerk::Loader.new
##loader.push_dir ("#{__dir__}/model")
#loader.setup
