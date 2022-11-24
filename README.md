# Time Graph 

Simple Time Graph using ArcadeDB. 

This Graph is realized

```ruby
Jahr -- [MonthOf] -- Monat --[DayOf]-- Tag --[TimeOf]-- Stunde
```
The nodes are cross-linked and any point of the grid is easily accessed.  
The library provides »to_tg« additions to »Date«, »DateTime« and »String«. 

Thus

```ruby
z = "22.3.2003".to_tg
-> select  out('tg_day_of')[ value = 22 ]  from  ( select  expand (  out('tg_month_of')[ value = 3 ]  ) from  ( select from tg_jahr where value = 2003  )   )
 => #<Tg::Tag rid="#145:147" values={:value=>22} in=2 out=1>
z.datum          => Sat, 22 Mar 2003  (returns a Date)
z.next.datum     => Sun, 23 Mar 2003
z.prev.datum     => Fri, 21 Mar 2003
z.move( -20 ).datum => Sun, 02 Mar 2003 
z.environment( 5).datum
 => ["18.5.2003", "19.5.2003", "20.5.2003", "21.5.2003", "22.5.2003", "23.5.2003", "24.5.2003", "25.5.2003", "26.5.2003", "27.5.2003", "28.5.2003"] 


```
(datum is a method of Tg::Tag)

*Prerequisites* : 
* Ruby 3.1  and a running ArcadeDB-Server
* Run "bundle install" and "bundle update"
* customize config/connect.yml

* Initialize the data-structure by `Tg::Setup.init_database`
* Populate the timegraph by `Tg::TimeGraph.populate 2015..2030`
* Verify the setup by `Date.today.to_tg`

To play around, start the console by
```
cd bin
  ./console t  # test-modus
```

The following database classes are included
```ruby
DB.hierarchy type: :edge 
DB.hierarchy type: :vertex 

- Arcade::Edge				# ruby-class
- - tg_date_of       Tg::MonthOf
- - - tg_day_of      Tg::DayOf
- - - tg_month_of    Tg::TimeOf
- - grid_of		       Tg::GridOf
- - has    		       Tg::Has
- Arcade::Vertex 
- - tg_time_base    Tg::TimeBase
- - - tg_jahr       Tg::Jahr
- - - tg_monat      Tg::Monat
- - - tg_tag        Tg::Tag
- - - stunde	      Tg::Stunde
```

The graph is populated by calling 

```ruby
TG::TimeGraph.populate( a single year or a range )  # default: 1900 .. 2050
```


The Model-directory contains, customized methods to simplify the usage of the graph.

Some Examples:
Assuming, you build a standard day-based grid

```ruby

include TG					# we can omit the TG prefix

Jahr[2000]    # --> returns a single object
=> #<Tg::Jahr rid="#193:0" values={:value=>2000} in=0 out=13> 


Jahr[2000 .. 2005].value  # returns an array
 => [2003, 2000, 2004, 2001, 2005, 2002] 


## Horizontal Connections

Besides the hierarchically TimeGraph »Jahr <-->Monat <--> Tag <--> Stunde«  the Vertices are connected
horizontally via »grid_to«-Edges. This enables an easy access to the neighbours.

On the Tg::TimeBase-Level a method »environment« is implemented, that gathers the adjacent vertices 
via traverse.

``` ruby
start =  "7.4.2000".to_tg
start.environment(3).datum
 => ["4.4.2000", "5.4.2000", "6.4.2000", "7.4.2000", "8.4.2000", "9.4.2000", "10.4.2000"] 

2.3.1 :003 > start.environment(3,4).datum
 => ["4.4.2000", "5.4.2000", "6.4.2000", "7.4.2000", "8.4.2000", "9.4.2000", "10.4.2000", "11.4.2000"] 
 
start.environment(0,3).datum
 => ["7.4.2000", "8.4.2000", "9.4.2000", "10.4.2000"] 
 
 
```

## Assigning Events

To assign something to the TimeGrid its sufficient to create an edge-class and connect this »something», 
which is represented as Vertex, to the grid. The Diary example below describes how to do it.

However, if a csv-file  with a »date« column is present, it's easier to assign it directly 
to the grid:

``` ruby
  # csv record 
  Ticker,Date/Time,Open,High,Low,Close,Volume,Open Interest,
  ^GSPTSE,09.09.2016,14717.23,14717.23,14502.90,14540.00,202109040,0
```
assuming the record is read as string, then assigning is straightforward:
``` ruby
  ticker, date, open, high, low, close, volume, oi = record.split(',')
  date.to_tg.assign vertex: Ticker.new(  high: high, ..), via: OHLC_TO, attributes:{ symbol: ticker }
``` 
The updated TimeBase-Object is returned. 

»OHLC_TO« is the edge-class and »Ticker« represents a vertex-class
