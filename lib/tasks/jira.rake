desc "Connect to Work Front and login"
task :connect => :environment do |t|
  use OmniAuth::Builder do
  provider :JIRA, 
    "<consumer_key>", 
    OpenSSL::PKey::RSA.new(IO.read(File.dirname(__FILE__) + "<PRIVATE_KEY_FILE>")),
    :client_options => { :site => "<http://jira.url>" }
  end
end