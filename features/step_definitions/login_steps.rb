Given(/^I log in as "(.*?)":"(.*?)"$/) do |username, password|
  visit "#{ENV['CAS_BASE_URL']}/login"
  fill_in 'username', :with => username
  fill_in 'password', :with => password
  click_button 'LOGIN'
end
