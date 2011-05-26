class DropboxController < ApplicationController

  before_filter :prepare_session, :except => [:authorize]
  after_filter :stash_session, :except => [:authorize]

  def authorize
   if params[:oauth_token] then
     dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
     dropbox_session.authorize(params)
     session[:dropbox_session] = dropbox_session.serialize

     redirect_to :action => 'listing'
   else
     dropbox_session = Dropbox::Session.new(CONSUMER_KEY, CONSUMER_SECRET)
     session[:dropbox_session] = dropbox_session.serialize
     redirect_to dropbox_session.authorize_url(:oauth_callback => url_for(:action => 'authorize'))
   end
  end

  def listing
  end

  def search
    keywords = params[:q].split(",").map(&:strip)
    @data = Tarantula.new(@dropbox_session).search_dropbox(keywords)
  end

  private

  def prepare_session
    @dropbox_session = Dropbox::Session.deserialize(session[:dropbox_session])
    @dropbox_session.mode = :dropbox
  end 

  def stash_session
     session[:dropbox_session] = @dropbox_session.serialize
  end
end
