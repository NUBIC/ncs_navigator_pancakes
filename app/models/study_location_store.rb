class StudyLocationStore
  include Celluloid
  include Store

  def request
    @response ||= Celluloid::Future.new do
      study_locations_file = Pancakes::Application.config.services[:study_locations_file]
      data = JSON.parse(File.read(study_locations_file))

      data['study_locations'].map { |l| StudyLocation.new(l) }.freeze
    end
  end
end
