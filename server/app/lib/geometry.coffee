# methods taken from cocos2d-js core

module.exports =

  # Helper function that creates a cc.Point.
  # @function
  # @param {Number|cc.Point} x a Number or a size object
  # @param {Number} y
  # @return {cc.Point}
  # @example
  # var point1 = cc.p();
  # var point2 = cc.p(100, 100);
  # var point3 = cc.p(point2);
  # var point4 = cc.p({x: 100, y: 100});
  p: (x, y)->
    return {x: 0, y: 0} unless x?
    return {x: x.x, y: x.y} unless y?

    {x: x, y: y}

  # Calculates difference of two points.
  # @param {cc.Point} v1
  # @param {cc.Point} v2
  # @return {cc.Point}
  pSub: (v1, v2)->
    @.p(v1.x - v2.x, v1.y - v2.y)

  # Calculates dot product of two points.
  # @param {cc.Point} v1
  # @param {cc.Point} v2
  # @return {Number}
  pDot: (v1, v2)->
    v1.x * v2.x + v1.y * v2.y

  # Calculates the square length of a cc.Point (not calling sqrt() )
  # @param  {cc.Point} v
  # @return {Number}
  pLengthSQ: (v)->
    @.pDot(v, v)

  # Calculates distance between point an origin
  # @param  {cc.Point} v
  # @return {Number}
  pLength: (v)->
    Math.sqrt(@.pLengthSQ(v))

  # Calculates the distance between two points
  # @param {cc.Point} v1
  # @param {cc.Point} v2
  # @return {Number}
  pDistance: (v1, v2)->
    @.pLength(@.pSub(v1, v2))

  # Converts a vector to radians.
  # @param {cc.Point} v
  # @return {Number}
  pToAngle: (v)->
    Math.atan2(v.y, v.x)

  # Converts a radians to degrees.
  # @param {Number} radians
  # @return {Number}
  radiansToDegrees: (radians)->
    radians * 180 / Math.PI