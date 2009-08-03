class WelcomeController < ApplicationController
  def index
    @pictures = Picture.most_recent
  end
end
