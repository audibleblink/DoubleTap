FROM audibleblink/ruby_phantom

WORKDIR /app
VOLUME /app

# if you intend to activate the proxy functionality in the ./doubletap
# file, you may need to OS to trust a custom CA cert. 
ADD burp.pem /usr/local/share/ca-certificates/burp.pem
RUN update-ca-certificates

ENTRYPOINT ["ruby", "lib/main.rb"]
