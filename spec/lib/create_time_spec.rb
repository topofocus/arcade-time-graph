require 'spec_helper'
require 'database_helper'

describe Tg::TimeGraph do
  before( :all ) do
    connect
  end

  context "build daily grid" do
    # test daily vertices in isolation
    before(:all) do
      [TG::Tag, TG::Monat, TG::Jahr].each{|y| y.delete all: true }
      month_vertex= Tg::Monat.insert w: 1
      TG::TimeGraph.create_daily_vertexes( Date.today.year, month_vertex, nil )
    end
    after(:all){ [TG::Tag, TG::Monat, TG::Jahr].each{|y| y.delete all: true } }

    Given( :monthly_node ){ TG::Monat.find w: 1 }                  # find
    Then { monthly_node.out.size == 31 }                           # 31 out nodes
    Given( :first_daily_node ){ monthly_node.tag 1  }              # select one day
    Then { first_daily_node.is_a? TG::Tag }
    Then { first_daily_node.monat == monthly_node }
    Then { first_daily_node.move(30).w == 31 }
    Given( :daily_node_range ){ monthly_node.tag( 1 .. 10 ) }      # select a day range
    Then { daily_node_range.size == 10 }
    Then { daily_node_range.map(&:w) == [1,2,3,4,5,6,7,8,9,10] }

  end

  context "build monthly grid"  do
    before(:all) do
      [TG::Tag, TG::Monat, TG::Jahr].each{|y| y.delete all: true }
      year_vertex= Tg::Jahr.insert w: Date.today.year
      TG::TimeGraph.create_monthly_vertexes( year_vertex, nil, nil )
    end
    after(:all){ [TG::Tag, TG::Monat, TG::Jahr].each{|y| y.delete all: true } }
    Given( :yearly_node ){ TG::Jahr.find w: Date.today.year }      # find
      Then { yearly_node.out.size == 12 }                           # 12 out nodes

  end


  context "populate grid" do
    before(:all) do
      endyear =  Date.today.year
      Tg::TimeGraph.populate  endyear-3 .. endyear+2
    end

    Given( :today ){ Date.today.to_tg }
    Then { today.is_a? TG::Tag }
    Then { today.datum == Date.today }

    context "check environment" do
      it "nessecary classes are allocated" do
        [ Tg::Monat, Tg::Tag, Tg::Jahr ].each do | klass |
          expect( klass.superclass).to eq Tg::TimeBase
        end
      end
      it "proper nodes are established" do
        expect( Tg::Tag.count ).to  be > 2190  # wg  Schaltjahren
        expect( Tg::Monat.count ).to  eq 72
        expect( Tg::Jahr.count).to eq 6
      end
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
