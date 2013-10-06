class HomeController < ApplicationController
  def broadcast
    Pusher.trigger params[:channel], params[:event], params[:payload], socket_id: params[:socket_id]

    render json: {}
  end
end
