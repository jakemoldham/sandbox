namespace :jira do
  
  desc "Connect to Jira and login"
  task :connect => :environment do |t|
    require "#{Rails.root}/lib/jira_client.rb"

    response = Typhoeus::Request.get("http://ringseven.atlassian.net/rest/api/2/", headers: {Authorization: "amFrZW1vbGRoYW06SHUzM2VyMDg=", Data: "gzip", Content: "application/json;charset=UTF-8"})
    jc = JiraClient.new("http://ringseven.atlassian.net/rest/api/2/")
    project = jc.latest('issues', {})
    project
  end
end

    # options = {proxy: 'http://ringseven.atlassian.net/rest/api/2/issue/VIR-1082', proxyuserpwd: 'amFrZW1vbGRoYW06SHUzM2VyMDg='}
    # req = Typhoeus::Request.new(url, options)
    # hydra = Typhoeus::Hydra.hydra
    # hydra.queue(request)
    # hydra.run

    # projectID = options.post('Project', 
    #   {'name' => Time.now.strftime('My Ruby Project created at %I:%M%p'), 
    #   'description' => 'Sample project' })['ID']
      
    #   client = JIRA::Client.new(options)

    #   # Show all projects
    #   projects = client.Project.all

    #   projects.each do |project|
    #     puts "Project -> key: #{project.key}, name: #{project.name}"
    #   end



  #   require 'rest_client'
  #   require 'json'

  #   project_key = ""
  #   jira_url = "jakemoldham:Hu33er08 https://ringseven.atlassian.net/rest/api/latest/issue/VIR-1082"
  #   # latest 5 issues from a project with 'Major' priority
  #   filter = "maxResults=5&fields=summary,status,resolution&jql=project+%3D+%22#{project_key}%22+AND+priority+%3D+%22Major%22"

  #   response = RestClient.get("#{jira_url}+#{filter}")
  #   if(response.code != 200)
  #     raise "Error with the http request!"
  #   end

  #   data = JSON.parse(response.body)
  #   data['issues'].each do |issue|
  #     puts "Key: #{issue['key']}, Summary: #{issue['fields']['summary']}"
  #   end
  # end 

  # use OmniAuth::Builder do
  # provider :JIRA, 
  #   "<consumer_key>", 
  #   OpenSSL::PKey::RSA.new(IO.read(File.dirname(__FILE__) + "<PRIVATE_KEY_FILE>")),
  #   :client_options => { :site => "<http://jira.url>" }
  # end



  # @callback_url = "http://127.0.0.1:3000/oauth/callback"
  # @consumer = OAuth::Consumer.new("key","secret", :site => "ttp://ringseven.atlassian.net/rest/api/2/issue/VIR-1082")@request_token = @consumer.get_request_token(:oauth_callback => @callback_url)


  # session[:request_token] = @request_token
  # redirect_to @request_token.authorize_url(:oauth_callback => @callback_url)


  # @access_token = @request_token.get_access_token
  # @photos = @access_token.get('/photos.xml')


  # require 'oauth/request_proxy/typhoeus_request'
  # oauth_params = {:consumer => oauth_consumer, :token => access_token}
  # hydra = Typhoeus::Hydra.new
  # req = Typhoeus::Request.new(uri, options) 
  # oauth_helper = OAuth::Client::Helper.new(req, oauth_params.merge(:request_uri => uri))
  # req.headers.merge!({"Authorization" => oauth_helper.header}) # Signs the request
  # hydra.queue(req)
  # hydra.run
  # @response = req.response