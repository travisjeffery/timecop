FROM ruby

WORKDIR /timecop

COPY Gemfile .
COPY timecop.gemspec .
COPY lib/timecop/version.rb lib/timecop/version.rb

RUN bundle -j 4

COPY . .

CMD ["bin/console"]
