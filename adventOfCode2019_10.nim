
import math
import algorithm
import strutils
import sequtils
import sets
import tables

type
  Point = tuple
    x: int
    y: int

const
  gcInputTest00 = """......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####"""
  gcInputTest01 = """#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###."""
  gcInputTest02 = """.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#.."""
  gcInputTest03 = """.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##"""
  gcInputOrig = """#...##.####.#.......#.##..##.#.
#.##.#..#..#...##..##.##.#.....
#..#####.#......#..#....#.###.#
...#.#.#...#..#.....#..#..#.#..
.#.....##..#...#..#.#...##.....
##.....#..........##..#......##
.##..##.#.#....##..##.......#..
#.##.##....###..#...##...##....
##.#.#............##..#...##..#
###..##.###.....#.##...####....
...##..#...##...##..#.#..#...#.
..#.#.##.#.#.#####.#....####.#.
#......###.##....#...#...#...##
.....#...#.#.#.#....#...#......
#..#.#.#..#....#..#...#..#..##.
#.....#..##.....#...###..#..#.#
.....####.#..#...##..#..#..#..#
..#.....#.#........#.#.##..####
.#.....##..#.##.....#...###....
###.###....#..#..#.....#####...
#..##.##..##.#.#....#.#......#.
.#....#.##..#.#.#.......##.....
##.##...#...#....###.#....#....
.....#.######.#.#..#..#.#.....#
.#..#.##.#....#.##..#.#...##..#
.##.###..#..#..#.###...#####.#.
#...#...........#.....#.......#
#....##.#.#..##...#..####...#..
#.####......#####.....#.##..#..
.#...#....#...##..##.#.#......#
#..###.....##.#.......#.##...##"""
  gcInput = gcInputOrig
  # gcInput = gcInputTest03

  gcInputRows = gcInput.split('\n')
  gcYCount = gcInputRows.len
  gcXCount = gcInputRows[0].len
  gcCount = gcXCount.max(gcYCount)

template getMeteors(): HashSet[Point] =
  block getMeteors:
    var result: HashSet[Point]
    for (lY, lRow) in gcInputRows.pairs:
      for (lX, lCell) in lRow.pairs:
        if ('#' == lCell):
          result.incl((lX, lY))
    result


const
  gcMeteors = getMeteors()

echo gcXCount, '-', gcYCount

proc partOne =
  var lCounts: CountTable[Point]
  for lMeteor in gcMeteors:
    var lOthers = gcMeteors
    lOthers.excl(lMeteor)
    block searchOthers:
      while lOthers.len > 0:
        var lCurrent: Point = lOthers.pop
        lCounts.inc(lMeteor)
        var lDelta: Point = (lCurrent.x - lMeteor.x, lCurrent.y-lMeteor.y)
        let lGCD = lDelta.x.gcd(lDelta.y)
        # let lGCD = 1
        lDelta = (lDelta.x div lGCD, lDelta.y div lGCD)
        lCurrent = (lMeteor.x + lDelta.x, lMeteor.y + lDelta.y)
        while not (
            (lCurrent.x < 0) or
            (lCurrent.y < 0) or
            (lCurrent.x >= gcXCount) or
            (lCurrent.y >= gcYCount)):
          lOthers.excl(lCurrent)
          if 0 == lOthers.len:
            break searchOthers
          lCurrent = (lCurrent.x + lDelta.x, lCurrent.y + lDelta.y)
  echo "partOne ", lCounts.largest



proc partTwo =
  let lBase: Point = (17, 22)
  # let lBase: Point = (11, 13)
  var lOthers = gcMeteors
  lOthers.excl(lBase)
  var lDeltas = toSeq(lOthers.map(proc (it: Point): Point =
    var lDelta: Point = (it.x - lBase.x, it.y-lBase.y)
    let lGCD = lDelta.x.gcd(lDelta.y)
    (lDelta.x div lGCD, lDelta.y div lGCD)).items).mapIt((x: it.x, y: it.y,
        pa: block pseudoAngle:
              let p = it.y.toFloat/(abs(it.x)+abs(it.y)).tofloat
              if it.x >= 0:
                p-1
              else:
                1-p
  ))
  let lSortedDeltas = lDeltas.sortedByIt(it.pa)
  var lCounter = 0
  var lResult: Point
  block searchOthers:
    while lOthers.len > 0:
      for lDelta in lSortedDeltas:
        var lCurrent: Point = (lBase.x + lDelta.x, lBase.y + lDelta.y)
        while not (
            (lCurrent.x < 0) or
            (lCurrent.y < 0) or
            (lCurrent.x >= gcXCount) or
            (lCurrent.y >= gcYCount)):
          if not lOthers.missingOrExcl(lCurrent):
            lCounter.inc
            # echo lCounter, " --> ", lCurrent
            if 200 == lCounter:
              lResult = lCurrent
              break searchOthers
            if 0 == lOthers.len:
              break searchOthers
            break
          lCurrent = (lCurrent.x + lDelta.x, lCurrent.y + lDelta.y)

  # echo lDeltas
  # echo lSortedDeltas

  echo "partTwo ", lResult

partOne() #288 --> (key: (x: 17, y: 22), val: 288)
partTwo() #616 --> (x: 6, y: 16)
