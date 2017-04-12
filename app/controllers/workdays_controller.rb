class WorkdaysController < ApplicationController
  def index
  end

  def new
    @workday = Workday.new
  end

  def create
    @workday = Workday.create(workday_params)
    redirect_to workdays_path
  end

  private

  def workday_params
    params.require(:workday).permit(:job_title, :industry, :description)
  end
end
