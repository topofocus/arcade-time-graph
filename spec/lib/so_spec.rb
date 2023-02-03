require 'spec_helper'
require 'database_helper'

describe So::Book do
  before( :all ) do
    DB = Arcade::Init.connect :test
    So::Book.create_type
    So::HasBeenRated.create_type
#    So::HasBeenRated.delete all:true
    So::Book.all{|x| x.edges.each &:delete }
    So::Book.delete all:true

  end

  context "Assign a book" do
    it  "prepare environment" do
      book  =  So::Book.create title: "CSS Flex", author: "Max", price: 34
      expect( book ).to be_a So::Book
      expect( book.edges ).to be_empty
    end
    it  "assign to time-grid" do
      book = So::Book.where( title: "CSS Flex").first
      expect( book ).to be_a So::Book
     book_link = Date.today.to_tg.assign vertex: book, via: So::HasBeenRated, attributes:{ action: +1 , by: 'Harald' }
     expect( book.nodes( :in  ).first).to eq Date.today.to_tg
    end
  end




end
