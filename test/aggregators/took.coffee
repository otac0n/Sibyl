should = (require 'chai').should()
took = require '../../aggregators/took'

describe 'took', ->
    describe '#aggregate()', ->
        it 'should give the correct start time for the lines', ->
            lines = [{name: 'OK', type: 'took', value: 50, time: 15000, count: 1}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.starttime.should.equal 10000

        it 'should give the correct end time for the lines', ->
            lines = [{name: 'OK', type: 'took', value: 50, time: 15000, count: 1}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.endtime.should.equal 20000

        it 'should give the correct count', ->
            lines = [{name: 'OK', type: 'took', value: 10, time: 11000, count: 1},
                     {name: 'OK', type: 'took', value: 30, time: 13000, count: 1},
                     {name: 'OK', type: 'took', value: 50, time: 15000, count: 1},
                     {name: 'OK', type: 'took', value: 70, time: 17000, count: 1},
                     {name: 'OK', type: 'took', value: 90, time: 19000, count: 1}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.count.should.equal 5

        it 'should give the correct count when there are duplicate values', ->
            lines = [{name: 'OK', type: 'took', value: 30, time: 11000, count: 1},
                     {name: 'OK', type: 'took', value: 30, time: 13000, count: 1},
                     {name: 'OK', type: 'took', value: 50, time: 15000, count: 1},
                     {name: 'OK', type: 'took', value: 70, time: 17000, count: 1},
                     {name: 'OK', type: 'took', value: 70, time: 19000, count: 1}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.count.should.equal 5

        it 'should give the correct minimum value', ->
            lines = [{name: 'OK', type: 'took', value: 10, time: 11000, count: 1},
                     {name: 'OK', type: 'took', value: 30, time: 13000, count: 1},
                     {name: 'OK', type: 'took', value: 50, time: 15000, count: 1},
                     {name: 'OK', type: 'took', value: 70, time: 17000, count: 1},
                     {name: 'OK', type: 'took', value: 90, time: 19000, count: 1}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.min.should.equal 10

        it 'should give the correct maximum value', ->
            lines = [{name: 'OK', type: 'took', value: 10, time: 11000, count: 1},
                     {name: 'OK', type: 'took', value: 30, time: 13000, count: 1},
                     {name: 'OK', type: 'took', value: 50, time: 15000, count: 1},
                     {name: 'OK', type: 'took', value: 70, time: 17000, count: 1},
                     {name: 'OK', type: 'took', value: 90, time: 19000, count: 1}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.max.should.equal 90

        it 'should give the correct mean', ->
            lines = [{name: 'OK', type: 'took', value: 10, time: 11000, count: 1},
                     {name: 'OK', type: 'took', value: 30, time: 13000, count: 1},
                     {name: 'OK', type: 'took', value: 50, time: 15000, count: 1},
                     {name: 'OK', type: 'took', value: 80, time: 17000, count: 1},
                     {name: 'OK', type: 'took', value: 100, time: 19000, count: 1}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.mean.should.equal 54

        it 'should give the correct result with 1 item', ->
            lines = [{name: 'OK', type: 'took', value: 50, time: 15000, count: 1}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 1
                mean: 50
                min: 50
                max: 50
                histogram:
                    '50': 1
                    binsize: 0

        it 'should give the correct result with rates provided', ->
            lines = [{name: 'OK', type: 'took', value: 10, time: 11000, count: 1/0.1},
                     {name: 'OK', type: 'took', value: 20, time: 12000, count: 1/0.2},
                     {name: 'OK', type: 'took', value: 30, time: 13000, count: 1/0.3},
                     {name: 'OK', type: 'took', value: 40, time: 14000, count: 1/0.4},
                     {name: 'OK', type: 'took', value: 50, time: 15000, count: 1/0.5},
                     {name: 'OK', type: 'took', value: 60, time: 16000, count: 1/0.6},
                     {name: 'OK', type: 'took', value: 70, time: 17000, count: 1/0.7},
                     {name: 'OK', type: 'took', value: 80, time: 18000, count: 1/0.8},
                     {name: 'OK', type: 'took', value: 90, time: 19000, count: 1/0.9}]
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 28.289682539682538
                mean: 31.813718614111377
                min: 10
                max: 90
                histogram:
                    '10': 10
                    '20': 5
                    '30': 3.3333333333333335
                    '40': 2.5
                    '50': 2
                    '60': 1.6666666666666667
                    '70': 1.4285714285714286
                    '80': 1.25
                    '90': 1.1111111111111112
                    binsize: 0

        it 'should give the correct result with 32 unique items but more than 32 total', ->
            lines = ({name: 'OK', type: 'took', value: Math.floor(i / 2), time: 15000, count: 1} for i in [0..63])
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 64
                mean: 15.5
                min: 0
                max: 31
                histogram:
                    '0': 2
                    '1': 2
                    '2': 2
                    '3': 2
                    '4': 2
                    '5': 2
                    '6': 2
                    '7': 2
                    '8': 2
                    '9': 2
                    '10': 2
                    '11': 2
                    '12': 2
                    '13': 2
                    '14': 2
                    '15': 2
                    '16': 2
                    '17': 2
                    '18': 2
                    '19': 2
                    '20': 2
                    '21': 2
                    '22': 2
                    '23': 2
                    '24': 2
                    '25': 2
                    '26': 2
                    '27': 2
                    '28': 2
                    '29': 2
                    '30': 2
                    '31': 2
                    binsize: 0

        it 'should give the correct result with 33 unique items where 32 bins is correct', ->
            lines = ({name: 'OK', type: 'took', value: i, time: 15000, count: 1} for i in [1..32])
            lines.push {name: 'OK', type: 'took', value: 1.5, time: 15000, count: 1}
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 33
                mean: 16.045454545454547
                min: 1
                max: 32
                histogram:
                    '1': 2
                    '2': 1
                    '3': 1
                    '4': 1
                    '5': 1
                    '6': 1
                    '7': 1
                    '8': 1
                    '9': 1
                    '10': 1
                    '11': 1
                    '12': 1
                    '13': 1
                    '14': 1
                    '15': 1
                    '16': 1
                    '17': 1
                    '18': 1
                    '19': 1
                    '20': 1
                    '21': 1
                    '22': 1
                    '23': 1
                    '24': 1
                    '25': 1
                    '26': 1
                    '27': 1
                    '28': 1
                    '29': 1
                    '30': 1
                    '31': 1
                    '32': 1
                    binsize: 1

        it 'should give the correct result with 33 unique items where 32 bins is correct', ->
            lines = ({name: 'OK', type: 'took', value: i, time: 15000, count: 1} for i in [1..32])
            lines.push {name: 'OK', type: 'took', value: 1000000, time: 15000, count: 1}
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 33
                mean: 30319.030303030304
                min: 1
                max: 1000000
                histogram:
                    '0': 1
                    '2': 2
                    '4': 2
                    '6': 2
                    '8': 2
                    '10': 2
                    '12': 2
                    '14': 2
                    '16': 2
                    '18': 2
                    '20': 2
                    '22': 2
                    '24': 2
                    '26': 2
                    '28': 2
                    '30': 2
                    '32': 1
                    '1000000': 1
                    binsize: 2

        it 'should give the correct result with more than 32 unique items where 16 bins is correct', ->
            lines = ({name: 'OK', type: 'took', value: i, time: 15000, count: 1} for i in [0..64])
            lines.starttime = 10000
            lines.endtime = 20000
            result = took.aggregate lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 65
                mean: 32
                min: 0
                max: 64
                histogram:
                    '0': 4
                    '4': 4
                    '8': 4
                    '12': 4
                    '16': 4
                    '20': 4
                    '24': 4
                    '28': 4
                    '32': 4
                    '36': 4
                    '40': 4
                    '44': 4
                    '48': 4
                    '52': 4
                    '56': 4
                    '60': 4
                    '64': 1
                    binsize: 4

        it 'should give the correct result with many items spaced with gaps', ->
            lines = []
            for n in [1..1000]
                for i in [0..31]
                    lines.push {name: 'OK', type: 'took', value: i + ((n - 1) / (1000 - 1) / 64), time: 15000, count: 1}
            lines.starttime = 10000
            lines.endtime = 20000
            lines.log = true
            result = took.aggregate lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 32000
                mean: 15.507812500000062
                min: 0
                max: 31.015625
                histogram:
                    '0': 1000
                    '1': 1000
                    '2': 1000
                    '3': 1000
                    '4': 1000
                    '5': 1000
                    '6': 1000
                    '7': 1000
                    '8': 1000
                    '9': 1000
                    '10': 1000
                    '11': 1000
                    '12': 1000
                    '13': 1000
                    '14': 1000
                    '15': 1000
                    '16': 1000
                    '17': 1000
                    '18': 1000
                    '19': 1000
                    '20': 1000
                    '21': 1000
                    '22': 1000
                    '23': 1000
                    '24': 1000
                    '25': 1000
                    '26': 1000
                    '27': 1000
                    '28': 1000
                    '29': 1000
                    '30': 1000
                    '31': 1000
                    binsize: 0.03125

        it 'should give the correct result with many items evenly spaced', ->
            lines = []
            for n in [0...1000]
                for i in [0..31]
                    lines.push {name: 'OK', type: 'took', value: i + n / 1000, time: 15000, count: 1}
            lines.starttime = 10000
            lines.endtime = 20000
            lines.log = true
            result = took.aggregate lines
            result.should.deep.equal
                starttime: 10000
                endtime: 20000
                count: 32000
                mean: 15.99950000000007
                min: 0
                max: 31.999
                histogram:
                    '0': 1000
                    '1': 1000
                    '2': 1000
                    '3': 1000
                    '4': 1000
                    '5': 1000
                    '6': 1000
                    '7': 1000
                    '8': 1000
                    '9': 1000
                    '10': 1000
                    '11': 1000
                    '12': 1000
                    '13': 1000
                    '14': 1000
                    '15': 1000
                    '16': 1000
                    '17': 1000
                    '18': 1000
                    '19': 1000
                    '20': 1000
                    '21': 1000
                    '22': 1000
                    '23': 1000
                    '24': 1000
                    '25': 1000
                    '26': 1000
                    '27': 1000
                    '28': 1000
                    '29': 1000
                    '30': 1000
                    '31': 1000
                    binsize: 1

    describe '#combine()', ->
        it 'should give correct results when combining entire chunks', ->
            chunks = [{starttime: 10000, endtime: 20000, count: 2, mean: 2, min: 1, max: 3, histogram: {'1': 1, '3': 1, binsize: 0.03125}},
                      {starttime: 20000, endtime: 30000, count: 2, mean: 3, min: 2, max: 4, histogram: {'2': 1, '4': 1, binsize: 0.03125}}]
            result = took.combine chunks, 10000, 30000
            result.should.deep.equal
                starttime: 10000
                endtime: 30000
                count: 4
                mean: 2.5
                min: 1
                max: 4
                histogram:
                    '1': 1
                    '2': 1
                    '3': 1
                    '4': 1
                    binsize: 0.03125

        it 'should linearly interpolate when combining partial chunks', ->
            chunks = [{starttime: 10000, endtime: 20000, count: 2, mean: 2, min: 1, max: 3, histogram: {'1': 1, '3': 1, binsize: 0.03125}},
                      {starttime: 20000, endtime: 30000, count: 2, mean: 3, min: 2, max: 4, histogram: {'2': 1, '4': 1, binsize: 0.03125}}]
            result = took.combine chunks, 15000, 25000
            result.should.deep.equal
                starttime: 15000
                endtime: 25000
                count: 2
                mean: 2.5
                min: 1
                max: 4
                histogram:
                    '1': 0.5
                    '2': 0.5
                    '3': 0.5
                    '4': 0.5
                    binsize: 0.03125

    describe '#addpercentiles()', ->
        it 'should never return a value less than the min', ->
            chunk =
                starttime: 0
                endtime: 100
                min: 1
                max: 1.8
                histogram:
                    '0': 2
                    binsize: 2
            took.addPercentiles chunk, [0, 0.01]
            chunk.percentiles.should.deep.equal
                '0': 1
                '0.01': 1.008

        it 'should never return a value greater than the max', ->
            chunk =
                starttime: 0
                endtime: 100
                min: 1
                max: 1.8
                histogram:
                    '0': 2
                    binsize: 2
            took.addPercentiles chunk, [0.99, 1]
            chunk.percentiles.should.deep.equal
                '0.99': 1.792
                '1': 1.8

        it 'should linearly interpolate within a range when the actual value is ambiguous', ->
            chunk =
                starttime: 0
                endtime: 100
                min: 0
                max: 2.9
                histogram:
                    '0': 2
                    '1': 1
                    '2': 2
                    binsize: 1
            took.addPercentiles chunk, [0.4, 0.5, 0.6]
            chunk.percentiles.should.deep.equal
                '0.4': 1
                '0.5': 1.5
                '0.6': 2
