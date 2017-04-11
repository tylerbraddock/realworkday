class WorkdaysController < ApplicationController
  def index
  end

  def new
    @workday = Workday.new
  end
end
