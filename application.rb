require 'sinatra'
require 'sinatra/json'
require 'bundler'

Bundler.require
require_relative 'task'

DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.finalize
DataMapper.auto_migrate!

get '/api/' do
  erb :index
end

get '/api/tasks' do
  erb :index
  content_type :json

  @tasks = Task.all
  @tasks.to_json
end

get '/api/tasks/:id' do
  content_type :json

  @task = Task.find_by_id(params[:id])
  erb :show
  task.to_json
end

post '/api/tasks' do
  content_type :json

  @task = Task.new params[:task]
  if task.save
    status 201
  else
    status 404
    json task.errors.full_messages
  end
  redirect to '/tasks/#{@task.id}'
end

put '/api/tasks/:id' do
  content_type :json

  @task = Task.get params[:id]
  if task.update params[:task]
    status 200
    json "You updated the task!"
  else
    status 404
    json task.errors.full_messages
  end
  @task.save
  redirect to "/tasks/#{@task.id}"
end

delete '/api/tasks/:id' do
  content_type :json

  task = Task.get params[:id]
  if task.destroy
    status 200
    json "This task was successfully deleted."
  else
    status 404
    json "There was an issue deleting this task."
  end
end
