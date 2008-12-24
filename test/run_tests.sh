#!/bin/sh

echo "\033[1;81m Running test_timecop_internals...\033[0m"
ruby test_timecop_internals.rb || (echo "FAILED!!!!!!!!!!!!")

echo "\033[1;81m Running test_timecop_without_date...\033[0m"
ruby test_timecop_without_date.rb || (echo "FAILED!!!!!!!!!!!!")

echo "\033[1;81m Running test_timecop...\033[0m"
ruby test_timecop.rb || (echo "FAILED!!!!!!!!!!!!")
