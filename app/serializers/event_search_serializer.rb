class EventSearchSerializer < ActiveModel::Serializer
  def attributes
    object.json.merge('id' => object.id)
  end
end
