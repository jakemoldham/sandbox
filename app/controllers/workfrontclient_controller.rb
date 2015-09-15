class WorkfrontclientController < ApplicationController
  require "#{Rails.root}/lib/stream_client.rb"

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :login

  include StreamClient

  def login
    sc = StreamClient.new("https://ringseven.attask-ondemand.com/attask/api")
    sc.login(ENV['WORKFRONTUSER'],ENV['WORKFRONTPASSWORD'])
  end

end
