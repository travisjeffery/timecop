= timecop

* http://github.com/jtrupiano/timecop

== DESCRIPTION:

A gem providing simple ways to mock Time.now, Date.today, and DateTime.now.  It provides "time travel" and "time freezing" capabilities, making it dead simple to write test time-dependent code.

== FEATURES:

* Temporarily (or permanently if you prefer) change the concept of Time.now, DateTime.now, and Date.today
* Timecop api allows an arguments to be passed into #freeze and #travel as one of: 1) Time instance, 2) DateTime instance, 3) Date instance,
  4) individual arguments (year, month, day, hour, minute, second)
* Nested calls to Timecop#travel and Timecop#freeze are supported -- each block will maintain it's interpretation of now.

== SHORTCOMINGS:

* Only fully tested on the 1.8.6 Ruby implementations.  1.8.7 and 1.9.1 should be tested, as well as other flavors (jruby, etc.)

== SYNOPSIS:

* Run a time-sensitive test:
<code>
  joe = User.find(1)
  joe.purchase_home()
  assert !joe.mortgage_due?
  # move ahead a month and assert that the mortgage is due
  Timecop.freeze(Date.today + 30) do
    assert joe.mortgage_due?
  end
</code>

* Set the time for the test environment of a rails app -- this is particularly helpful if your whole application
  is time-sensitive.  It allows you to build your test data at a single point in time, and to move in/out of that
  time as appropriate (within your tests)
  
in config/environments/test.rb

<code>
config.after_initialize do
  # Set Time.now to September 1, 2008 10:05:00 AM
  t = Time.local(2008, 9, 1, 10, 5, 0)
  Timecop.travel(t)
end
</code>

== REQUIREMENTS:

* None

== INSTALL:

* sudo gem install timecop (latest stable version from rubyforge)
* sudo gem install jtrupiano-timecop (HEAD of the repo from github)

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
