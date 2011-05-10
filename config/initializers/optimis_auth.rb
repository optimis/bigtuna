AUTH_CONFIG = YAML.load(File.read("#{Rails.root}/config/optimis_auth.yml"))

OptimisClient::Auth.api_key = AUTH_CONFIG['api_key']
OptimisClient::Auth.host = AUTH_CONFIG['service_url']
OptimisClient::Auth.hydra = Typhoeus::Hydra.new
OptimisClient::Auth.secure = AUTH_CONFIG['secure']
OptimisClient::Auth.stubbed = AUTH_CONFIG['stubbed']
OptimisClient::Auth.stub_user = AUTH_CONFIG['stub_user'] if AUTH_CONFIG['stub_user']

if AUTH_CONFIG['stubbed']
  puts "[NOTICE] Stub all requests to auth serivce!"
end