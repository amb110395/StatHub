class FootballQuarterbackStatsController < ApplicationController

  before_filter :signed_in_user, only: [:create, :destroy]

  def create

    @football_quarterback_stat = current_user.football_quarterback_stats.new(params[:football_quarterback_stat])

    @football_quarterback_stat.completion_percentage = @football_quarterback_stat.completions.to_f/(@football_quarterback_stat.passing_attempts.nonzero? || 10000)
    @football_quarterback_stat.yards_per_attempt = @football_quarterback_stat.passing_yards.to_f/(@football_quarterback_stat.passing_attempts.nonzero? || 10000)

    @football_quarterback_stat.yards_per_rush = @football_quarterback_stat.rushing_yards.to_f/(@football_quarterback_stat.rushing_attempts.nonzero? || 10000)
    if @football_quarterback_stat.save
      flash[:success] = "The stat was successfully added!"
      redirect_to current_user
    else
      flash[:error] = "There was an error adding your stat."
      redirect_to current_user
    end

  end



  def destroy
    FootballQuarterbackStat.find(params[:id]).delete

    redirect_to current_user
  end



end