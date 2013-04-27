define [
  'jquery',
  'underscore',
  'backbone',
  'raphael',
  'globals',
  'cs!utils',
  'cs!models/whiteboard_tool'
], ($, _, Backbone, Raphael, globals, Utils, WhiteboardToolModel) ->

  # A line in the whiteboard
  class WhiteboardLineModel extends WhiteboardToolModel

    initialize: (@paper) ->
      super @paper

      # the defintion of this shape, kept so we can redraw the shape whenever needed
      # format: array of points, stroke color, thickness
      @definition = ["", "#000", "0px"]

    # Creates a line in the paper
    # @param  {number} x         the x value of the line start point as a percentage of the original width
    # @param  {number} y         the y value of the line start point as a percentage of the original height
    # @param  {string} colour    the colour of the shape to be drawn
    # @param  {number} thickness the thickness of the line to be drawn
    make: (x, y, colour, thickness) ->
      x1 = x * @gw + @xOffset
      y1 = y * @gh + @yOffset
      path = "M" + x1 + " " + y1 + " L" + x1 + " " + y1
      pathPercent = "M" + x + " " + y + " L" + x + " " + y
      @obj = @paper.path(path)
      @obj.attr Utils.strokeAndThickness(colour, thickness)
      @obj.attr({"stroke-linejoin": "round"})

      @definition =
        shape: "path"
        data: [pathPercent, @obj.attrs["stroke"], @obj.attrs["stroke-width"]]

      @obj

    # Update the line dimensions
    # @param  {number} x  the next x point to be added to the line as a percentage of the original width
    # @param  {number} y  the next y point to be added to the line as a percentage of the original height
    # @param  {boolean} add true if the line should be added to the current line, false if it should replace the last point
    update: (x, y, add) ->
      if @obj?
        x1 = x * @gw + @xOffset
        y1 = y * @gh + @yOffset

        # if adding to the line
        if add
          path = @obj.attrs.path + "L" + x1 + " " + y1
          @obj.attr path: path

        # if simply updating the last portion (for drawing a straight line)
        else
          @obj.attrs.path.pop()
          path = @obj.attrs.path.join(" ")
          path = path + "L" + x1 + " " + y1
          @obj.attr path: path

        pathPercent = "L" + x + " " + y
        @definition.data[0] += pathPercent

    # Draw a line on the paper
    # @param  {string} path      height of the shape as a percentage of the original height
    # @param  {string} colour    the colour of the shape to be drawn
    # @param  {number} thickness the thickness of the line to be drawn
    draw: (path, colour, thickness) ->
      line = @paper.path(Utils.stringToScaledPath(path, @gw, @gh, @xOffset, @yOffset))
      line.attr Utils.strokeAndThickness(colour, thickness)
      line.attr({"stroke-linejoin": "round"})
      line

    # When dragging for drawing lines starts
    # @param  {number} x the x value of the cursor
    # @param  {number} y the y value of the cursor
    dragOnStart: (x, y) ->
      # # find the x and y values in relation to the whiteboard
      # sx = (@paperWidth - @gw) / 2
      # sy = (@paperHeight - @gh) / 2
      # @lineX = x - @containerOffsetLeft - sx + @xOffset
      # @lineY = y - @containerOffsetTop - sy + @yOffset
      # values = [ @lineX / @paperWidth, @lineY / @paperHeight, @currentColour, @currentThickness ]
      # globals.connection.emitMakeShape "line", values

    # As line drawing drag continues
    # @param  {number} dx the difference between the x value from _lineDragStart and now
    # @param  {number} dy the difference between the y value from _lineDragStart and now
    # @param  {number} x  the x value of the cursor
    # @param  {number} y  the y value of the cursor
    dragOnMove: (dx, dy, x, y) ->
      # sx = (@paperWidth - @gw) / 2
      # sy = (@paperHeight - @gh) / 2
      # [cx, cy] = @_currentSlideOffsets()
      # # find the x and y values in relation to the whiteboard
      # @cx2 = x - @containerOffsetLeft - sx + @xOffset
      # @cy2 = y - @containerOffsetTop - sy + @yOffset
      # if @shiftPressed
      #   globals.connection.emitUpdateShape "line", [ @cx2 / @paperWidth, @cy2 / @paperHeight, false ]
      # else
      #   @currentPathCount++
      #   if @currentPathCount < MAX_PATHS_IN_SEQUENCE
      #     globals.connection.emitUpdateShape "line", [ @cx2 / @paperHeight, @cy2 / @paperHeight, true ]
      #   else if @obj?
      #     @currentPathCount = 0
      #     # save the last path of the line
      #     @obj.attrs.path.pop()
      #     path = @obj.attrs.path.join(" ")
      #     @obj.attr path: (path + "L" + @lineX + " " + @lineY)

      #     # scale the path appropriately before sending
      #     pathStr = @obj.attrs.path.join(",")
      #     globals.connection.emitPublishShape "path",
      #       [ Utils.stringToScaledPath(pathStr, 1 / @gw, 1 / @gh),
      #         @currentColour, @currentThickness ]
      #     globals.connection.emitMakeShape "line",
      #       [ @lineX / @paperWidth, @lineY / @paperHeight, @currentColour, @currentThickness ]
      #   @lineX = @cx2
      #   @lineY = @cy2

    # Drawing line has ended
    # @param  {Event} e the mouse event
    dragOnEnd: (e) ->
      # if @obj?
      #   path = @obj.attrs.path
      #   @obj = null # any late updates will be blocked by this
      #   # scale the path appropriately before sending
      #   globals.connection.emitPublishShape "path",
      #     [ Utils.stringToScaledPath(path.join(","), 1 / @gw, 1 / @gh),
      #       @currentColour, @currentThickness ]

  WhiteboardLineModel
