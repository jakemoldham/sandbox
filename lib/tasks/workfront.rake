#include StreamClient

desc "Connect to Work Front and login"
task :connect => :environment do |t|
require "#{Rails.root}/lib/stream_client.rb"  

  sc = StreamClient.new("https://ringseven.attask-ondemand.com/attask/api")
  sc.login(ENV['WORKFRONTUSER'], ENV['WORKFRONTPASSWORD'])
  projects = sc.search('PROJECT', {})
   projects.each do |p|
    wfp = Workfrontproject.new
     wfp.work_front_project_id = p['ID']
     wfp.name = p['name']
     wfp.objCode = p['objCode']
     wfp.percentComplete = p['percentComplete']
     wfp.plannedCompletionDate = p['plannedCompletionDate']
     wfp.plannedStartDate = p['plannedStartDate']
     wfp.projectedCompletionDate = p['projectedCompletionDate']
     wfp.status = p['status']
     wfp.priority = p['priority']
     wfp.save
     puts wfp.name + " was saved"

     tasks = sc.search('TASK', {'projectID' => p['ID']} )
     tasks.each do |t|
      wft = Workfronttask.new
        wft.workfront_id = t['ID']
        wft.name = t['name']
        wft.objCode = t['objCode']
        wft.percentComplete = t['percentComplete']
        wft.plannedCompletionDate = t['plannedCompletionDate']
        wft.plannedStartDate = t['plannedStartDate']
        wft.priority = t['priority']
        wft.progressStatus = t['progressStatus']
        wft.projectedCompletionDate = t['projectedCompletionDate']
        wft.projectedStartDate = t['projectedStartDate']
        wft.status = t['status']
        wft.taskNumber = t['taskNumber']
        wft.wbs = t['wbs']
        wft.workTequired = t['workRequired']
        wft.save
        puts wft.name + " was saved"
    end
  end
end
