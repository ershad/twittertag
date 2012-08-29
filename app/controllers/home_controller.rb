class HomeController < ApplicationController
require 'json'
require 'set'
require 'open-uri'

  def index
    @num_counts = []
    if params[:handle] and params[:handle] != nil and !params[:handle].empty?

      # Using Set data structure to eliminte duplicate tweets
      tweets = Set.new
      
      # Getting the initial set of tweets
      buffer = JSON.parse(open('http://api.twitter.com/1/statuses/user_timeline.json?count=200&screen_name='+params[:handle]).read) rescue []
      buffer.each{|b| tweets << b if b["text"].split.first[0] != '@'}

      number_of_tweets = tweets.count
      page_count = 1
      # Getting 1000 not-replies tweets
      while number_of_tweets <= 1000 and !buffer.empty?
        buffer = JSON.parse(open('http://api.twitter.com/1/statuses/user_timeline.json?count=200&page=' + page_count.to_s  + '&screen_name=' + params[:handle]).read) rescue []
        page_count += 1
        buffer.each do |b|
          if b["text"].split.first[0] != '@'
            tweets << b
          end
        end
        number_of_tweets = tweets.count
      end

      counts = []
      tweets ||= []
      tweets = tweets.to_a[0..999] if tweets.count > 1000

      # The logic solution of the problem, frequency of words in tweets
      tweets.each do |tweet|
        counts << tweet["text"].split.count
      end

      # Count number of occurences of counts 
      counts.uniq.each do |count|
        @num_counts << { :num => count , :count => counts.count(count) }
      end

        # For history purpose
        h = History.new
        h.query = params[:handle]
        h.save
        @number_of_tweets_processed = tweets.count
    end
  end
end
