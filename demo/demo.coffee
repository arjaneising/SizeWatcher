SizeWatcher = window.SizeWatcher

# The main DIV
sizewatch = new SizeWatcher 'body'

sizewatch.breakpoint 0, 1100
  className: 'condensed'
  order: ['#second', '#first']

sizewatch.breakpoint 1100, Infinity,
  order: ['#first', '#second']

sizewatch.trigger() # Not needed, but can be used after -for example- DOM manipulation.


# The inner DIV
innerSizewatch = new SizeWatcher '#second'
  boxSize: 'border-box'

innerSizewatch.breakpoint 0, 350
  move: [
    {
      selector: 'h2'
      to: 'this'
      after: '.inner-one'
    }
  ]
  order: ['h1', 'p', '.inner-one', 'h2']

innerSizewatch.breakpoint 350, Infinity,
  move: [
    {
      selector: 'h2'
      to: '.inner-one'
      after: 'p'
    }
  ]
  order: ['h1', 'p', '.inner-one']


if 'addEventListener' of document.body
  document.body.addEventListener 'dblclick', ->
    sizewatch.destroy()
    return
  , false