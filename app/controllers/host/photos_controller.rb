class Host::PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing

  def index
    @listing = current_user.listings.find(params[:listing_id])
    @photos = @listing.photos
  end
  def new
  end


  def create
    @photo = @listing.photos.new(photo_params)
    if @photo.save
      redirect_to host_listing_photos_path(@listing), notice: "Photo Successfully uploaded"

      else
    render new, status: :unprocessable_entity
    end

  end

  private

  def set_listing
    @listing = current_user.listings.find(params[:listing_id])

  end

  def photo_params
    params.require(:photo).permit(:caption, :file)
  end
end