verify = -> h do
  h.keys.each do |k|
    v = h[k]

    if v.respond_to?(:keys) && v.respond_to?(:[])
      verify[v]
    else
      raise "Expected configuration for service #{k}" if v.blank?
    end
  end
end

if Pancakes.app_server?
  verify[Pancakes::Application.config.services]
end
