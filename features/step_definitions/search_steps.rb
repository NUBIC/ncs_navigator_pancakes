When(/^I start an event search$/) do
  visit '/event_searches/new'
end

When(/^I start an event search with the parameters$/) do |table|
  step "I start an event search"

  table.rows.each do |row|
    case row.first
    when 'event type'
      find('.event-type input').set("#{row.last}\n")
    when 'start date'
      find('.scheduled-date.start input').set(row.last)
    when 'end date'
      find('.scheduled-date.end input').set(row.last)
    when 'done by'
      find('.done-by input').set("#{row.last}\n")
    else raise "Unknown key #{row.first}"
    end
  end
end

Then(/^my search involves the study locations$/) do |table|
  actual = [['name', 'will search']]

  table.hashes.each do |h|
    actual << [h['name'], page.has_checked_field?(h['name']) ? 'yes' : 'no']
  end

  table.diff!(actual)
end
