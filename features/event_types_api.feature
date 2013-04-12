@api
Feature: Event types API
  To permit searching by event types
  The frontend application
  Needs to know what event types exists.

  Background:
    Given I use the credentials "user":"user"
    And Pancakes uses MDES version 3.2

  Scenario: GET /api/v1/event_types.json returns all known event types
    When I GET /api/v1/event_types.json

    Then the response status is 200
    And the response body contains 40 objects under "/event_types"

  Scenario: GET /api/v1/event_types returns an event type name and code
    When I GET /api/v1/event_types.json

    Then the response body satisfies
      | /event_types/0/local_code   | 1                     |
      | /event_types/0/display_text | Household Enumeration |

# vim:ts=2:sw=2:et:tw=78
