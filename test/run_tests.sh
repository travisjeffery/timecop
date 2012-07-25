#!/bin/sh

# allow user to override interpreter used (for jruby and other
# implementations) by settign the RUBY variable

res=0

echo -e "\033[1;81m Running test_time_stack_item...\033[0m"
${RUBY:-ruby} -I../lib:. test_time_stack_item.rb || (echo -e "FAILED!!!!!!!!!!!!"; res=1)

echo -e "\033[1;81m Running test_timecop_without_date...\033[0m"
${RUBY:-ruby} -I../lib:. test_timecop_without_date.rb || (echo -e "FAILED!!!!!!!!!!!!"; res=1)

echo -e "\033[1;81m Running test_timecop_without_date_but_with_time...\033[0m"
${RUBY:-ruby} -I../lib:. test_timecop_without_date_but_with_time.rb || (echo -e "FAILED!!!!!!!!!!!!"; res=1)

echo -e "\033[1;81m Running test_timecop...\033[0m"
${RUBY:-ruby} -I../lib:. test_timecop.rb || (echo -e "FAILED!!!!!!!!!!!!"; res=1)

exit $res
