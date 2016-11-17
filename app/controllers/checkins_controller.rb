class CheckinsController < ApplicationController
  before_action :find_checkin, only: [:edit, :update, :destroy]
  before_action :build_checkin, only: [:new, :create]

  def index
    @checkins = current_user.checkins
                            .paginate(page: params[:page], per_page: 15)
                            .order(checkin_date: :desc)
  end

  def new
  end

  def create
    if @checkin.save
      flash[:success] = 'Checkin done.'
      redirect_to checkins_path
    else
      flash[:error] = 'Checkin not created.'
      render :new
    end
  end

  def edit
  end

  def update
    if @checkin.update_attributes(checkin_params)
      flash[:success] = 'Checkin updated successfully'
      redirect_to checkins_path
    else
      flash[:error] = 'Checkin could not be updated'
      render :edit
    end
  end

  def destroy
    if @checkin.destroy
      flash[:success] = 'Checkin deleted successfully'
    else
      flash[:error] = 'Checkin could not be deleted'
    end

    redirect_to checkins_path
  end

  private

  def find_checkin
    @checkin = Checkin.find(params[:id])
  end

  def build_checkin
    @checkin = Checkin.new(checkin_params.merge(user: current_user))
  end

  def checkin_params
    params.fetch(:checkin, {}).permit(:country_id, :checkin_date)
  end
end
