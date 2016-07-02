require 'rubygems'
require 'bundler'
require "sinatra/reloader"
require 'json'

Bundler.require

Dir.glob('./lib/*.rb') do |model|
  require model
end

module Citibike
	class App < Sinatra::Application
    configure :development do
      register Sinatra::Reloader
    end

    before do
      json = File.open("data/citibikenyc.json").read
      @data = MultiJson.load(json)
    end

    get '/' do
      erb :home
    end

    get '/form' do
      erb :form
    end
    
    post '/form' do
      "You chose #{params["start"]} and #{params["end"]}"
    end

    post '/map' do
      puts params
      start_ary = JSON.parse params[:start]
      end_ary = JSON.parse params[:end]
      @start = start_ary.map {|num| num.to_f / 1000000.0}
      @end = end_ary.map {|num| num.to_f / 1000000.0}
      erb :map
    end

  end
end