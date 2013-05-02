Feature: Event search
  In order to efficiently schedule work
  Study coordinators
  Need to be able to view events scheduled across many Cases instances.

  Background:
    Given I log in as "user":"user"

  Scenario: New searches default to all study locations
    When I start an event search

    Then my search involves the study locations
      | name   | will search |
      | Bar    | yes         |
      | Baz    | yes         |
      | Foo    | yes         |

  Scenario: New searches have adjustable study location scope
    When I start an event search
    And I uncheck "Baz"

    Then my search involves the study locations
      | name   | will search |
      | Bar    | yes         |
      | Baz    | no          |
      | Foo    | yes         |

  Scenario: Clicking "search" tells the user that a search is in progress
    When I start an event search
    And I enter the parameters
      | event type | Pre-Pregnancy Visit |
      | event type | Pregnancy Visit 1   |
      | start date | 04/01/2013          |
      | end date   | 04/14/2013          |
      | done by    | arl012              |
      | done by    | fcr456              |
    And I click "Search"

    Then I see "Search in progress"

  Scenario: Editing the search persists the new parameters
    Given I start an event search with the parameters
      | event type | Pre-Pregnancy Visit |
      | event type | Pregnancy Visit 1   |
      | start date | 04/01/2013          |
      | end date   | 04/14/2013          |
      | done by    | arl012              |
      | done by    | fcr456              |
    And I click "Search"

    When I enter the parameters
      | event type | Two Tier Enumeration |
      | start date | 01/02/2013           |
      | end date   | 02/03/2013           |
    And I click "Search"
    And I refresh the page

    Then I see the search criteria
      | event type | Two Tier Enumeration |
      | start date | 01/02/2013           |
      | end date   | 02/03/2013           |

# vim:ts=2:sw=2:et:tw=78
