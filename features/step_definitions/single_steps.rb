require 'faker'

When /^I fill in "([^\"]*)" found by "([^\"]*)" with "([^\"]*)"$/ do |value, _type, keys|
  fill_in(value, with: keys)
end

When('I fill in {string} with {string}') do |field, value|
  fill_in(field, with: value)
end

When /^I fill in amount with ([^\"]*)$/ do |keys|
  find('label', text: 'Other').click
  if keys == 'a random number'
    amount = rand(120)
  else
    amount = keys
  end
  fill_in 'Amount', with: amount
end

When /^I submit$/ do
  # find_field('submit').native.send_key(:enter)
  find('input[type=submit]').click
end

When('I click the {string} button') do |label|
  click_button label, wait: 10
end

When ('I fill in the form with fake data') do
  fill_in 'Email', with: Faker::Internet.email
  fill_in 'First name', with: Faker::Name.first_name
  fill_in 'Last name', with: Faker::Name.last_name
  fill_in 'Street address', with: Faker::Address.street_address
  fill_in 'City', with: Faker::Address.city
  select Faker::Address.state, from: 'State'
  fill_in 'Zip', with: Faker::Address.zip_code
  fill_in 'Phone number', with: Faker::PhoneNumber.cell_phone
end

When 'I fill in the credit card fields' do
  fluid_pay_frame = find('#tokenizerCard iframe')
  within_frame fluid_pay_frame do
    # Click on Credit Card option
    # find('.payment .selection .item', text: 'Credit Card').click
    # Fill the Credit Card Details
    form = find('.payment .form .card')
    within form do
      find('.cc-input').set("4111111111111111")
      find('.exp-input').set("11/22")
      find('.cvv-input').set('222')
    end
  end
end

Then /^I should see title "([^\"]*)"$/ do |title|
  expect(page).to have_title title
end

Then('I should see text {string}') do |string|
  # expect(page).to have_text string
  assert_text string, wait: 30
end

Then('The test passes if I see text {string}') do |string|
  # expect(page).to have_text string
  driver = Capybara.drivers[:browserstack]&.call
  if driver.present?
    status = page.has_text?(string) ? "passed" : "failed"
    driver.execute_script(%Q{browserstack_executor: {"action": "setSessionStatus", "arguments": {"status":"#{status}"}}})
  end
end