Feature: Using the binary

  Interacting with the standards file through the binary.

  Background:
    Given I have not previously defined standards

  Scenario: Help screen
    When I run "standards help"
    Then stderr is empty
    And  the exit status is 0
    And  stdout includes "Usage"

  Scenario: Adding Standards
    When I run "standards add 'SW know that find is a method used on collections.' ruby enumerable"
    Then stderr is empty
    And  the exit status is 0
    And  stdout is the JSON '{ "id": 1, "standard": "SW know that find is a method used on collections.", "tags": ["ruby", "enumerable"] }'
    And  I have a standard "SW know that find is a method used on collections.", with tags ["ruby", "enumerable"]

    When I run "standards add s2"
    Then stderr is empty
    And  stdout is the JSON '{ "id": 2, "standard": "s2", "tags": [] }'
    And  I have a standard "s2", with tags []

  Scenario: Querying the standards
    Given I have previously added "the standard", with tags ["tag1"]
    When I run "standards select tag:tag1"
    Then stderr is empty
    And  stdout is the JSON:
    """
    [{ "id":       1,
       "standard": "the standard",
       "tags":     ["tag1"]
    }]
    """
    And  the exit status is 0

  Scenario: Standards file passed in --file
    Given there is no file "from-long-flag.json"
    When I run "standards --file from-long-flag.json add s1"
    Then stderr is empty
    And  the exit status is 0
    And  I see the file "from-long-flag.json"

  Scenario: Standards file passed with -f
    Given there is no file "from-short-flag.json"
    When I run "standards -f from-short-flag.json add s1"
    Then stderr is empty
    And  the exit status is 0
    And  I see the file "from-short-flag.json"

  Scenario: Standards file set by env var
    Given there is no file "from-env.json"
    Given the environment variable "STANDARDS_FILEPATH" is set to "from-env.json"
    When  I run "standards add s1"
    Then  stderr is empty
    And   the exit status is 0
    And   I see the file "from-env.json"

  Scenario: Standards file not set in env var or passed in flag
    Given the environment variable "STANDARDS_FILEPATH" is not set
    When  I run "standards add s1"
    Then  stderr includes "STANDARDS_FILEPATH"
    And   the exit status is 1

  Scenario: Standards file prefers flag over env var
    Given the environment variable "STANDARDS_FILEPATH" is set to "from-env.json"
    And   there is no file "from-env.json"
    And   there is no file "from-flag.json"
    When  I run "standards --file from-flag.json add s1"
    And   I see the file "from-flag.json"
    And   I do not see the file "from-env.json"

  Scenario: Generating a site
    Given I have not previously defined standards
    When I run "standards add 'some standard'"
    And  I run "standards webpage"
    Then stderr is empty
    And  the exit status is 0
    And  stdout includes "<!doctype html>"

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
