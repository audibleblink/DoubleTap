require 'capybara/poltergeist'

class DoubleTap
  attr_reader :browser
  attr_accessor :user_agent

  DEAFULT_UA = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) ' +
    'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36'

  def initialize( user_agent: DEAFULT_UA,
                  jitter: {min: 1, max: 3},
                  user: 'user.list',
                  pass: 'pass.list' )
    @jitter     = jitter
    @users      = parse_file( user )
    @passwords  = parse_file( pass )
    @user_agent = user_agent
    @browser    = build_browser
  end

  def login_flow(user:, pass:)
    raise 'This is just a core module. You must inherit this into your own ' +
      "module and define #{__method__} inside of it"
  end

  def valid_login?
    raise 'This is just a core module. You must inherit this into your own ' +
      "module and define #{__method__} inside of it"
  end

  def spray!
    max_attempt = 2
    attempt = 0
    @passwords.each do |pass|
      @users.each do |username|
        attempt += 1
        puts "Trying #{username} with password: #{pass}" if VERBOSE
        begin
          login_flow(user: username, pass: pass)
        rescue => e
          puts e
          attempt >= max_attempt ? next : retry
          next
        end
        puts "FOUND: #{username}:#{pass}" if valid_login?
        attempt = 0
        new_session!
      end
    end
  end

  private def build_browser
    Capybara.register_driver :custom do |app|
      options = {
        timeout: 60,
        phantomjs_options: ['--ignore-ssl-errors=yes'],
        js_errors: false
      }
      Capybara::Poltergeist::Driver.new(app, options)
    end
    browser = Capybara::Session.new(:custom)
    browser.driver.add_header('User-Agent', @user_agent)
    browser
  end

  private def parse_file(filename)
    File.open(filename).readlines.map(&:chomp)
  end

  private def jitter_sleep
    return if @jitter[:max] == 0
    sleeptime = @jitter[:min] + (rand * 1000 % @jitter[:max])
    sleep sleeptime
  end

  private def visit_site
    @browser.visit(@url)
    jitter_sleep
  end

  private def fill_in(form_field_name:, value:)
    @browser.fill_in( form_field_name, with: value )
  end

  private def click_button(button_name:)
    @browser.click_button(button_name)
    jitter_sleep
  end

  private def new_session!
    @browser.driver.reset!
  end

end
