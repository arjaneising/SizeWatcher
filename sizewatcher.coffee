# SizeWatcher, by Arjan Eising 2012. License: MIT. https://github.com/arjaneising/SizeWatcher

# Check for support in a browser.
# Basically just queryselector and getElementsByClassName
checksupport = ->
  return 'getElementsByClassName' of document



if checksupport()
  # Function to be able to bind the 'this' keyword to an event triggered function
  Function.prototype.swBindContext = ->
    callingFunction = this
    scope = arguments[0]

    otherArgs = []
    otherArgs.push arg for arg in [1..arguments.length]

    return (e) ->
      otherArgs.push e
      otherArgs.reverse()
      callingFunction.apply scope, otherArgs


  # Add a class to an element
  HTMLElement.prototype.swAddClass = (className) ->
    if (' ' + this.className + ' ').indexOf(' ' + className + ' ') is -1
      this.className += ' ' + className



  # Remove a class from an element
  HTMLElement.prototype.swRemoveClass = (className) ->
    classToRemove = new RegExp(('(^|\\s)' + className + '(\\s|$)'), 'i')
    this.className = this.className.replace(classToRemove, ' ').replace(/^\s+|\s+$/g, '')





class SizeWatcher
  constructor: (@container = document, options = {}) ->
    @doNothing = not checksupport()
    return false if @doNothing
    @resizeMethod = this.resize.swBindContext(this)
    window.addEventListener 'resize', @resizeMethod, false
    @resizeTimeout = null
    @breakpoints = []

    if typeof @container is 'string'
      @container = document.querySelector @container

    @timerTimeout = options.timerTimeout ? 25
    @boxSize = options.boxSize ? 'auto'



  breakpoint: (from, to, options = {}) ->
    return false if @doNothing
    @breakpoints.push
      from: from
      to: to
      options: options
      prevTrue: false

    this.reallyResize.call this, @breakpoints.length - 1


  destroy: ->
    delete @doNothing
    delete @resizeTimeout
    delete @breakpoints
    window.removeEventListener 'resize', @resizeMethod, false
    delete @resizeMethod


  trigger: ->
    return false if @doNothing
    this.reallyResize.call this


  resize: ->
    return false if @doNothing
    clearTimeout @resizeTimeout if @resizeTimeout
    @resizeTimeout = setTimeout this.reallyResize.swBindContext(this), @timerTimeout


  reallyResize: (index = false) ->
    return false if @doNothing

    # Get the real inner width of the element in question
    if @boxSize is 'border-box' or (@boxSize is 'auto' and @container.nodeName.toLowerCase() is 'body')
      containerWidth = @container.offsetWidth
    else
      containerWidth = parseInt window.getComputedStyle(@container, null).getPropertyValue('width'), 10

    for breakpoint, i in @breakpoints
      continue if index and i isnt index

      # Match = if the breakpoint is in range
      # Run = if the situation is changed since the last resize
      match = false
      run = false

      match = true if breakpoint.from <= containerWidth < breakpoint.to

      # Call the callback functions and add/remove classnames
      if match and not breakpoint.prevTrue
        run = true
        breakpoint.options.enter?.call document, @container, containerWidth

        if breakpoint.options.className?
          @container.swAddClass breakpoint.options.className

      if not match and breakpoint.prevTrue
        run = true
        breakpoint.options.leave?.call document, @container, containerWidth

        if breakpoint.options.className?
          @container.swRemoveClass breakpoint.options.className

      continue unless run

      @breakpoints[i].prevTrue = match

      # Loop over elements that need to be swapped around
      if breakpoint.options.move? and match
        for mover, j in breakpoint.options.move
          to = if mover.to is 'this' then @container else @container.querySelector mover.to
          elms = @container.querySelectorAll mover.selector
          for elm, k in elms
            if mover.before?
              to.insertBefore elm, to.querySelector(mover.before)
            else if mover.after?
              to.insertBefore elm, to.querySelector(mover.after).nextSibling
            else
              to.appendChild elm

      # Order the elements
      if breakpoint.options.order? and match
        for selector, j in breakpoint.options.order
          elms = @container.querySelectorAll selector
          for elm, k in elms
            if selector.indexOf ' ' is -1
              continue if elm.parentNode isnt @container
            @container.appendChild elm

    return


window.SizeWatcher = SizeWatcher