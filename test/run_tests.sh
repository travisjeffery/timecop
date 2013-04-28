#!/bin/sh

FAILEDCASES=0
for f in *_test.rb; do
  if ! ${RUBY:-ruby} -I../lib:. $f; then
      FAILEDCASES=`expr "$FAILEDCASES" + 1`
  fi
done
echo "$FAILEDCASES test cases had failures"
exit $FAILEDCASES
