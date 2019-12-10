
import math
import strutils
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
  echo "partTwo ", 2

partOne() #288
partTwo() #XXXX
