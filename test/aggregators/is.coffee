should = (require 'chai').should()
aggregators =
    is: require '../../aggregators/is'

describe 'is', ->
    describe '#aggregate()', ->
        it 'should give the correct start time for the lines', ->
            lines = [{name: 'OK', type: 'is', value : 50, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.starttime.should.equal 10000

        it 'should give the correct end time for the lines', ->
            lines = [{name: 'OK', type: 'is', value : 50, time: 15000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.endtime.should.equal 20000

        it 'should give the correct count of lines', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.count.should.equal 5

        it 'should give the correct time', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.time.should.equal 9000

        it 'should give the correct mean', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.mean.should.equal 45.55555555555556

        it 'should give the correct mean when there are negative values', ->
            lines = [{name: 'OK', type: 'is', value:  10, time: 11000},
                     {name: 'OK', type: 'is', value: -30, time: 13000},
                     {name: 'OK', type: 'is', value: -50, time: 15000},
                     {name: 'OK', type: 'is', value:  70, time: 17000},
                     {name: 'OK', type: 'is', value:  90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.mean.should.equal 10

        it 'should give the correct time when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 80
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.time.should.equal 10000

        it 'should give the correct mean when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 80
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.mean.should.equal 49

        it 'should give the correct minimum value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.min.should.equal 10

        it 'should give the correct minimum value when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 5
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.min.should.equal 5

        it 'should give the correct minimum value when there are negative values', ->
            lines = [{name: 'OK', type: 'is', value: -10, time: 11000},
                     {name: 'OK', type: 'is', value:  30, time: 13000},
                     {name: 'OK', type: 'is', value:  50, time: 15000},
                     {name: 'OK', type: 'is', value: -70, time: 17000},
                     {name: 'OK', type: 'is', value:  90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.min.should.equal -70

        it 'should give the correct maximum value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.max.should.equal 90

        it 'should give the correct maximum value when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 95
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.max.should.equal 95

        it 'should give the correct maximum value when all the values are negative', ->
            lines = [{name: 'OK', type: 'is', value: -10, time: 11000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.max.should.equal -10

        it 'should give the correct first time when there is no starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.firsttime.should.equal 11000

        it 'should give the correct first time when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 80
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.firsttime.should.equal 10000

        it 'should give the correct first value when there is no starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.firstvalue.should.equal 10

        it 'should give the correct first value when there is a starting value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            lines.startvalue = 80
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.firstvalue.should.equal 80

        it 'should give the correct last value', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = aggregators.is.aggregate lines, 'is:OK', {}
            result.lastvalue.should.equal 90

        it 'should carry the last value over to the next bucket', ->
            lines = [{name: 'OK', type: 'is', value: 10, time: 11000},
                     {name: 'OK', type: 'is', value: 30, time: 13000},
                     {name: 'OK', type: 'is', value: 50, time: 15000},
                     {name: 'OK', type: 'is', value: 70, time: 17000},
                     {name: 'OK', type: 'is', value: 90, time: 19000}]
            lines.starttime = 10000
            lines.endtime = 20000
            buckets = {}
            result = aggregators.is.aggregate lines, 'is:OK', buckets
            buckets['is:OK'].startvalue.should.equal 90

    describe '#combine()', ->
        it 'should linearly interpolate when combining partial chunks', ->
            chunks = [{starttime: 100, endtime: 200, firsttime: 100, firstvalue: 10, lastvalue: 10, count: 1, min: 10, max: 10, mean: 10, time: 100}]
            result = aggregators.is.combine chunks, 0, 150
            result.should.deep.equal
                starttime: 0
                endtime: 150
                firsttime: 100
                firstvalue: 10
                lastvalue: 10
                count: 0.5
                min: 10
                max: 10
                mean: 10
                time: 50

        it 'should maintain the first value when combining partial chunks', ->
            chunks = [{starttime: 100, endtime: 200, firsttime: 100, firstvalue: 10, lastvalue: 10, count: 1, min: 10, max: 10, mean: 10, time: 100}]
            result = aggregators.is.combine chunks, 125, 175
            result.should.deep.equal
                starttime: 125
                endtime: 175
                firsttime: 125
                firstvalue: null
                lastvalue: 10
                count: 0.5
                min: 10
                max: 10
                mean: 10
                time: 50

        it 'should maintain the fidelity when combining a single chunk', ->
            chunks = [{starttime: 100, endtime: 200, firsttime: 100, firstvalue: 10, lastvalue: 10, count: 1, min: 10, max: 10, mean: 10, time: 100}]
            result = aggregators.is.combine chunks, 100, 200
            result.should.deep.equal
                starttime: 100
                endtime: 200
                firsttime: 100
                firstvalue: 10
                lastvalue: 10
                count: 1
                min: 10
                max: 10
                mean: 10
                time: 100

        it 'should take the mean of the chunks, but not the empty times', ->
            chunks = [{starttime: 100, endtime: 200, firsttime: 100, firstvalue: 10, lastvalue: 10, count: 1, min: 10, max: 10, mean: 10, time: 100}
                      {starttime: 200, endtime: 400, firsttime: 100, firstvalue: 5,  lastvalue: 5,  count: 2, min: 5,  max: 5,  mean: 5,  time: 200}]
            result = aggregators.is.combine chunks, 0, 500
            result.should.deep.equal
                starttime: 0
                endtime: 500
                firsttime: 100
                firstvalue: 10
                lastvalue: null
                count: 3
                min: 5
                max: 10
                mean: 6.666666666666667
                time: 300
