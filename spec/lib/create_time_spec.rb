require 'spec_helper'
require 'database_helper'

describe Tg::TimeGraph do
  before( :all ) do
    clear_arcade
    DB = Arcade::Init.connect :test
    Tg::Setup.init_database
    endyear =  Date.today.year
    Tg::TimeGraph.populate  endyear-3 .. endyear+2
  end
  context "check environment" do
    it "nessesary classes are allocated" do
      [ Tg::Monat, Tg::Tag, Tg::Jahr ].each do | klass |
        expect( klass.superclass).to eq Tg::TimeBase
      end
    end
    it "proper nodes are established" do
      expect( Tg::Tag.count ).to  be > 2190  # wg  Schaltjahren
      expect( Tg::Monat.count ).to  eq 72
      expect( Tg::Jahr.count).to eq 6
    end

    it "today is represented in the graph" do
      today =  Date.today.to_tg
      expect( today ).to be_a Tg::Tag 
    end
  end
#  context "populate" do
#    let( :month){  Date.today.month }
#
#    it "The actual Month is used" do
#      expect( Monat.count ).to eq 1
#      expect( Monat.first.value ).to eq  Date.today.month
#    end
#


#    it "The actual Month has several days" do
#      expect( Monat.first.tag.count ).to be >= 28
#    end
#
#    it	"Address a specific day", focus: true do
#
#      expect( Monat[month].tag[5].value ).to eq 5
#    end
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
