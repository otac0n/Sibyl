should = (require 'chai').should()
hit = require '../../aggregators/hit'

describe 'hit', ->
    describe '#aggregate()', ->
        it 'should give the correct start time for the lines', ->
            lines = [{name: 'OK', type: 'hit', value: 1, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit.aggregate lines
            result.starttime.should.equal 10000

        it 'should give the correct end time for the lines', ->
            lines = [{name: 'OK', type: 'hit', value: 1, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit.aggregate lines
            result.endtime.should.equal 20000

        it 'should give the correct number of hits with no lines', ->
            lines = []
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit.aggregate lines
            result.count.should.equal 0

        it 'should give the correct number of hits with a single line', ->
            lines = [{name: 'OK', type: 'hit', value: 1, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit.aggregate lines
            result.count.should.equal 1

        it 'should give the correct number of hits with multiple lines', ->
            lines = [{name: 'OK', type: 'hit', value: 1, time: 11000},
                     {name: 'OK', type: 'hit', value: 1, time: 13000},
                     {name: 'OK', type: 'hit', value: 1, time: 15000},
                     {name: 'OK', type: 'hit', value: 1, time: 17000},
                     {name: 'OK', type: 'hit', value: 1, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit.aggregate lines
            result.count.should.equal 5

        it 'should give the correct number of hits for lines with values other than 1', ->
            lines = [{name: 'OK', type: 'hit', value: -9, time: 11000},
                     {name: 'OK', type: 'hit', value: -3, time: 13000},
                     {name: 'OK', type: 'hit', value:  6, time: 15000},
                     {name: 'OK', type: 'hit', value:  2, time: 17000},
                     {name: 'OK', type: 'hit', value: -5, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit.aggregate lines
            result.count.should.equal -9

        it 'should give the correct number of hits for lines with values affected by a rate', ->
            lines = [{name: 'OK', type: 'hit', value: 9.010, time: 11000},
                     {name: 'OK', type: 'hit', value: 3.153, time: 13000},
                     {name: 'OK', type: 'hit', value: 6.300, time: 15000},
                     {name: 'OK', type: 'hit', value: 0.400, time: 17000},
                     {name: 'OK', type: 'hit', value: 5.264, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = hit.aggregate lines
            result.count.should.equal 24.127

    describe '#combine()', ->
        it 'should give correct results when combining entire chunks', ->
            chunks = [{starttime:10000,endtime:20000,count:2},
                      {starttime:20000,endtime:30000,count:3}]
            result = hit.combine chunks, 10000, 30000
            result.should.deep.equal
                starttime: 10000
                endtime: 30000
                count: 5

        it 'should linearly interpolate when combining partial chunks', ->
            chunks = [{starttime:10000,endtime:20000,count:2},
                      {starttime:20000,endtime:30000,count:3}]
            result = hit.combine chunks, 15000, 25000
            result.should.deep.equal
                starttime: 15000
                endtime: 25000
                count: 2.5
