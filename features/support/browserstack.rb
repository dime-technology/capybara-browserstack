require 'yaml'
require 'selenium/webdriver'
require 'capybara/cucumber'
require 'browserstack/local'

# monkey patch to avoid reset sessions
class Capybara::Selenium::Driver < Capybara::Driver::Base
  def reset!
    @browser.navigate.to('about:blank') if @browser
  end
end

TASK_ID = (ENV['TASK_ID'] || 0).to_i
CONFIG_NAME = ENV['CONFIG_NAME'] || 'single'

CONFIG = YAML.safe_load(File.read(File.join(File.dirname(__FILE__), "../../config/#{CONFIG_NAME}.config.yml")))
CONFIG['user'] = ENV['BROWSERSTACK_USERNAME'] || CONFIG['user']
CONFIG['key'] = ENV['BROWSERSTACK_ACCESS_KEY'] || CONFIG['key']

Capybara.register_driver :browserstack do |app|
  @caps = CONFIG['common_caps'].merge(CONFIG['browser_caps'][TASK_ID])

  # Code to start browserstack local before start of test
  if @caps['browserstack.local'] && @caps['browserstack.local'].to_s == 'true'
    @bs_local = BrowserStack::Local.new
    bs_local_args = { 'key' => (CONFIG['key']).to_s }
    @bs_local.start(bs_local_args)
  end

  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: "https://#{CONFIG['user']}:#{CONFIG['key']}@#{CONFIG['server']}/wd/hub",
                                 desired_capabilities: @caps)
end

Capybara.default_driver = :browserstack
# Capybara.default_driver = :selenium_chrome_headless
Capybara.run_server = false

# Code to stop browserstack local after end of test
at_exit do

  # driver = Capybara.drivers[:browserstack]&.call
  # if driver.present?
  #   status = page.has_text?("Thank you for your donation") ? "passed" : "failed"
  #   driver.execute_script(%Q{browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"#{status}"}}})
  # end

  @bs_local.stop unless @bs_local.nil?
end
