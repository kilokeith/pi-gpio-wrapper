## Information

<table>
<tr> 
<td>pi-gpio</td><td>Evented pin class wrapper</td>
</tr>
<tr>
<td>Description</td>
<td>Wraps pi-gpio (which uses gpio-admin cli) to add events and promises.</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.10</td>
</tr>
</table>

## Usage

```coffee-script
led1 = new Pin {name: 'led1', pin: 11, direction: 'output'}
btn = new Pin {name: 'btn', pin: 7, direction: 'input'}

Q.all([ led1.promise, btn.promise ]).then () ->
	console.log 'all pins ready!'
	#call watch to startup read interval
	btn.watch()
	#add a change event listener
	btn.on 'change', (val) ->
		unless val is 0
			console.log 'btn pressed', val, state
			led1.write(1)
			setTimeout () ->
				led1.write(0)
			, 1000


process.on 'SIGINT', ->
	led1.write(0).then ->
		Q.all([ btn.close(), led1.close() ]).then () ->
			process.exit()
```

## LICENSE

(MIT License)

Copyright (c) 2014 Keith Hoffmann <keith@theuprisingcreative.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
