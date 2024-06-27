# History

## Unreleased

- Calculate travel_offset to align with the precision of argument to Timecop.travel ([#421](https://github.com/travisjeffery/timecop/pull/421))

## v0.9.10

- Make Process.clock_gettime configurable and turned off by default (for backwards compatability) ([#427](https://github.com/travisjeffery/timecop/pull/427))

## v0.9.9

- Add `travelled?` and `scaled?` methods to allow checking if Timecop is in their respective states ([#414](https://github.com/travisjeffery/timecop/pull/414))
- Fix cases with DateTime parse not working right ([#415](https://github.com/travisjeffery/timecop/pull/415))
- Fix another case where DateTime parse not working right ([#417](https://github.com/travisjeffery/timecop/pull/417))
- Support travel and freeze for Process.clock_gettime ([#419](https://github.com/travisjeffery/timecop/pull/419))

## v0.9.8

- Revert Reduce memory usage ([#404](https://github.com/travisjeffery/timecop/pull/404))
- More better support for commercial and week-based date formats([#408](https://github.com/travisjeffery/timecop/pull/408))

## v0.9.7

- Fix `frozen?` to return false when traveling or scaled (TKTK)
- Reduce memory usage ([#404](https://github.com/travisjeffery/timecop/pull/404))
- Better support for commercial and week-based date formats([#406](https://github.com/travisjeffery/timecop/pull/406))

## v0.9.6

- Support other calendars besides the default ([#389](https://github.com/travisjeffery/timecop/pull/389))

## v0.9.5

- Date#strptime Fix %Y issues ([#379](https://github.com/travisjeffery/timecop/pull/379))
- Add Truffleruby support ([#378](https://github.com/travisjeffery/timecop/pull/378))
- Deprecate ruby 2.5 ([#375](https://github.com/travisjeffery/timecop/pull/375))
- Better encapsulation of singleton instance ([#368](https://github.com/travisjeffery/timecop/pull/368))
- Support specifying only dates in Date.parse and Datetime.parse ([#296](https://github.com/travisjeffery/timecop/pull/296))

## v0.9.4

- Add ruby 3.1 support (#288)

## v0.9.3

- Fix returning to previous date after block when `Timecop.thread_safe = true` (#216)
- Fix %s and %Q for Date strptime (#275)
- Fix '%G-%V' for Date strptime (#261)
- Fix default day for strptime (#266)

## v0.9.2

- Make `require 'timecop'` threadsafe (#239)

## v0.9.1

- fix Date.parse when month/year only given (#206)

## v0.9.0

- add thread_safe option (#184)
- in safe mode, when already frozen, allow traveling with no block (#202)
- using Time.travel with a string should AS' Time.zone class (#170)
- fix Timecop being ignored when Date.parse infers year (#171, #158, #133)
