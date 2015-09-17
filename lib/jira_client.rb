require 'rubygems'
require 'net/http'
require 'json'

class JiraClient
  jira_url = "http://jira.atlassian.com/rest/api/latest/issue/"
  pswd_tokn = , (headers: {Authorization: "amFrZW1vbGRoYW06SHUzM2VyMDg=", Data: "gzip", Content: "application/json;charset=UTF-8"})
  issue_keys = %w[VP-1 VP-2 VP-51]
  json_ext = ".json"

  for issue in issue_keys

  response = Net::HTTP.get_response(URI.parse(jira_url + issue + json_ext + pswd_tokn))


    if response.code =~ /20[0-9]{1}/
      data = JSON.parse(response.body)
      fields = data.keys

      puts "Output for issue " + issue

      puts "issue reporter: "
      puts data["fields"]["reporter"]["value"].values[0]

      puts "issue summary: "
      puts data["fields"]["summary"].values[1]

      puts "issue description: "
      puts data["fields"]["description"].values[1]

      # uncomment the two lines below to see a prettified version of the json
      # puts "Here is prettified JSON data: "
      # puts JSON.pretty_generate(data)

      # puts "\n"#extra line feed for readability
    else
      raise StandardError, "Unsuccessful response code " + "#{response.code}" + " for issue " + "#{issue}"
    end
  end
end




# require 'rest_client'
# require 'json'

# project_key = "ABC"
# jira_url = "http://username:password@jira.company.com/rest/api/2/search?"
# # latest 5 issues from a project with 'Major' priority
# filter = "maxResults=5&fields=summary,status,resolution&jql=project+%3D+%22#{project_key}%22+AND+priority+%3D+%22Major%22"

# response = RestClient.get(jira_url+filter)
# if(response.code != 200)
#   raise "Error with the http request!"
# end

# data = JSON.parse(response.body)
# data['issues'].each do |issue|
#   puts "Key: #{issue['key']}, Summary: #{issue['fields']['summary']}"
# end