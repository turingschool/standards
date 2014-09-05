Feature: CRUD for standards

  I give a shit about student education,
  so I want to make sure they're learning the right things,
  so I'm going to add/view/organize/edit/delete standards
  and generate webpages for them and such

  Background:
    Given I have not previously defined standards

  Scenario: Add a Standard
    When I run "standards add 'SW know that find is a method used on collections.' ruby enumerable"
    Then stderr is empty
    Then the exit status is 0
    And  stdout is the JSON:
    """
    { "id":       1,
      "standard": "SW know that find is a method used on collections.",
      "tags":     ["ruby", "enumerable"]
    }
    """
    And I have a standard "SW know that find is a method used on collections.", with tags ["ruby", "enumerable"]

  Scenario: Adding multiple Standards increments the ids
    When I run "standards add 's1'"
    Then stdout is the JSON '{ "id": 1, "standard": "s1", "tags": [] }'
    When I run "standards add 's2'"
    Then stdout is the JSON '{ "id": 2, "standard": "s2", "tags": [] }'

  Scenario: Successfully query the standards
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

  Scenario: Generating a site
    Given I have not previously defined standards
    When I run "standards add 'some standard'"
    And  I run "standards generate"
    Then stderr is empty
    Then the exit status is 0
    And  stdout includes "html"
