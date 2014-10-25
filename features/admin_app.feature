Feature: admin web interface
  This information is inherently hierarchical,
  so we need to display it visually.
  As such, toss a web-front end on,
  you run it locally for the purpose of modifying the standards
  then you'll commit and push them.

  Scenario: Navigating the hierarchy
    # Might be nicer to just parse this diagram than to use these data tables
    # ├─ h1
    # │  ├─ h11
    # │  │  └─ h111(s1, s2, s4)
    # │  └─ h12(s1, s3, s4)
    # └─ h2(s4, s5)
    Given the standards
      | id | standard | tags     |
      | 1  | s1       | [t1]     |
      | 2  | s2       | [t2]     |
      | 3  | s3       | [t3]     |
      | 4  | s4       | [t1, t4] |
      | 5  | s5       | [t4]     |
    And the hierarchies
      | id  | parent_id | name | tags     |
      | 1   |           | h1   | []       |
      | 11  | 1         | h11  | []       |
      | 111 | 11        | h111 | [t1, t2] |
      | 12  | 1         | h12  | [t1, t3] |
      | 2   |           | h2   | [t4]     |

    When I visit the admin page in my browser

    # everything collapsed, I am at the top
    Then I see hierarchies ["h1", "h2"], but not ["h11", "h111", "h2"]

    # NOTE:
    #   "Then I am on..." and "Given I am on..."
    #   Are the same step def. Thus they both assert your location.
    #   The "Given" does not move you, it's only present to re-establish context

    # move down/up
    Given I am on hierarchy "h1"
    When I press "j"
    Then I am on hierarchy "h2"
    When I press "k"
    Then I am on hierarchy "h1"

    # toggle h1 open, move in, move out, toggle it closed
    Given I am on hierarchy "h1"
    When I press "o"
    Then I see hierarchies ["h1", "h11", "h12", "h2"], but not ["h111"]
    And  I press "l"
    Then I am on hierarchy "h11"
    When I press "h"
    Then I am on hierarchy "h1"
    When I press "o"
    Then I see hierarchies ["h1", "h2"], but not ["h11", "h111", "h2"]


    # open a hierarchy with standards
    Given I am on hierarchy "h1"
    And  I do not see any standards
    When I press "j"
    And  I press "o"
    Then I see standards ["s4", "s5"], but not ["s1", "s2", "s3"]
    When I press "o"
    Then I do not see any standards

    # leave multiple hierarchies open at once
    Given I am on hierarchy "h2"
    When I press "o"
    Then I see standards ["s4", "s5"], but not ["s1", "s2", "s3"]
    When I press "k"
    And  I press "o"
    And  I press "l"
    And  I press "j"
    Then I am on hierarchy "h12"
    When I press "o"
    Then I see standards ["s1", "s3", "s4", "s5"], but not ["s2"]
