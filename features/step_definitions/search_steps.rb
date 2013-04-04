When(/^I start an event search$/) do
  visit '/event_searches/new'
end

Then(/^my search involves the study locations$/) do |table|
  actual = [['name', 'will search']]

  table.hashes.each do |h|
    actual << [h['name'], page.has_checked_field?(h['name']) ? 'yes' : 'no']
  end

  table.diff!(actual)
end
