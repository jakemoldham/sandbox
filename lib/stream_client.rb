require 'net/http'
require 'uri'
require 'json' # run 'gem install json'
require 'openssl'

class StreamClient

  OBJCODE_GROUP   = "GROUP"
  OBJCODE_PROJECT = "PROJ"
  OBJCODE_TASK    = "TASK"

  PATH_LOGIN  = "/login";
  PATH_LOGOUT = "/logout";
  PATH_SEARCH = "/search";

  
  def initialize(apiURL)
    @apiURL = apiURL
    @sessionID = nil
    @userID = nil;
  end
  
  def userID
    @userID
  end
  
  def login(username, password)
    data = request(PATH_LOGIN, 
        {'username' => username, 'password' => password}, nil, "GET")
    @sessionID = data['sessionID']
    @userID = data['userID']
  end
  
  def logout
    request(PATH_LOGOUT, {'sessionID' => @sessionID}, nil, "GET")
    @sessionID = nil
    @userID = nil
  end

  def search(objCode, query, fields=nil)
    request("/#{objCode}#{PATH_SEARCH}", query, fields, "GET")
  end
  
  def getList(objCode, ids, fields=nil)
    request("/#{objCode}", {'id' => ids.join(',')}, fields, "GET")
  end

  # create
  def post(objCode, message, fields=nil)  
    request("/#{objCode}", message, fields, "POST")
  end
  
  # update
  def put(objCode, objID, message, fields=nil)  
    request("/#{objCode}/#{objID}", message, fields, "PUT")
  end

  # retrieve
  def get(objCode, objID, fields=nil)
    request("/#{objCode}/#{objID}", nil, fields, "GET")
  end
  
  # delete
  def delete(objCode, objID, force=false)  
    request("/#{objCode}/#{objID}", {'force' => force}, nil, "DELETE")
  end
  
  private
  
  def request(path, params, fields, method)
    url = URI.parse(@apiURL + path)
    
    # Send HTTP method type as a parameter.
    if (!params)
      params = {}
    end
    params['method'] = method
    params['sessionID'] = @sessionID
    
    if (fields)
      params['fields'] = fields.join(',')
    end
    
    http = Net::HTTP.new(url.host, url.port)
    if (/^https/.match(@apiURL))
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    req = Net::HTTP::Post.new(url.request_uri)
    req.set_form_data(params)
    res = http.request(req)
    
    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        data = JSON(res.body)['data'] #convert the response to a map
      else
        puts res.body
        res.error!
    end
    data
  end  
end

begin
  
  sc = StreamClient.new("https://ringseven.attask-ondemand.com/attask/api")
  sc.login(ENV['WORKFRONTUSER'], ENV['WORKFRONTPASSWORD'])
  
  # Create some objects
  groupID = sc.post('GROUP', 
      {'name' => Time.now.strftime('My Ruby Group created at %I:%M%p'), 
      'description' => 'Sample group'})['ID']
  projectID = sc.post('PROJ', 
      {'name' => Time.now.strftime('My Ruby Project created at %I:%M%p'), 
      'description' => 'Sample project', 
      'groupID' => groupID, 'ownerID' => sc.userID})['ID']
  taskID = sc.post('TASK', 
      {'name' => Time.now.strftime('My Ruby Task created at %I:%M%p'), 
      'description' => 'Sample description', 'projectID' => projectID})['ID']
  taskID2 = sc.post('TASK', 
      {'name' => Time.now.strftime('My Second Ruby Task created at %I:%M%p'), 
      'description' => 'Sample description', 'projectID' => projectID})['ID']

  # Update the task
  sc.put('TASK', taskID, 
      {'extRefID' => '123456', 'status' => 'INP', 'assignedToID' => sc.userID})
  
  # Get the updated task, including some extra fields
  taskJSON = sc.get('TASK', taskID, ['assignments', 'status', 'extRefID'])
  assignmentJSON = taskJSON['assignments'][0]
  puts "Task Reference Number: #{taskJSON['extRefID']}"

  # get tasks by ID
  taskList = sc.getList('TASK', [taskID, taskID2])

  # get tasks by doing a search
  taskList = sc.search('TASK', 
      {'extRefID' => '123456', 'projectID' => projectID}, nil)
  taskJSON = taskList[0]
  puts "Task Name: #{taskJSON['name']}"

rescue Exception => e
  puts e
end

sc.delete('TASK', taskID) # can't delete tasks by force
sc.delete('PROJ', projectID, true)
sc.delete('GROUP', groupID, true)

sc.logout()
