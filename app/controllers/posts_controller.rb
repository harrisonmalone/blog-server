require 'open-uri'

class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    render json: sorted_by_date_posts
  end

  def show
    url = @post.presigned_url(:get)
    body = URI.open(url).read
    title =  handle_title(@post)
    render json: { title: title, body: body, date: @post.data.last_modified }
  end

  private 

  def set_post
    @post = BUCKET.objects.find do |obj|
      obj.key == "#{params[:id]}.txt"
    end
  end

  def sorted_by_date_posts
    posts = []
    BUCKET.objects.each do |obj|
      title =  handle_title(obj)
      date =  obj.data.last_modified
      year = date.to_s[0...4]
      month = date.to_s[5...7]
      posts << { title: title, slug: "#{year}/#{month}/#{obj.key.chomp(".txt")}", date: date }
    end
    posts.sort do |a, b|
      b[:date] <=> a[:date]
    end
  end

  def handle_title(post) 
    words = post.key.split("-")
    if words[0][0] != "_"
      words = words.map { |word| word.capitalize }
    end
    words.join(" ").chomp(".txt").tr("_", "")
  end
end
