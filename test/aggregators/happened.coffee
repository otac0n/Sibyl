should = (require 'chai').should()
happened = require '../../aggregators/happened'

describe 'happened', ->
    describe '#aggregate()', ->
        it 'should give the correct start time for the lines', ->
            lines = [{name: 'OK', type: 'happened', time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = happened.aggregate lines
            result.starttime.should.equal 10000

        it 'should give the correct end time for the lines', ->
            lines = [{name: 'OK', type: 'happened', time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = happened.aggregate lines
            result.endtime.should.equal 20000

        it 'should give the correct time for a single line', ->
            lines = [{name: 'OK', type: 'happened', time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = happened.aggregate lines
            result.times[0].should.equal 15000

        it 'should give the correct time for multiple lines', ->
            lines = [{name: 'OK', type: 'happened', time: 11000},
                     {name: 'OK', type: 'happened', time: 13000},
                     {name: 'OK', type: 'happened', time: 15000},
                     {name: 'OK', type: 'happened', time: 17000},
                     {name: 'OK', type: 'happened', time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = happened.aggregate lines
            result.times.should.deep.equal [11000, 13000, 15000, 17000, 19000]

        it 'should return no times', ->
            lines = []
            lines.starttime = 10000
            lines.endtime = 20000
            result = happened.aggregate lines
            result.times.should.deep.equal []

    describe '#combine()', ->
        it 'should return all times in the given ranges', ->
            chunks = [{starttime: 10000, endtime: 20000, times: [10100, 11400, 15400, 19000]},
                      {starttime: 20000, endtime: 30000, times: [20200, 21000]}]
            result = happened.combine chunks, 10000, 30000
            result.times.should.deep.equal [10100, 11400, 15400, 19000, 20200, 21000]

        it 'should not return times outside of the given range', ->
            chunks = [{starttime: 10000, endtime: 20000, times: [10100, 11400, 15400, 19000]},
                      {starttime: 20000, endtime: 30000, times: [20200, 21000]}]
            result = happened.combine chunks, 18000, 21000
            result.times.should.deep.equal [19000, 20200]