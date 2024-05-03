class RequestSerializer
  include JSONAPI::Serializer
  attributes :id,
             :number,
             :description,
             :state,
             :user_id

end