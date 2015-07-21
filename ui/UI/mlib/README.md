MLib
====

__MLib__ is a math and collisions library written in Lua. It's aim is to be __robust__ and __easy to use__. 

##Downloading
You can download the latest __stable__ version of MLib by downloading the latest [release](https://github.com/davisdude/mlib/releases/).
You can download the latest __working__ version of MLib by downloading the latest [commit](https://github.com/davisdude/mlib/commits/master/).

##Implementing
To use MLib, simply place [mlib.lua](mlib.lua) inside the desired folder in your project. Then use the `require 'path.to.mlib'` to use any of the functions.

##Examples
You can see some examples of the code in action [here](https://github.com/davisdude/mlib/tree/master/Examples/). 
All examples are done using the *awesome* engine of [LÖVE](https://love2d.org/).
To run them properly, download the [.love file](https://github.com/davisdude/mlib/blob/master/Examples/Shapes.love) and install LÖVE to your computer.
After that, make sure you set .love files to open with "love.exe".
For more, see [here](https://love2d.org/).

##When should I use MLib?
- If you need to know exactly where two objects intersect.
- If you need general mathematical equations to be done. 
- If you need very precise details about point intersections. 

##When should I __not__ use MLib?
- All of the objects in a platformer, or other game, for instance, should not be registered with MLib. Only ones that need very specific information.

##Specs
You can find the tests [here](spec.lua).
You can run them via [Telescope](https://github.com/norman/telescope/) and type the following command in the command-line of the root folder:
```
tsc -f specs.lua
```
If that does not work, you made need to put a link to Lua inside of the folder for `telescope` and run the following command:
```
lua tsc -f specs.lua
```
If you encounter further errors, try to run the command line as an administrator (usually located in `C:\Windows\System32\`), then right-click on `cmd.exe` and select `Run as administrator`, then do 
```
cd C:\Path\to\telescope\
```
And __then__ run one of the above commands. If none of those work, just take my word for it that all the tests pass and look at this picture.
![Success](Reference Pictures/Success.png)

##Functions
- [mlib.line](https://github.com/davisdude/mlib#mlibline)
  - [mlib.line.checkPoint](https://github.com/davisdude/mlib#mliblinecheckpoint)
  - [mlib.line.getCircleIntersection](https://github.com/davisdude/mlib#mliblinegetcircleintersection)
  - [mlib.line.getClosestPoint](https://github.com/davisdude/mlib#mliblinegetclosestpoint)
  - [mlib.line.getDistance](https://github.com/davisdude/mlib#mliblinegetdistance)
  - [mlib.line.getIntercept](https://github.com/davisdude/mlib#mliblinegetintercept)
  - [mlib.line.getIntersection](https://github.com/davisdude/mlib#mliblinegetintersection)
  - [mlib.line.getLength](https://github.com/davisdude/mlib#mliblinegetlength)
  - [mlib.line.getLineIntersection](https://github.com/davisdude/mlib#mliblinegetlineintersection)
  - [mlib.line.getMidpoint](https://github.com/davisdude/mlib#mliblinegetmidpoint)
  - [mlib.line.getPerpendicularBisector](https://github.com/davisdude/mlib#mliblinegetperpendicularbisector)
  - [mlib.line.getPerpendicularSlope](https://github.com/davisdude/mlib#mliblinegetperpendicularslope)
  - [mlib.line.getPolygonIntersection](https://github.com/davisdude/mlib#mliblinegetpolygonintersection)
  - [mlib.line.getSegmentIntersection](https://github.com/davisdude/mlib#mliblinegetsegmentintersection)
  - [mlib.line.getSlope](https://github.com/davisdude/mlib#mliblinegetslope)
- [mlib.line.segment](https://github.com/davisdude/mlib#mliblinesegment)
  - [mlib.line.segment.checkPoint](https://github.com/davisdude/mlib#mliblinesegmentcheckpoint)
  - [mlib.line.segment.getCircleIntersection](https://github.com/davisdude/mlib#mliblinesegmentgetcircleintersection)
  - [mlib.line.segment.getPolygonIntersection](https://github.com/davisdude/mlib#mliblinesegmentgetpolygonintersection)
  - [mlib.line.segment.getLineIntersection](https://github.com/davisdude/mlib#mliblinesegmentgetlineintersection)
  - [mlib.line.segment.getIntersection](https://github.com/davisdude/mlib#mliblinesegmentgetintersection)
  - [mlib.line.segment.getSegmentIntersection](https://github.com/davisdude/mlib#mliblinesegmentgetsegmentintersection)
  - [mlib.line.segment.isSegmentCompletelyInsideCircle](https://github.com/davisdude/mlib#mliblinesegmentissegmentcompletelyinsidecircle)
  - [mlib.line.segment.isSegmentCompletelyInsidePolygon](https://github.com/davisdude/mlib#mliblinesegmentissegmentcompletelyinsidepolygon)
- [mlib.polygon](https://github.com/davisdude/mlib#mlibpolygon)
  - [mlib.polygon.checkPoint](https://github.com/davisdude/mlib#mlibpolygoncheckpoint)
  - [mlib.polygon.getCentroid](https://github.com/davisdude/mlib#mlibpolygongetcentroid)
  - [mlib.polygon.getCircleIntersection](https://github.com/davisdude/mlib#mlibpolygongetcircleintersection)
  - [mlib.polygon.getLineIntersection](https://github.com/davisdude/mlib#mlibpolygongetlineintersection)
  - [mlib.polygon.getPolygonArea](https://github.com/davisdude/mlib#mlibpolygongetpolygonarea)
  - [mlib.polygon.getPolygonIntersection](https://github.com/davisdude/mlib#mlibpolygongetpolygonintersection)
  - [mlib.polygon.getSegmentIntersection](https://github.com/davisdude/mlib#mlibpolygongetsegmentintersection)
  - [mlib.polygon.getSignedPolygonArea](https://github.com/davisdude/mlib#mlibpolygongetsignedpolygonarea)
  - [mlib.polygon.getTriangleHeight](https://github.com/davisdude/mlib#mlibpolygongettriangleheight)
  - [mlib.polygon.isCircleInside](https://github.com/davisdude/mlib#mlibpolygoniscircleinside)
  - [mlib.polygon.isCircleCompletelyInside](https://github.com/davisdude/mlib#mlibpolygoniscirclecompletelyinside)
  - [mlib.polygon.isCircleCompletelyOver](https://github.com/davisdude/mlib#mlibpolygoniscirclecompletelyover)
  - [mlib.polygon.isPolygonInside](https://github.com/davisdude/mlib#mlibpolygonispolygoninside)
  - [mlib.polygon.isPolygonCompletelyInside](https://github.com/davisdude/mlib#mlibpolygonispolygoncompletelyinside)
  - [mlib.polygon.isSegmentInside](https://github.com/davisdude/mlib#mlibpolygonissegmentinside)
  - [mlib.polygon.isSegmentCompletelyInside](https://github.com/davisdude/mlib#mlibpolygonissegmentcompletelyinside)
- [mlib.circle](https://github.com/davisdude/mlib#mlibcircle)
  - [mlib.circle.checkPoint](https://github.com/davisdude/mlib#mlibcirclecheckpoint)
  - [mlib.circle.getArea](https://github.com/davisdude/mlib#mlibcirclegetarea)
  - [mlib.circle.getCircleIntersection](https://github.com/davisdude/mlib#mlibcirclegetcircleintersection)
  - [mlib.circle.getCircumference](https://github.com/davisdude/mlib#mlibcirclegetcircumference)
  - [mlib.circle.getLineIntersection](https://github.com/davisdude/mlib#mlibcirclegetlineintersection)
  - [mlib.circle.getPolygonIntersection](https://github.com/davisdude/mlib#mlibcirclegetpolygonintersection)
  - [mlib.circle.getSegmentIntersection](https://github.com/davisdude/mlib#mlibcirclegetsegmentintersection)
  - [mlib.circle.isCircleCompletelyInside](https://github.com/davisdude/mlib#mlibcircleiscirclecompletelyinside)
  - [mlib.circle.isCircleCompletelyInsidePolygon](https://github.com/davisdude/mlib#mlibcircleiscirclecompletelyinsidepolygon)
  - [mlib.circle.isCircleInsidePolygon](https://github.com/davisdude/mlib#mlibcircleiscircleinsidepolygon)
  - [mlib.circle.isPointOnCircle](https://github.com/davisdude/mlib#mlibcircleispointoncircle)
  - [mlib.circle.isPolygonCompletelyInside](https://github.com/davisdude/mlib#mlibcircleispolygoncompletelyinside)
  - [mlib.circle.isSegmentCompletelyInside](https://github.com/davisdude/mlib#mlibcircleissegmentcompletelyinside)
- [mlib.statistics](https://github.com/davisdude/mlib#mlibstatistics)
  - [mlib.statistics.getCentralTendency](https://github.com/davisdude/mlib#mlibstatisticsgetcentraltendency)
  - [mlib.statistics.getDispersion](https://github.com/davisdude/mlib#mlibstatisticsgetdispersion)
  - [mlib.statistics.getMean](https://github.com/davisdude/mlib#mlibstatisticsgetmean)
  - [mlib.statistics.getMedian](https://github.com/davisdude/mlib#mlibstatisticsgetmedian)
  - [mlib.statistics.getMode](https://github.com/davisdude/mlib#mlibstatisticsgetmode)
  - [mlib.statistics.getRange](https://github.com/davisdude/mlib#mlibstatisticsgetrange)
  - [mlib.statistics.getStandardDeviation](https://github.com/davisdude/mlib#mlibstatisticsgetstandarddeviation)
  - [mlib.statistics.getVariance](https://github.com/davisdude/mlib#mlibstatisticsgetvariance)
  - [mlib.statistics.getVariationRatio](https://github.com/davisdude/mlib#mlibstatisticsgetvariationratio)
- [mlib.math](https://github.com/davisdude/mlib#mlibmath)
  - [mlib.math.getAngle](https://github.com/davisdude/mlib#mlibmathgetangle)
  - [mlib.math.getPercentage](https://github.com/davisdude/mlib#mlibmathgetpercentage)
  - [mlib.math.getPercentOfChange](https://github.com/davisdude/mlib#mlibmathgetpercentofchange)
  - [mlib.math.getQuadraticRoots](https://github.com/davisdude/mlib#mlibmathgetquadraticroots)
  - [mlib.math.getRoot](https://github.com/davisdude/mlib#mlibmathgetroot)
  - [mlib.math.getSummation](https://github.com/davisdude/mlib#mlibmathgetsummation)
  - [mlib.math.isPrime](https://github.com/davisdude/mlib#mlibmathisprime)
  - [mlib.math.round](https://github.com/davisdude/mlib#mlibmathround)
  
####mlib.line
- Deals with linear aspects, such as slope and length. 

#####mlib.line.checkPoint
- Checks if a point lies on a line.
- Synopsis: 
  - `onPoint = mlib.line.checkPoint( px, px, x1, y1, x2, y2 )`
- Arguments:
  - `px`, `py`: Numbers. The x and y coordinates of the point being tested.
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates of the line being tested.
- Returns:
  - `onPoint`: Boolean. 
    - `true` if the point is on the line.
	- `false` if it does not. 
- Notes:
  - You cannot use the format `mlib.line.checkPoint( px, px, slope, intercept )` because this would lead to errors on vertical lines.

#####mlib.line.getCircleIntersection
- Returns the intersections of a circle and a line. 
- Synopsis:
  - `intersections = mlib.line.getCircleIntersection( cx, cy, radius, x1, y1, x2, y2 )`
- Arguments:
  - `cx`, `cy`: Numbers. The x and y coordinates for the center of the circle.
  - `radius`: Number. The radius of the circle. 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates the lie on the line. 
- Returns: 
  - `intersections`: Table. A table with the type and where the intersections happened. Table is formatted:
    - `type`, `x1`, `y1`, `x2`, `y2`
	  - String (`'secant'`), Number, Number, Number, Number
	    - The numbers are the x and y coordinates where the line intersects the circle.
	  - String (`'tangent'`), Number, Number, Boolean (`nil`), Boolean (`nil`)
	    - `x1` and `x2` represent where the line intersects the circle.
	  - Boolean (`false`), Boolean (`nil`), Boolean (`nil`), Boolean (`nil`), Boolean (`nil`)
	    - No intersection. 
    - For more see the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L233).
  
#####mlib.line.getClosestPoint
- Gives the closest point to a line. 
- Synopses: 
  - `cx, cy = mlib.line.getClosestPoint( px, py, x1, y1, x2, y2 )`
  - `cx, cy = mlib.line.getClosestPoint( px, py, slope, intercept )`
- Arguments:
  - `x`, `y`: Numbers. The x and y coordinates of the point. 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates on the line. 
  - `slope`, `intercept`: 
    - Numbers. The slope and y-intercept of the line. 
	- Booleans (`false`). The slope and y-intercept of a vertical line.
- Returns:
  - `cx`, `cy`: Numbers. The closest points that lie on the line to the point. 
  
#####mlib.line.getDistance
- Gives the distance between two points. 
- Synopsis: 
  - `length = mlib.line.getDistance( x1, y1, x2, y2 )
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
- Returns: 
  - `length`: Number. The distance between the two points. 

#####mlib.line.getIntercept
- Gives y-intercept of the line.
- Synopses:
  - `intercept = mlib.line.getIntercept( x1, y1, x2, y2 )`
  - `intercept = mlib.line.getIntercept( x1, y1, slope )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates that lie on the line. 
  - `slope`: 
    - Number. The slope of the line.
	- Boolean. The slope of the line (if the line is vertical)/
- Returns:
  - `intercept`: 
    - Number. The y-intercept of the line. 
	- Boolean (`false`). The y-intercept for a vertical line. 

#####mlib.line.getIntersection
- Gives the intersection of two lines.
- Synopses:
  - `x, y = mlib.line.getIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )`
  - `x, y = mlib.line.getIntersection( slope1, intercept1, x3, y3, x4, y4 )`
  - `x, y = mlib.line.getIntersection( slope1, intercept1, slope2, intercept2 )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates that lie on the first line. 
  - `x3`, `y3`, `x4`, `y4`: Numbers. Two x and y coordinates that lie on the second line.
  - `slope1`, `intercept1`: 
    - Numbers. The slope and y-intercept of the first line.
	- Booleans (`false`). The slope and y-intercept of the first line (if the first line is vertical).
  - `slope2`, `intercept2`: 
    - Numbers. The slope and y-intercept of the second line.
	- Booleans (`false`). The slope and y-intercept of the second line (if the second line is vertical).
- Returns:
  - `x`, `y`:
    - Numbers. The x and y coordinate where the lines intersect.
	- Boolean:
	  - `true`, `nil`: The lines are collinear.
	  - `false`, `nil`: The lines are parallel and __not__ collinear.

#####mlib.line.getLength
- Gives the distance between two points. 
- Synopsis: 
  - `length = mlib.line.getLength( x1, y1, x2, y2 )
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
- Returns: 
  - `length`: Number. The distance between the two points. 

#####mlib.line.getLineIntersection
- Gives the intersection of two lines.
- Synopses:
  - `x, y = mlib.line.getLineIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )`
  - `x, y = mlib.line.getLineIntersection( slope1, intercept1, x3, y3, x4, y4 )`
  - `x, y = mlib.line.getLineIntersection( slope1, intercept1, slope2, intercept2 )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates that lie on the first line. 
  - `x3`, `y3`, `x4`, `y4`: Numbers. Two x and y coordinates that lie on the second line.
  - `slope1`, `intercept1`: 
    - Numbers. The slope and y-intercept of the first line.
	- Booleans (`false`). The slope and y-intercept of the first line (if the first line is vertical).
  - `slope2`, `intercept2`: 
    - Numbers. The slope and y-intercept of the second line.
	- Booleans (`false`). The slope and y-intercept of the second line (if the second line is vertical).
- Returns:
  - `x`, `y`:
    - Numbers. The x and y coordinate where the lines intersect.
	- Boolean:
	  - `true`, `nil`: The lines are collinear.
	  - `false`, `nil`: The lines are parallel and __not__ collinear.

#####mlib.line.getMidpoint
- Gives the midpoint of two points. 
- Synopsis:
  - `x, y = mlib.line.getMidpoint( x1, y1, x2, y2 )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
- Returns: 
  - `x`, `y`: Numbers. The midpoint x and y coordinates. 

#####mlib.line.getPerpendicularBisector
- Gives the perpendicular bisector of a line. 
- Synopsis:
  - `x, y, slope = mlib.line.getPerpendicularBisector( x1, y1, x2, y2 )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
- Returns: 
  - `x`, `y`: Numbers. The midpoint of the line. 
  - `slope`: 
    - Number. The perpendicular slope of the line. 
	- Boolean (`false`). The perpendicular slope of the line (if the original line was horizontal).

#####mlib.line.getPerpendicularSlope
- Gives the perpendicular slope of a line. 
- Synopses:
  - `perpSlope = mlib.line.getPerpendicularSlope( x1, y1, x2, y2 )`
  - `perpSlope = mlib.line.getPerpendicularSlope( slope )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
  - `slope`: Number. The slope of the line. 
- Returns: 
  - `perpSlope`: 
    - Number. The perpendicular slope of the line. 
	- Boolean (`false`). The perpendicular slope of the line (if the original line was horizontal).

#####mlib.line.getPolygonIntersection
- Returns the coordinates of where a line intersects a polygon. 
- Synopses: 
  - `intersections = mlib.line.getPolygonIntersection( x1, y1, x2, y2, vertices )`
  - `intersections = mlib.line.getPolygonIntersection( x1, y1, x2, y2, ... )
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `intersections`: Table. Contains the intersections.
- Notes:
  - With collinear lines, they are actually broken up. i.e. `{ 0, 4, 0, 0 }` would become `{ 0, 4 }, { 0, 0 }`.

#####mlib.line.getSegmentIntersection
- Gives the intersection of a line segment and a line. 
- Synopses: 
  - `x1, y1, x2, y2 = mlib.line.getSegmentIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )`
  - `x1, y1, x2, y2 = mlib.line.getSegmentIntersection( x1, y1, x2, y2, slope, intercept )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates that lie on the line segment.
  - `x3`, `y3`, `x4`, `y4`: Numbers. Two x and y coordinates that lie on the line.
  - `slope`, `intercept`: 
    - Numbers. The slope and y-intercept of the the line.
	- Booleans (`false`). The slope and y-intercept of the line (if the line is vertical).
- Returns:
  - `x1`, `y1`, `x2`, `y2`: 
    - Number, Number, Number, Number. 
	  - The points of the line segment if the line and segment are collinear.
	- Number, Number, Boolean (`nil`), Boolean (`nil`). 
	  - The coordinate of intersection if the line and segment intersect and are not collinear.
	- Boolean (`false`), Boolean (`nil`), Boolean (`nil`), 
	  - Boolean (`nil`). If the line and segment don't intersect. 

#####mlib.line.getSlope
- Gives the slope of a line. 
- Synopsis: 
  - `slope = mlib.line.getSlope( x1, y1, x2, y2 )
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
- Returns: 
  - `slope`:
    - Number. The slope of the line. 
	- Boolean (`false`). The slope of the line (if the line is vertical).

####mlib.line.segment
- Deals with line segments. 

#####mlib.line.segment.checkPoint
- Checks if a point lies on a line segment. 
- Synopsis:
  - `onSegment = mlib.line.segment.checkPoint( px, py, x1 y1, x2, y2 )`
- Arguments: 
  - `px`, `py`: Numbers. The x and y coordinates of the point being checked.
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
- Returns:
  - `onSegment`: Boolean.
    - `true` if the point lies on the line segment.
	- `false` if the point does not lie on the line segment. 

#####mlib.line.segment.getCircleIntersection
- Returns the intersections of a circle and a line segment. 
- Synopsis:
  - `intersections = mlib.line.segment.getCircleIntersection( cx, cy, radius, x1, y1, x2, y2 )`
- Arguments:
  - `cx`, `cy`: Numbers. The x and y coordinates for the center of the circle.
  - `radius`: Number. The radius of the circle. 
  - `x1`, `y1`, `x2`, `y2`: Numbers. The two x and y coordinates of the line segment. 
- Returns: 
  - `intersections`: Table. A table with the type and where the intersections happened. Table is formatted:
    - `type`, `x1`, `y1`, `x2`, `y2`
	  - String (`'chord'`), Number, Number, Number, Number
	    - The numbers are the x and y coordinates where the line segment is on both edges of the circle. 
	  - String (`'enclosed'`), Number, Number, Number, Number
	    - The numbers are the x and y coordinates of the line segment if it is fully inside of the circle.
	  - String (`'secant'`), Number, Number, Number, Number
	    - The numbers are the x and y coordinates where the line segment intersects the circle.
	  - String (`'tangent'`), Number, Number, Boolean (`nil`), Boolean (`nil`)
	    - `x1` and `x2` represent where the line segment intersects the circle.
	  - Boolean (`false`), Boolean (`nil`), Boolean (`nil`), Boolean (`nil`), Boolean (`nil`)
	    - No intersection. 
    - For more see the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L324).

#####mlib.line.segment.getPolygonIntersection
- Returns the coordinates of where a line segmeing intersects a polygon. 
- Synopses: 
  - `intersections = mlib.line.segment.getPolygonIntersection( x1, y1, x2, y2, vertices )`
  - `intersections = mlib.line.segment.getPolygonIntersection( x1, y1, x2, y2, ... )
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `intersections`: Table. Contains the intersections.
- Notes:
  - With collinear line segments, they are __not__ broken up. See the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L346) for more. 

#####mlib.line.segment.getLineIntersection
- Gives the intersection of a line segment and a line. 
- Synopses: 
  - `x1, y1, x2, y2 = mlib.line.segment.getLineIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )`
  - `x1, y1, x2, y2 = mlib.line.segment.getLineIntersection( x1, y1, x2, y2, slope, intercept )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates that lie on the line segment.
  - `x3`, `y3`, `x4`, `y4`: Numbers. Two x and y coordinates that lie on the line.
  - `slope`, `intercept`: 
    - Numbers. The slope and y-intercept of the the line.
	- Booleans (`false`). The slope and y-intercept of the line (if the line is vertical).
- Returns:
  - `x1`, `y1`, `x2`, `y2`: 
    - Number, Number, Number, Number. 
	  - The points of the line segment if the line and segment are collinear.
	- Number, Number, Boolean (`nil`), Boolean (`nil`). 
	  - The coordinate of intersection if the line and segment intersect and are not collinear.
	- Boolean (`false`), Boolean (`nil`), Boolean (`nil`), 
	  - Boolean (`nil`). If the line and segment don't intersect. 

#####mlib.line.segment.getIntersection
- Checks if two line segments intersect. 
- Synopsis: 
  - `cx1, cy1, cx2, cy2 = mlib.line.segment.getIntersection( x1, y1, x2, y2, x3, y3 x4, y4 )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates of the first line segment.
  - `x3`, `y3`, `x4`, `y4`: Numbers. Two x and y coordinates of the second line segment.
- Returns: 
  - `cx1`, `cy1`, `cx2`, `cy2`: 
    - Number, Number, Number, Number. 
	  - The points of the resulting intersection if the line segments are collinear.
	- Number, Number, Boolean (`nil`), Boolean (`nil`). 
	  - The point of the resulting intersection if the line segments are not collinear. 
	- Boolean (`false`), Boolean (`nil`), Boolean (`nil`) , Boolean (`nil`).
	  - If the line segments don't intersect. 

#####mlib.line.segment.getSegmentIntersection
- Checks if two line segments intersect. 
- Synopsis: 
  - `cx1, cy1, cx2, cy2 = mlib.line.segment.getIntersection( x1, y1, x2, y2, x3, y3 x4, y4 )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates of the first line segment.
  - `x3`, `y3`, `x4`, `y4`: Numbers. Two x and y coordinates of the second line segment.
- Returns: 
  - `cx1`, `cy1`, `cx2`, `cy2`: 
    - Number, Number, Number, Number. 
	  - The points of the resulting intersection if the line segments are collinear.
	- Number, Number, Boolean (`nil`), Boolean (`nil`). 
	  - The point of the resulting intersection if the line segments are not collinear. 
	- Boolean (`false`), Boolean (`nil`), Boolean (`nil`) , Boolean (`nil`).
	  - If the line segments don't intersect. 

#####mlib.line.segment.isSegmentCompletelyInsideCircle
- Checks if a polygon is completely inside of a circle.
- Synopsis:
  - `completelyInside = mlib.line.segment.isSegmentCompletelyInsideCircle( circleX, circleY, circleRadius, x1, y1, x2, y2 )`
- Arguments: 
  - `circleX`, `circleY`: Numbers. The x and y coordinates of the circle. 
  - `circleRadius`: Number. The radius of the circle.
  - `x1`, `y1`: Numbers. The x and y coordinates of one end of the segment.
  - `x2`, `y2`: Numbers. The x and y coordinates of the other end of the segment.
- Returns: 
  - `completelyInside`: Boolean. 
    - `true` if the segment is inside of the circle.
	- `false` if the segment is not __completely__ inside of the circle.

#####mlib.line.segment.isSegmentCompletelyInsidePolygon
- Checks if a line segment is completely inside a polygon. 
- Synopses:
  - `inPolygon = mlib.line.segment.isSegmentCompletelyInsidePolygon( x1, y1, x2, y2, vertices )`
  - `inPolygon = mlib.line.segment.isSegmentCompletelyInsidePolygon( x1, y1, x2, y2, ... )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. The x and y coordinates of the line segment. 
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `inPolygon`: Boolean. 
    - `true` if the line segment is __completely__ inside the polygon. 
	- `false` if the line segment is not inside the polygon. 

####mlib.polygon
- Handles aspects involving polygons. 

#####mlib.polygon.checkPoint
- Checks if a point is inside of a polygon.
- Synopses: 
  - `inPolygon = mlib.polygon.checkPoint( px, py, vertices )`
  - `inPolygon = mlib.polygon.checkPoint( px, py, ... )`
- Arguments: 
  - `px`, `py`: Numbers. The x and y coordinate of the point being checked.
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `inPolygon`: Boolean.
    - `true` if the point is inside the polygon. 
	- `false` if the point is not inside the polygon. 

#####mlib.polygon.getCentroid
- Returns the centroid of the polygon. 
- Synopses: 
  - `cx, cy = mlib.polygon.getCentroid( vertices )`
  - `cx, cy = mlib.polygon.getCentroid( ... )`
- Arguments: 
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `cx`, `cy`: Numbers. The x and y coordinates of the centroid. 

#####mlib.polygon.getCircleIntersection
- Returns the coordinates of where a circle intersects a polygon. 
- Synopses: 
  - `intersections = mlib.polygon.getCircleIntersection( cx, cy, radius, vertices )`
  - `intersections = mlib.polygon.getCircleIntersection( cx, cy, radius, ... )
- Arguments: 
  - `cx`, `cy`: Number. The coordinates of the center of the circle.
  - `radius`: Number. The radius of the circle. 
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `intersections`: Table. Contains the intersections and type. 
- Example: 
```lua
local tab = _.polygon.getCircleIntersection( 5, 5, 1, 4, 4, 6, 4, 6, 6, 4, 6 )
for i = 1, #tab do
	print( i .. ':', unpack( tab[i] ) )
end
-- 1: 	tangent		5		4
-- 2: 	tangent		6 		5
-- 3: 	tangent 	5		6
-- 4: 	tagnent 	4		5
```
- For more see [mlib.circle.getSegmentIntersection](https://github.com/davisdude/mlib#mlibcirclegetsegmentintersection) or the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L557)

#####mlib.polygon.getLineIntersection
- Returns the coordinates of where a line intersects a polygon. 
- Synopses: 
  - `intersections = mlib.polygon.getLineIntersection( x1, y1, x2, y2, vertices )`
  - `intersections = mlib.polygon.getLineIntersection( x1, y1, x2, y2, ... )
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `intersections`: Table. Contains the intersections.
- Notes:
  - With collinear lines, they are actually broken up. i.e. `{ 0, 4, 0, 0 }` would become `{ 0, 4 }, { 0, 0 }`.

#####mlib.polygon.getPolygonArea
- Gives the area of a polygon. 
- Synopses: 
  - `area = mlib.polygon.getArea( vertices )`
  - `area = mlib.polygon.getArea( ... )
- Arguments: 
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `area`: Number. The area of the polygon. 

#####mlib.polygon.getPolygonIntersection
- Gives the intersection of two polygons.
- Synopsis:
  - `intersections = mlib.polygon.getPolygonIntersections( polygon1, polygon2 )`
- Arguments: 
  - `polygon1`: Table. The vertices of the first polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `polygon2`: Table. The vertices of the second polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
- Returns:
  - `intersections`: Table. A table of the points of intersection. 

#####mlib.polygon.getSegmentIntersection
- Returns the coordinates of where a line segmeing intersects a polygon. 
- Synopses: 
  - `intersections = mlib.polygon.getLineIntersection( x1, y1, x2, y2, vertices )`
  - `intersections = mlib.polygon.getLineIntersection( x1, y1, x2, y2, ... )
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates.
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `intersections`: Table. Contains the intersections.
- Notes:
  - With collinear line segments, they are __not__ broken up. See the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L507) for more. 

#####mlib.polygon.getSignedPolygonArea
- Gets the signed area of the polygon. If the points are ordered counter-clockwise the area is positive. If the points are ordered clockwise the number is negative. 
- Synopses:
  - `area = mlib.polygon.getLineIntersection( vertices )`
  - `area = mlib.polygon.getLineIntersection( ... )
- Arguments: 
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `area`: Number. The __signed__ area of the polygon. If the points are ordered counter-clockwise the area is positive. If the points are ordered clockwise the number is negative. 

#####mlib.polygon.getTriangleHeight
- Gives the height of a triangle.
- Synopses: 
  - `height = mlib.polygon.getTriangleHeigh( base, x1, y1, x2, y2, x3, y3 )`
  - `height = mlib.polygon.getTriangleHeight( base, area )`
- Arguments: 
  - `base`: Number. The length of the base of the triangle.
  - `x1`, `y1`, `x2`, `y2`, `x3`, `y3`: Numbers. The x and y coordinates of the triangle.
  - `area`: Number. The regular area of the triangle. __Not__ the signed area.
- Returns: 
  - `height`: Number. The height of the triangle. 

#####mlib.polygon.isCircleInside
- Checks if a circle is inside the polygon. 
- Synopses:
  - `inPolygon = mlib.polygon.isCircleInside( cx, cy, radius, vertices )`
  - `inPolygon = mlib.polygon.isCircleInside( cx, cy, radius, ... )`
- Arguments: 
  - `cx`, `cy`: Numbers. The x and y coordinates for the center of the circle.
  - `radius`: Number. The radius of the circle.
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `inPolygon`: Boolean.
    - `true` if the circle is inside the polygon. 
	- `false` if the circle is not inside the polygon. 
- Notes:
  - Only returns true if the center of the circle is inside the circle. 

#####mlib.polygon.isCircleCompletelyInside
- Checks if a circle is completely inside the polygon. 
- Synopses:
  - `inPolygon = mlib.polygon.isCircleCompletelyInside( cx, cy, radius, vertices )`
  - `inPolygon = mlib.polygon.isCircleCompletelyInside( cx, cy, radius, ... )`
- Arguments: 
  - `cx`, `cy`: Numbers. The x and y coordinates for the center of the circle.
  - `radius`: Number. The radius of the circle.
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `inPolygon`: Boolean.
    - `true` if the circle is __completely__ inside the polygon. 
	- `false` if the circle is not inside the polygon. 

#####mlib.polygon.isCircleCompletelyOver
- Checks if a polygon is completely inside of a circle.
- Synopsis:
  - `completelyInside = mlib.polygon.isCircleCompletelyOver( circleX, circleY, circleRadius, vertices )`
  - `completelyInside = mlib.polygon.isCircleCompletelyOver( circleX, circleY, circleRadius, ... )`
- Arguments: 
  - `circleX`, `circleY`: Numbers. The x and y coordinates of the circle. 
  - `circleRadius`: Number. The radius of the circle.
  - `vertices`: Table. A table containing all of the vertices of the polygon. 
  - `...`: Numbers. All of the points of the polygon.
- Returns: 
  - `completelyInside`: Boolean. 
    - `true` if the polygon is inside of the circle.
	- `false` if the polygon is not __completely__ inside of the circle.

#####mlib.polygon.isPolygonInside
- Checks if a polygon is inside a polygon. 
- Synopsis: 
  - `inPolygon = mlib.polygon.isPolygonInside( polygon1, polygon2 )`
- Arguments: 
  - `polygon1`: Table. The vertices of the first polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `polygon2`: Table. The vertices of the second polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
- Returns: 
  - `inPolygon`: Boolean. 
    - `true` if the `polygon2` is inside of `polygon1`.
	- `false` if `polygon2` is not inside of `polygon2`.
- Notes: 
  - Returns true as long as any of the line segments of `polygon2` are inside of the `polygon1`.

#####mlib.polygon.isPolygonCompletelyInside
- Checks if a polygon is completely inside a polygon. 
- Synopsis: 
  - `inPolygon = mlib.polygon.isPolygonCompletelyInside( polygon1, polygon2 )`
- Arguments: 
  - `polygon1`: Table. The vertices of the first polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `polygon2`: Table. The vertices of the second polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
- Returns: 
  - `inPolygon`: Boolean. 
    - `true` if the `polygon2` is __completely__ inside of `polygon1`.
	- `false` if `polygon2` is not inside of `polygon2`.

#####mlib.polygon.isSegmentInside
- Checks if a line segment is inside a polygon. 
- Synopses:
  - `inPolygon = mlib.polygon.isSegmentInside( x1, y1, x2, y2, vertices )`
  - `inPolygon = mlib.polygon.isSegmentInside( x1, y1, x2, y2, ... )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. The x and y coordinates of the line segment. 
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `inPolygon`: Boolean. 
    - `true` if the line segment is inside the polygon. 
	- `false` if the line segment is not inside the polygon. 
- Note: 
  - Only one of the points has to be in the polygon to be considered 'inside' of the polygon. 
  - This is really just a faster version of [mlib.polygon.getPolygonIntersection](https://github.com/davisdude/mlib#mlibpolygongetpolygonintersection) that does not give the points of intersection. 

#####mlib.polygon.isSegmentCompletelyInside
- Checks if a line segment is completely inside a polygon. 
- Synopses:
  - `inPolygon = mlib.polygon.isSegmentCompletelyInside( x1, y1, x2, y2, vertices )`
  - `inPolygon = mlib.polygon.isSegmentCompletelyInside( x1, y1, x2, y2, ... )`
- Arguments: 
  - `x1`, `y1`, `x2`, `y2`: Numbers. The x and y coordinates of the line segment. 
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `inPolygon`: Boolean. 
    - `true` if the line segment is __completely__ inside the polygon. 
	- `false` if the line segment is not inside the polygon. 

####mlib.circle
- Handles aspects involving circles.

#####mlib.circle.checkPoint
- Checks if a point is on the inside or on the edge the circle.
- Synopsis:
  - `inCircle = mlib.circle.checkPoint( px, px, cx, cy, radius )`
- Arguments: 
  - `px`, `py`: Numbers. The x and y coordinates of the point being tested. 
  - `cx`, `cy`: Numbers. The x and y coordinates of the center of the circle.
  - `radius`: Number. The radius of the circle.
- Returns: 
  - `inCircle`: Boolean.
    - `true` if the point is inside or on the circle. 
	- `false` if the point is outside of the circle. 

#####mlib.circle.getArea
- Gives the area of a circle. 
- Synopsis:
  - `area = mlib.circle.getArea( radius )`
- Arguments: 
  - `radius`: Number. The radius of the circle.
- Returns: 
  - `area`: Number. The area of the circle. 

#####mlib.circle.getCircleIntersection
- Gives the intersections of two circles. 
- Synopsis:
  - `intersections = mlib.circle.getCircleIntersection( c1x, c1y, radius1, c2x, c2y, radius2 )
- Arguments: 
  - `c1x`, `c1y`: Numbers. The x and y coordinate of the first circle. 
  - `radius1`: Number. The radius of the first circle.
  - `c2x`, `c2y`: Numbers. The x and y coordinate of the second circle. 
  - `radius2`: Number. The radius of the second circle.
- Returns: 
  - `intersections`: Table. A table that contains the type and where the circle collides. See the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L697) for more. 

#####mlib.circle.getCircumference
- Returns the circumference of a circle.
- Synopsis:
  - `circumference = mlib.circle.getCircumference( radius )`
- Arguments: 
  - `radius`: Number. The radius of the circle.
- Returns:
  - `circumference`: Number. The circumference of a circle. 

#####mlib.circle.getLineIntersection
- Returns the intersections of a circle and a line. 
- Synopsis:
  - `intersections = mlib.circle.getLineIntersections( cx, cy, radius, x1, y1, x2, y2 )`
- Arguments:
  - `cx`, `cy`: Numbers. The x and y coordinates for the center of the circle.
  - `radius`: Number. The radius of the circle. 
  - `x1`, `y1`, `x2`, `y2`: Numbers. Two x and y coordinates the lie on the line. 
- Returns: 
  - `intersections`: Table. A table with the type and where the intersections happened. Table is formatted:
    - `type`, `x1`, `y1`, `x2`, `y2`
	  - String (`'secant'`), Number, Number, Number, Number
	    - The numbers are the x and y coordinates where the line intersects the circle.
	  - String (`'tangent'`), Number, Number, Boolean (`nil`), Boolean (`nil`)
	    - `x1` and `x2` represent where the line intersects the circle.
	  - Boolean (`false`), Boolean (`nil`), Boolean (`nil`), Boolean (`nil`), Boolean (`nil`)
	    - No intersection. 
    - For more see the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L659).

#####mlib.circle.getPolygonIntersection
- Returns the coordinates of where a circle intersects a polygon. 
- Synopses: 
  - `intersections = mlib.circle.getPolygonIntersection( cx, cy, radius, vertices )`
  - `intersections = mlib.circle.getPolygonIntersection( cx, cy, radius, ... )
- Arguments: 
  - `cx`, `cy`: Number. The coordinates of the center of the circle.
  - `radius`: Number. The radius of the circle. 
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `intersections`: Table. Contains the intersections and type. 
- Example: 
```lua
local tab = _.circle.getPolygonIntersection( 5, 5, 1, 4, 4, 6, 4, 6, 6, 4, 6 )
for i = 1, #tab do
	print( i .. ':', unpack( tab[i] ) )
end
-- 1: 	tangent		5		4
-- 2: 	tangent		6 		5
-- 3: 	tangent 	5		6
-- 4: 	tagnent 	4		5
```
- For more see [mlib.circle.getSegmentIntersection](https://github.com/davisdude/mlib#mlibcirclegetsegmentintersection) or the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L753)

#####mlib.circle.getSegmentIntersection
- Returns the intersections of a circle and a line segment. 
- Synopsis:
  - `intersections = mlib.circle.getSegmentIntersections( cx, cy, radius, x1, y1, x2, y2 )`
- Arguments:
  - `cx`, `cy`: Numbers. The x and y coordinates for the center of the circle.
  - `radius`: Number. The radius of the circle. 
  - `x1`, `y1`, `x2`, `y2`: Numbers. The two x and y coordinates of the line segment. 
- Returns: 
  - `intersections`: Table. A table with the type and where the intersections happened. Table is formatted:
    - `type`, `x1`, `y1`, `x2`, `y2`
	  - String (`'chord'`), Number, Number, Number, Number
	    - The numbers are the x and y coordinates where the line segment is on both edges of the circle. 
	  - String (`'enclosed'`), Number, Number, Number, Number
	    - The numbers are the x and y coordinates of the line segment if it is fully inside of the circle.
	  - String (`'secant'`), Number, Number, Number, Number
	    - The numbers are the x and y coordinates where the line segment intersects the circle.
	  - String (`'tangent'`), Number, Number, Boolean (`nil`), Boolean (`nil`)
	    - `x1` and `x2` represent where the line segment intersects the circle.
	  - Boolean (`false`), Boolean (`nil`), Boolean (`nil`), Boolean (`nil`), Boolean (`nil`)
	    - No intersection. 
    - For more see the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L675).

#####mlib.circle.isCircleCompletelyInside
- Checks if one circle is completely inside of another circle.
- Synopsis:
  - `completelyInside = mlib.circle.isCircleCompletelyInside( c1x, c1y, c1radius, c2x, c2y, c2radius )`
- Arguments: 
  - `c1x`, `c1y`: Numbers. The x and y coordinates of the first circle. 
  - `c1radius`: Number. The radius of the first circle.
  - `c2x`, `c2y`: Numbers. The x and y coordinates of the second circle. 
  - `c2radius`: Number. The radius of the second circle.
- Returns: 
  - `completelyInside`: Boolean. 
    - `true` if circle1 is inside of circle2.
	- `false` if circle1 is not __completely__ inside of circle2.

#####mlib.circle.isCircleCompletelyInsidePolygon
- Checks if a circle is completely inside the polygon. 
- Synopses:
  - `inPolygon = mlib.polygon.isCircleCompletelyInside( cx, cy, radius, vertices )`
  - `inPolygon = mlib.polygon.isCircleCompletelyInside( cx, cy, radius, ... )`
- Arguments: 
  - `cx`, `cy`: Numbers. The x and y coordinates for the center of the circle.
  - `radius`: Number. The radius of the circle.
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `inPolygon`: Boolean.
    - `true` if the circle is __completely__ inside the polygon. 
	- `false` if the circle is not inside the polygon. 

#####mlib.circle.isCircleInsidePolygon
- Checks if a circle is inside a polygon. 
- Synopses:
  - `inPolygon = mlib.circle.isCircleInsidePolygon( cx, cy, radius, vertices )`
  - `inPolygon = mlib.circle.isCircleInsidePolygon( cx, cy, radius, ... )`
- Arguments: 
  - `cx`, `cy`: Numbers. The x and y coordinates for the center of the circle.
  - `radius`: Number. The radius of the circle.
  - `vertices`: Table. The vertices of the polygon in the format `{ x1, y1, x2, y2, x3, y3, ... }`
  - `...`: Numbers. The x and y coordinates of the polygon. (Same as using `unpack( vertices )`)
- Returns: 
  - `inPolygon`: Boolean.
    - `true` if the circle is inside the polygon. 
	- `false` if the circle is not inside the polygon. 
- Notes:
  - Only returns true if the center of the circle is inside the circle. 

#####mlib.circle.isPointOnCircle
- Checks if a point is __exactly__ on the edge of the circle.
- Synopsis:
  - `onCircle = mlib.circle.checkPoint( px, px, cx, cy, radius )`
- Arguments: 
  - `px`, `py`: Numbers. The x and y coordinates of the point being tested. 
  - `cx`, `cy`: Numbers. The x and y coordinates of the center of the circle.
  - `radius`: Number. The radius of the circle.
- Returns: 
  - `onCircle`: Boolean.
    - `true` if the point is on the circle. 
	- `false` if the point is on the inside or outside of the circle. 
- Notes: 
  - Will return false if the point is inside __or__ outside of the circle.

#####mlib.circle.isPolygonCompletelyInside
- Checks if a polygon is completely inside of a circle.
- Synopsis:
  - `completelyInside = mlib.circle.isPolygonCompletelyInside( circleX, circleY, circleRadius, vertices )`
  - `completelyInside = mlib.circle.isPolygonCompletelyInside( circleX, circleY, circleRadius, ... )`
- Arguments: 
  - `circleX`, `circleY`: Numbers. The x and y coordinates of the circle. 
  - `circleRadius`: Number. The radius of the circle.
  - `vertices`: Table. A table containing all of the vertices of the polygon. 
  - `...`: Numbers. All of the points of the polygon.
- Returns: 
  - `completelyInside`: Boolean. 
    - `true` if the polygon is inside of the circle.
	- `false` if the polygon is not __completely__ inside of the circle.

#####mlib.circle.isSegmentCompletelyInside
- Checks if a polygon is completely inside of a circle.
- Synopsis:
  - `completelyInside = mlib.circle.isSegmentCompletelyInside( circleX, circleY, circleRadius, x1, y1, x2, y2 )`
- Arguments: 
  - `circleX`, `circleY`: Numbers. The x and y coordinates of the circle. 
  - `circleRadius`: Number. The radius of the circle.
  - `x1`, `y1`: Numbers. The x and y coordinates of one end of the segment.
  - `x2`, `y2`: Numbers. The x and y coordinates of the other end of the segment.
- Returns: 
  - `completelyInside`: Boolean. 
    - `true` if the segment is inside of the circle.
	- `false` if the segment is not __completely__ inside of the circle.

####mlib.statistics
- Handles statistical aspects of math.

#####mlib.statistics.getCentralTendency
- Gets the central tendency of the data.
- Synopses:
  - `modes, occurrences, median, mean = mlib.statistics.getCentralTendency( data )`
  - `modes, occurrences, median, mean = mlib.statistics.getCentralTendency( ... )`
- Arguments: 
  - `data`: Table. A table containing the values of data.
  - `...`: Numbers. All of the numbers in the data set.
- Returns:
  - `modes, occurrences`: Table, Number. The modes of the data and the number of times it occurs. See [mlib.statistics.getMode](https://github.com/davisdude/mlib#mlibstatisticsgetmode).
  - `median`: Number. The median of the data set. 
  - `mean`: Number. The mean of the data set.

#####mlib.statistics.getDispersion
- Gets the dispersion of the data.
- Synopses:
  - `variationRatio, range, standardDeviation = mlib.statistics.getDispersion( data )`
  - `variationRatio, range, standardDeviation = mlib.statistics.getDispersion( ... )`
- Arguments: 
  - `data`: Table. A table containing the values of data.
  - `...`: Numbers. All of the numbers in the data set.
- Returns:
  - `variationRatio`: Number. The variation ratio of the data set.
  - `range`: Number. The range of the data set.
  - `standardDeviation`: Number. The standard deviation of the data set.

#####mlib.statistics.getMean
- Gets the arithmetic mean of the data.
- Synopses:
  - `mean = mlib.statistics.getMean( data )`
  - `mean = mlib.statistics.getMean( ... )`
- Arguments: 
  - `data`: Table. A table containing the values of data.
  - `...`: Numbers. All of the numbers in the data set.
- Returns:
  - `mean`: Number. The arithmetic mean of the data set. 

#####mlib.statistics.getMedian
- Gets the median of the data set. 
- Synopses:
  - `median = mlib.statistics.getMedian( data )`
  - `median = mlib.statistics.getMedian( ... )`
- Arguments: 
  - `data`: Table. A table containing the values of data.
  - `...`: Numbers. All of the numbers in the data set.
- Returns: 
  - `median`: Number. The median of the data. 

#####mlib.statistics.getMode
- Gets the mode of the data set. 
- Synopses:
  - `mode, occurrences = mlib.statistics.getMode( data )`
  - `mode, occurrences = mlib.statistics.getMode( ... )`
- Arguments: 
  - `data`: Table. A table containing the values of data.
  - `...`: Numbers. All of the numbers in the data set.
- Returns: 
  - `mode`: Table. The mode(s) of the data.
  - `occurrences`: Number. The number of time the mode(s) occur.

#####mlib.statistics.getRange
- Gets the range of the data set. 
- Synopses:
  - `range = mlib.statistics.getRange( data )`
  - `range = mlib.statistics.getRange( ... )`
- Arguments: 
  - `data`: Table. A table containing the values of data.
  - `...`: Numbers. All of the numbers in the data set.
- Returns: 
  - `range`: Number. The range of the data. 

#####mlib.statistics.getStandardDeviation
- Gets the standard deviation of the data.
- Synopses:
  - `standardDeviation = mlib.statistics.getStandardDeviation( data )`
  - `standardDeviation = mlib.statistics.getStandardDeviation( ... )`
- Arguments: 
  - `data`: Table. A table containing the values of data.
  - `...`: Numbers. All of the numbers in the data set.
- Returns:
  - `standardDeviation`: Number. The standard deviation of the data set. 

#####mlib.statistics.getVariance
- Gets the variation of the data.
- Synopses:
  - `variance = mlib.statistics.getVariance( data )`
  - `variance = mlib.statistics.getVariance( ... )`
- Arguments: 
  - `data`: Table. A table containing the values of data.
  - `...`: Numbers. All of the numbers in the data set.
- Returns:
  - `variance`: Number. The variation of the data set.

#####mlib.statistics.getVariationRatio
- Gets the variation ratio of the data.
- Synopses:
  - `variationRatio = mlib.statistics.getVariationRatio( data )`
  - `variationRatio = mlib.statistics.getVariationRatio( ... )`
- Arguments: 
  - `data`: Table. A table containing the values of data.
  - `...`: Numbers. All of the numbers in the data set.
- Returns:
  - `variationRatio`: Number. The variation ratio of the data set. 

####mlib.math
- Miscellaneous functions that have no home. 

#####mlib.math.getAngle
- Gets the angle between three points. 
- Synopsis: 
  - `angle = mlib.math.getAngle( x1, y1, x2, y2, x3, y3 )`
- Arguments: 
  - `x1`, `y1`: Numbers. The x and y coordinates of the first point. 
  - `x2`, `y2`: Numbers. The x and y coordinates of the vertex of the two points. 
  - `x3`, `y3`: Numbers. The x and y coordinates of the second point. 

#####mlib.math.getPercentage
- Gets the percentage of a number. 
- Synopsis: 
  - `percentage = mlib.math.getPercentage( percent, number )`
- Arguments: 
  - `percent`: Number. The decimal value of the percent (i.e. 100% is 1, 50% is .5).
  - `number`: Number. The number to get the percentage of. 
- Returns: 
  - `percentage`: Number. The `percent`age or `number`.

#####mlib.math.getPercentOfChange
- Gets the percent of change from one to another. 
- Synopsis: 
  - `change = mlib.math.getPercentOfChange( old, new )`
- Arguments: 
  - `old`: Number. The original number. 
  - `new`: Number. The new number. 
- Returns: 
  - `change`: Number. The percent of change from `old` to `new`. 

#####mlib.math.getQuadraticRoots
- Gets the quadratic roots of the the equation.
- Synopsis:
  - `root1, root2 = mlib.math.getQuadraticRoots( a, b, c )`
- Arguments: 
  - `a`, `b`, `c`: Numbers. The a, b, and c values of the equation `a * x ^ 2 + b * x ^ 2 + c`.
- Returns: 
  - `root1`, `root2`: Numbers. The roots of the equation (where `a * x ^ 2 + b * x ^ 2 + c = 0`).

#####mlib.math.getRoot
- Gets the `n`th root of a number.
- Synopsis: 
  - `x = mlib.math.getRoot( number, root )`
- Arguments: 
  - `number`: Number. The number to get the root of.
  - `root`: Number. The root. 
- Returns: 
  - `x`: The `root`th root of `number`.
- Example: 
```lua
local a = mlib.math.getRoot( 4, 2 ) -- Same as saying 'math.pow( 4, .5 )' or 'math.sqrt( 4 )' in this case.
local b = mlib.math.getRoot( 27, 3 )

print( a, b ) --> 2, 3
```
  - For more, see the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L859).

#####mlib.math.getSummation
- Gets the summation of numbers. 
- Synopsis: 
  - `summation = mlib.math.getSummation( start, stop, func )`
- Arguments: 
  - `start`: Number. The number at which to start the summation.
  - `stop`: Number. The number at which to stop the summation.
  - `func`: Function. The method to add the numbers.
    - Arguments: 
	  - `i`: Number. Index.
	  - `previous`: Table. The previous values used. 
- Returns: 
  - `Summation`: Number. The summation of the numbers.
  - For more, see the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L896).  

#####mlib.math.isPrime
- Checks if a number is prime. 
- Synopsis: 
  - `isPrime = mlib.math.isPrime( x )`
- Arguments: 
  - `x`: Number. The number to check if it's prime. 
- Returns: 
  - `isPrime`: Boolean. 
    - `true` if the number is prime. 
	- `false` if the number is not prime. 

#####mlib.math.round
- Rounds a number to the given decimal place. 
- Synopsis: 
  - `rounded = mlib.math.round( number, [place] )
- Arguments: 
  - `number`: Number. The number to round. 
  - `place (1)`: Number. The decimal place to round to. Defaults to 1. 
- Returns: 
  - The rounded number. 
  - For more, see the [specs](https://github.com/davisdude/mlib/blob/master/spec.lua#L880).

##License
A math library made in Lua
copyright (C) 2014 Davis Claiborne
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
Contact me at davisclaib at gmail.com
