if defined?(ChefSpec)
  def create_ssl_certificate(name)
    ChefSpec::Matchers::ResourceMatcher.new(:ssl_certificate, :create, name)
  end
end
