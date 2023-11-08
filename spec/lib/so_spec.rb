require 'spec_helper'
require 'database_helper'

describe So::Book do
  before( :all ) do
    Arcade::Init.connect :test
    db = Arcade::Init.db
    db.begin_transaction
    Arcade::Database.logger.level = Logger::ERROR
    So::Book.create_type
    So::HasBeenRated.create_type
    So::Book.delete all: true
    So::Book.insert title: "CSS Flex", author: "Max", price: 34

  end
  after( :all )  do
    db =  Arcade::Init.db
    db.commit
  end

  context "Inserted  book" do
     Given( :book) { So::Book.find( title: "CSS Flex") }
     Then { book.is_a?  So::Book }
     Then { book.nodes == [] }
    
      context  "assign to time-grid" do
        before(:all){ Date.today.to_tg.assign vertex: So::Book.first, via: So::HasBeenRated,  action: 1 , by: 'Harald' }
      Given( :connected_book ){ book.refresh }
      Then { connected_book.nodes != [] }
      Then { connected_book.nodes( :in, via: So::HasBeenRated  ).first == Date.today.to_tg }
      Then { connected_book.nodes( :inE, via: So::HasBeenRated , where: { action: 1 } ).first == Date.today.to_tg }
      Then { connected_book.nodes( :inE, via: So::HasBeenRated , where: { action: 0 } ).first == nil }

    # edge =  
       #
   #  expect( book.nodes( :inE, where: { by: 'Hubert' }  )).to be_nil
    end
  end
end
