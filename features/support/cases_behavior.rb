# By default, the Cases mocks simulate processing time and errors.  Apply this
# tag to disable those aspects of the simulation.
#
# On scenario completion, the Cases mock is reset to its mischievous self.
Around('@all-locations-ok') do |scenario, block|
  urls = Stores.study_locations.all.map(&:url)

  begin
    urls.each { |url| `curl -s -X POST --data-binary '' #{url}/_controls/behave` }
    block.call
  ensure
    urls.each { |url| `curl -s -X POST --data-binary '' #{url}/_controls/misbehave` }
  end
end
