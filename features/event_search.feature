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

# vim:ts=2:sw=2:et:tw=78
