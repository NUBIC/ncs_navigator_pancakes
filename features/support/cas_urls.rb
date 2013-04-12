module CasUrls
  def cas_base_url
    ENV['CAS_BASE_URL']
  end

  def cas_proxy_callback_url
    ENV['CAS_PROXY_CALLBACK_URL']
  end

  def cas_proxy_retrieval_url
    ENV['CAS_PROXY_RETRIEVAL_URL']
  end
end

Cucumber::Rails::World.send(:include, CasUrls)
