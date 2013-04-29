require 'pancakes/cas_https_client'

##
# A StudyLocation represents a Cases instance.
class StudyLocation < Model
  include Pancakes::CasHttpsClient

  attr_reader :name
  attr_reader :url

  alias_method :id, :url

  def self.all
    Stores.study_locations.all
  end

  def initialize(config = {})
    super

    @name = config['name']
    @url = config['url']
  end

  def connection(pgt)
    yield client(:url => url, :pgt => pgt)
  end

  def valid?
    !!(name && url)
  end

  def persisted?
    !new_record?
  end

  def attributes
    super.merge(name: name, url: url)
  end
end

# vim:ts=2:sw=2:et:tw=78
