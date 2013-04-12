Given(/^I log in as "(.*?)":"(.*?)"$/) do |username, password|
  visit "#{cas_base_url}/login"
  fill_in 'username', :with => username
  fill_in 'password', :with => password
  click_button 'LOGIN'
end
