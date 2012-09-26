# SizeWatcher

Manipulate the DOM and call events if the width of the viewport, or one of the element on the page, is between or out of a certain range.

With responsive designs and adaptive layouts it becomes more and more needed to move around certain elements on the page. This can easily be done with SizeWatcher.

## Example

    sizeWatcherObj = new SizeWatcher('body');
    
    sizeWatcherObj.breakpoint(400, 600, {
      className: 'condensed',
      order: ['#second', '#first'],
      enter: function(elm, width) {
        /* performMagic with elm and/or width */
      }
    });
      	

The `new SizeWatcher` class callee initates an element which size needs to be watched.

With the `breakpoint` method you set the certain widths between which everything needs to happen.

For example, the `condensed` class is only present when the width of the `body` elment is between 400 and 600 pixels.

With `order` you specify the selectors in which order the matched elements need to appear in the dom.

Also, the `enter` callback function is called once when the user resizes or rotates the screen and it becomes within range. (The opposite is the `leave` callback, which is called when it becomes out of range.)

## Demo

In the demo folder, you can see the demo.js (or .coffee) with instructions how index.html needs to be transformed.

## API overview

### `SizeWatcher` class

    var sizeWatcherObj = new SizeWatcher(str selector[, obj options]);

Accepts two arguments: the selector of one element (preferrably the `body` or an `#id`), and an optional options object. With the returned object you can call the `breakpoint`, `trigger` and `destroy` methods.

The following options can be used in the `options` object:

* str `boxSize` - can have values `"auto"` (default), `"border-box"` and `"content-box"`. Auto will use border-box width on the `body` element and `content-box` on other elements. Border-box is the width of the box, plus the horizontal padding and border widths. Content-box is the 'inner' width of a box.
* int `timerTimeout` - amount of milliseconds before changes are applied. Defaults to 25ms.


### `breakpoint` method

    sizeWatcherObj.breakpoint(int from, int to[, obj options]);
    
`from` and `to` are the bounds of the range. `from` is checked inclusive, `to` exclusive.

The `options` object can hold the following parameters:

* str `className` - the class name that will be added or removed when in or out of the range.
* arr of strs `order` - array of strings with selectors indicating the order. Will be shuffled around on enter, not on leave.
* function `enter` - callback when the breakpoit becomes in range. Gets as first argument the element specified in the constructor, and second the width of that element.
* function `leave` - callback when the breakpoit becomes out of range. Receives the same arguments as `enter`.
* arr of objects `move` - array with instructions on how to move elements around on the page. The objects in the array can have the following options:
  * str `selector` - which is going to match the elements that need to be swapped.
  * str `to` - to which element the matched element need to be appended / inserted.
  * Either str `after`, str `before` or nothing. The first and second are specified if the element needs to be inserted before or after a selector specified as string. If none of them is specified, it will be appended at the end.
  
### `trigger` method

Can be called if another script on the page modified the DOM and you need to run SizeWatcher again:

    sizeWatcherObj.trigger();
    
### `destroy` method

Can be used to nuke the event. Note that the DOM will remain the same as on the moment you call the function, so the original state will *not* be recovered.

    sizeWatcherObj.destroy();
    delete sizeWatcherObj;

## Browser support

SizeWatchers works only in IE9+ and the regular browsers. It is tested in Chrome and the default Android browser, as well as Safari on iOS5+. Basically every browser that can run mediaqueries, although those are not used in the script.

## License

SizeWatcher is licensed under MIT license. Do whatever you want with it, even selling it or using it in a commercial product or website. But please note that I'm not responsible for any damage caused by this product if you use it.

See also the file LICENSE.