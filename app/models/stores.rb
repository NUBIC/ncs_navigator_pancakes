class Stores < Celluloid::SupervisionGroup
  supervise EventTypeStore, :as => :event_types_store
  supervise DataCollectorStore, :as => :data_collectors_store

  def self.event_types
    Celluloid::Actor[:event_types_store]
  end

  def self.data_collectors
    Celluloid::Actor[:data_collectors_store]
  end

  def self.reload
    event_types.reload
  end
end
