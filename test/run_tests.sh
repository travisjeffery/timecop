#!/bin/sh

for f in *_test.rb; do
  ${RUBY:-ruby} -I../lib:. $f 
done

