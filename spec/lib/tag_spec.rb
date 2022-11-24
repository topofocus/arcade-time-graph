require 'spec_helper'
require 'database_helper'

describe Tg::Tag do
  before( :all ) do
  #  clear_arcade
    DB = Arcade::Init.connect :test
 #   Tg::TimeGraph.populate( 2018 .. 2024 )  if Tg::Tag.count < 1000
  end

  context "datum" do
      Given( :date ) {  Date.today }
      Given( :date_link ) { date.to_tg  }
      Then { date_link.is_a? Tg::Tag }
      Then { date_link.monat.value == date.month }
      Then { date_link.monat.jahr.value == date.year }
      Then { date_link.datum == date }
  end

  context "discover structure" do


    it "The actual Month has several days" do
      expect( Tg::Monat.first.tag.count ).to be >= 28
    end

    it	"Address a specific day" do
       month= 6
       expect( Tg::Monat[month].tag(5).value ).to eq [5,5,5,5,5,5]
    end

  #  it  "Adress a range of days" do
  #    month= 6..9
  #    expect( Tg::Monat[month].tag(5).datum.sort).to eq [Date.new(2019,9,5),Date.new(2020,9,5), Date.new(2021,9,5)]
  #  end

#
#    it "Address a specific hour" do
#      expect( Monat[month].tag[5].value ).to eq 5
#      expect( Monat[month].tag[7].stunde[5].value ).to eq 5
#    end
#    it "Switch to the next hour" do
#
#      expect( Monat[month].tag[7].stunde[5].next.value ).to eq 6
#    end
#  end

  end


end
