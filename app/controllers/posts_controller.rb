require 'open-uri'

class PostsController < ApplicationController
  def index
    posts = []
    BUCKET.objects.each do |obj|
      title =  obj.key.split("-").map { |word| word.capitalize }.join(" ").chomp(".txt")
      date =  obj.data.last_modified
      year = date.to_s[0...4]
      month = date.to_s[5...7]
      posts << { title: title, slug: "#{year}/#{month}/#{obj.key.chomp(".txt")}" }
    end
    render json: posts
  end

  def show 
    post = BUCKET.objects.find do |obj|
      obj.key == "#{params[:id]}.txt"
    end
    url = post.presigned_url(:get)
    body = URI.open(url).read
    title =  post.key.split("-").map { |word| word.capitalize }.join(" ").chomp(".txt")
    render json: { title: title, body: body, date: post.data.last_modified }
  end
end
