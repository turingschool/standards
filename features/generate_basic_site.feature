Feature: Render basic HTML for the standards

  We want students to be able to see the standards.
  To accomodate this, we generate a static site from
  the standards.

  Scenario: Generating a site
    Given I have not previously defined standards
    When I run "standards add 'some standard'"
    And  I run "standards generate"
    Then stderr is empty
    Then the exit status is 0
    And  stdout includes "html"
