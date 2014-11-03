if defined?(ChefSpec)

  if ChefSpec.respond_to?(:define_matcher)
    # ChefSpec >= 4.1
    ChefSpec.define_matcher :ssl_certificate
  elsif defined?(ChefSpec::Runner) &&
     ChefSpec::Runner.respond_to?(:define_runner_method)
    # ChefSpec < 4.1
    ChefSpec::Runner.define_runner_method :ssl_certificate
  end

  def create_ssl_certificate(name)
    ChefSpec::Matchers::ResourceMatcher.new(:ssl_certificate, :create, name)
  end

end
