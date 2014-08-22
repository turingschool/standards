Feature: Add a category
  First iteration, we're just getting a tracer bullet going through
  so we can begin seeing how everything fits together.
  We'll flesh these out later

  Scenario: Add a category
    Given the file "definitions/regex.rb":
    """
    Category.new do |category|
      category.title       = "Regular Expressions"
      category.description = "Everything ever!"
    end
    """
    When I run "standards add definitions/regex.rb"
    Then the exit status is 0
    When I run "standards show category title:'Regular Expressions'"
    And  stderr is empty
    Then stdout is the JSON:
    """
    { "title":       "Regular Expressions",
      "description": "Everything ever!"
    }
    """
    And  the exit status is 0
