Feature: Donation Intent

  Background:
    Given I am on https://staging.dimegiving.com/demo

  Scenario: Fill out donation wizard
    When I fill in amount with 123
    And I click the "Next" button
    Then I should see text "Enter your phone number below"
    When I fill in "phone_number" with "7274850700"
    And I click the "Send code" button
    Then I should see text "To continue, please enter the 6-digit verification code"

