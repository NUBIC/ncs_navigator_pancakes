# BIG IMPORTANT NOTE: These are NOT using Capybara methods.  #get and
# friends are supplied by rack-test.
#
# You MUST NOT introduce Capybaraisms (e.g. #visit, #have_content) into
# these steps.  They won't work and you'll end up very confused.

require 'hana'

Given(/^Pancakes uses MDES version ([\d.]+)$/) do |version|
  put '/api/v1/mdes_version.json', 'mdes_version' => version

  steps %q{
    Then the response status is 204
  }
end

Given(/^I use the credentials "(.*?)":"(.*?)"$/) do |username, password|
  basic_authorize username, password
end

When(/^I GET ([^\s]+)$/) do |path|
  get path
end

Then(/^the response status is (\d+)$/) do |status|
  last_response.status.should == status.to_i
end

Then(/^the response body contains (\d+) objects under "(.*?)"$/) do |count, key|
  json = JSON.parse(last_response.body)
  ptr = Hana::Pointer.new(key)

  ptr.eval(json).length.should == count.to_i
end

Then(/^the response body satisfies$/) do |table|
  json = JSON.parse(last_response.body)

  actual = table.raw.each.with_object([]) do |(key, value), obj|
    ptr = Hana::Pointer.new(key)
    val = ptr.eval(json)

    obj << [key, val.to_s]
  end

  table.diff!(actual)
end
