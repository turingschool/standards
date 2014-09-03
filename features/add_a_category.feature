Feature: CRUD for standards

  I give a shit about student education,
  so I want to make sure they're learning the right things,
  so I use the tool to manipulate the data (add/view/organize/edit/delete standards)

  Background:
    Given I have not previously defined standards

  Scenario: Add a Standard
    When I run "standards add 'SW know that find is a method used on collections.' --tag ruby --tag enumerable"
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

  Scenario: Successfully query the standards
    Given I have a standard "the standard", with tags ["tag1"]
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
