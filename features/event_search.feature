Feature: Event search
  In order to efficiently schedule work
  Study coordinators
  Need to be able to view events scheduled across many Cases instances.

  Scenario: New searches default to all study locations
    When I start an event search

    Then all study locations are selected

# vim:ts=2:sw=2:et:tw=78
