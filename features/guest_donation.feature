Feature: Guest Donation

  Background:
    Given I am on http://staging.dimegiving.com/demo/guest

  Scenario: Make a donation from a random fake persona
    And I fill in amount with a random number
    And I fill in the credit card fields
    And I fill in the form with fake data
    And I submit
    Then I should see text "Thank you for your donation"
    Then The test passes if I see text "Thank you for your donation"