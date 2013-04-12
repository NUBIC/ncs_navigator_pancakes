After('~@api') do
  visit "#{ENV['CAS_BASE_URL']}/logout"
end
