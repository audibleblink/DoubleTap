FROM audibleblink/ruby_phantom

WORKDIR /app
VOLUME /app
ENTRYPOINT ["ruby", "lib/main.rb"]
