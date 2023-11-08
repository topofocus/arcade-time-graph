  module Tg
    module Setup
      def self.init_database
        tg_edges =  [ Tg::DateOf, Tg::TimeOf, Tg::DayOf, Tg::MonthOf, Tg::GridOf, Tg::Has ]
        tg_vertices =  [ Tg::TimeBase, Tg::Stunde, Tg::Tag, Tg::Monat, Tg::Jahr  ]
        tg_edges.each &:create_type
        tg_vertices.each &:create_type
      rescue HTTPX::HTTPError
        Arcade::Database.logger.info "database types already present"
      end
    end
  end
