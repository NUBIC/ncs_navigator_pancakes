class Stores < Celluloid::SupervisionGroup
  supervise EventTypeStore, :as => :event_types_store
  supervise DataCollectorStore, :as => :data_collectors_store
  supervise StudyLocationStore, :as => :study_locations_store

  def self.event_types
    Celluloid::Actor[:event_types_store]
  end

  def self.data_collectors
    Celluloid::Actor[:data_collectors_store]
  end

  def self.study_locations
    Celluloid::Actor[:study_locations_store]
  end

  def self.reload
    event_types.reload
    data_collectors.reload
    study_locations.reload
  end
end
