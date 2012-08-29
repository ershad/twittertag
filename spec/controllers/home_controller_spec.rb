require 'spec_helper'

describe HomeController do
  render_views

  describe "GET index" do
    it "should be success" do
      get :index , :handle => "ershus"
      response.should be_ok
    end

    it "should populate tweets for a valid account" do
      get :index, :handle => "shafeeq_k"
      assigns[:number_of_tweets_processed].should_not nil
    end
  end
end
