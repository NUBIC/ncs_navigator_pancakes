@api
Feature: Data collectors API
  To permit searching by data collectors
  The frontend application
  Needs to know what data collectors exist.

  Background:
    Given I use the credentials "user":"user"

  Scenario: GET /api/v1/data_collectors returns names and usernames
    The data in this scenario comes from devel/servers/ops_mock.rb.

    When I GET /api/v1/data_collectors.json

    Then the response status is 200
    And the response body satisfies
      | /data_collectors/0/first_name | Curtis |
      | /data_collectors/0/last_name  | Grund  |
      | /data_collectors/0/username   | cvg123 |

# vim:ts=2:sw=2:et:tw=78
