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

  Scenario: A search cannot be triggered without a date range
    When I start an event search with the parameters
      | event type | Pre-Pregnancy Visit |
      | done by    | arl012              |

    Then I cannot start a search

  Scenario: A search with no end date can be executed
    When I start an event search with the parameters
      | event type | Pre-Pregnancy Visit |
      | start date | 2013-06-01          |
      | done by    | arl012              |

    Then I can start a search

  Scenario: New searches have adjustable study location scope
    When I start an event search
    And I uncheck "Baz"

    Then my search involves the study locations
      | name   | will search |
      | Bar    | yes         |
      | Baz    | no          |
      | Foo    | yes         |

  Scenario: When a search is started, its progress is updated
    Given I start an event search with the parameters
      | event type | Pre-Pregnancy Visit |
      | event type | Pregnancy Visit 1   |
      | start date | 04/01/2013          |
      | end date   | 04/14/2013          |
      | done by    | arl012              |
      | done by    | fcr456              |
      | location   | Foo                 |
      | location   | Bar                 |
      | location   | Baz                 |

    When I click "Search"

    Then I see progress updates for
      | Bar |
      | Baz |
      | Foo |

  @all-locations-ok
  Scenario: When the search completes, its results are displayed
    When I start an event search with the parameters
      | event type | Pre-Pregnancy Visit |
      | event type | Pregnancy Visit 1   |
      | start date | 04/01/2013          |
      | end date   | 04/14/2013          |
      | done by    | arl012              |
      | done by    | fcr456              |
      | location   | Foo                 |
      | location   | Bar                 |
      | location   | Baz                 |
    And I click "Search"

    Then I see search results

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
