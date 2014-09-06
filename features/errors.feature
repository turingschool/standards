Feature: Using the binary

  Sometimes things go wrong.
  We'd like the program to not totally shit itself when this happens.

  Scenario: Nonexistant command
    When I run "standards not-a-command"
    Then stdout is empty
    And  stderr includes "not-a-command"
    And  the exit status is 1

  Scenario: Some other error
    When I run "standards select invalid-filter"
    Then stdout is empty
    And  stderr includes "invalid-filter"
    And  the exit status is 1
