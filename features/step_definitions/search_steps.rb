Given(/^I start an event search with the parameters$/) do |table|
  step "I start an event search"
  step "I enter the parameters", table
end

When(/^I start an event search$/) do
  visit '/event_searches/new'
end

When(/^I enter the parameters$/) do |table|
  table.raw.each do |key, value|
    case key
    when 'event type'
      find('.event-type input').set("#{value}\n")
    when 'start date'
      find('.scheduled-date.start input').set(value)
    when 'end date'
      find('.scheduled-date.end input').set(value)
    when 'done by'
      find('.done-by input').set("#{value}\n")
    when 'location'
      check value
    else raise "Unknown key #{key}"
    end
  end
end

When(/^the search has a blank date range$/) do
  steps %q{
    When I enter the parameters
      | start date ||
      | end date   ||
  }

  # HACK: selenium-webdriver using Firefox doesn't seem to trigger Ember
  # property updates when fields are cleared.  Sending a backspace character
  # has no effect on field content, but is sufficient to get property updates
  # going.
  find('.scheduled-date.end input').set("\b")
end

Then(/^I can(not)? start a search$/) do |negated|
  if negated
    # NOTE: Capybara 2 treats disabled elements as not present.
    page.should have_no_button('Search')
  else
    page.should have_button('Search')
  end
end

Then(/^I see the search criteria$/) do |table|
  actual = []

  table.raw.each do |key, expected|
    elem = case key
           when 'event type'
             find('.event-type .tag-label', :text => expected).text
           when 'start date'
             find(".scheduled-date.start input").value
           when 'end date'
             find(".scheduled-date.end input").value
           when 'done by'
             find('.done-by .tag-label', :text => expected).text
           else raise "Unknown key #{key}"
           end

    if elem
      actual << [key, elem]
    end
  end

  table.diff!(actual)
end

Then(/^I see progress updates for$/) do |table|
  # stall for a bit to let the status poller catch up
  sleep Capybara.default_wait_time

  actual = all('.status-view').map { |e| [e['data-location-name']] }

  table.diff!(actual)
end

Then(/^my search involves the study locations$/) do |table|
  actual = [['name', 'will search']]

  table.hashes.each do |h|
    actual << [h['name'], page.has_checked_field?(h['name']) ? 'yes' : 'no']
  end

  table.diff!(actual)
end

Then(/^my search spans (\d+) weeks$/) do |num|
  start = find('.scheduled-date.start input').value
  finish = find('.scheduled-date.end input').value

  (Date.parse(finish) - Date.parse(start)).days.should == num.to_i.weeks
end

Then(/^I see search results$/) do
  page.should have_selector('.search-results')
end

Then(/^I see a link for participant "([^"]*)" with$/) do |name, table|
  href = table.hashes.first['href']

  page.should have_link(name, :href => href)
end
