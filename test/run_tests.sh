#!/bin/sh

echo "\033[1;81m Running test_time_stack_item...\033[0m"
ruby -I../lib test_time_stack_item.rb || (echo "FAILED!!!!!!!!!!!!")

echo "\033[1;81m Running test_timecop_without_date...\033[0m"
ruby -I../lib test_timecop_without_date.rb || (echo "FAILED!!!!!!!!!!!!")

echo "\033[1;81m Running test_timecop_without_date_but_with_time...\033[0m"
ruby -I../lib test_timecop_without_date_but_with_time.rb || (echo "FAILED!!!!!!!!!!!!")

echo "\033[1;81m Running test_timecop...\033[0m"
ruby -I../lib test_timecop.rb || (echo "FAILED!!!!!!!!!!!!")
