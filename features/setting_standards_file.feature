Feature: Setting the standards file

  In order for the binary to not know about where to find the standards file
  and what format it is, and so forth, we need to be able to provide that via
  an environment variable or a flag

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

  Scenario: Standards file prefers flag over env var
    Given the environment variable "STANDARDS_FILEPATH" is set to "from-env.json"
    And   there is no file "from-env.json"
    And   there is no file "from-flag.json"
    When  I run "standards --file from-flag.json add s1"
    And   I see the file "from-flag.json"
    And   I do not see the file "from-env.json"

  Scenario: Standards file not set in env var or passed in flag
    Given the environment variable "STANDARDS_FILEPATH" is not set
    When  I run "standards add s1"
    Then  stderr includes "STANDARDS_FILEPATH"
    And   the exit status is 1

  Scenario: Help command does not need a standards file
    Given the environment variable "STANDARDS_FILEPATH" is not set
    When  I run "standards help"
    Then  stderr is empty
    And   the exit status is 0
    And   stdout includes "Usage"
