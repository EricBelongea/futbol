require 'simplecov'
SimpleCov.start
require './lib/stat_tracker'

RSpec.describe Team do
  before(:all) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
    @team = Team.new(@stat_tracker.game_team_data, @stat_tracker.game_data, @stat_tracker.team_data)
  end

  it 'exists' do
    expect(@team).to be_an_instance_of Team
  end
  
  it "#team_info" do
    expected = {
      "team_id" => "18",
      "franchise_id" => "34",
      "team_name" => "Minnesota United FC",
      "abbreviation" => "MIN",
      "link" => "/api/v1/teams/18"
    }

    expect(@team.team_info("18")).to eq expected
  end

  it 'can find seasonal wins' do
    expected = {
      "20122013"=>22,
      "20132014"=>49,
      "20142015"=>52,
      "20152016"=>39,
      "20162017"=>44,
      "20172018"=>24
    }

    expect(@team.game_wins_per_season("3")).to eq(expected)
  end

  it 'can count season game totals' do
    expected = {
      "20122013"=>60,
      "20132014"=>107,
      "20142015"=>101,
      "20152016"=>87,
      "20162017"=>94,
      "20172018"=>82
    }
    expect(@team.games_per_season("3")).to eq(expected)
  end

  it "#best_season" do
    expect(@team.best_season("6")).to eq "20132014"
  end

  it "#worst_season" do
    expect(@team.worst_season("6")).to eq "20142015"
  end

  it "#teams_total_wins" do
    expect(@team.teams_total_wins("6")).to eq({"6" => 251})
  end

  it '#teams_total_games' do
    expect(@team.teams_total_games("6")).to eq({"6" => 510})
  end

  it "#average_win_percentage" do
    expect(@team.average_win_percentage("6")).to eq 0.49
  end

  it "#most_goals_scored" do
    expect(@team.most_goals_scored("18")).to eq 7
  end

  it "#fewest_goals_scored" do
    expect(@team.fewest_goals_scored("18")).to eq 0
  end

  it '#select_team_games' do
    expected = {
      :game_id=>"2016030231", 
      :team_id=>"18", 
      :hoa=>"away", 
      :result=>"LOSS", 
      :head_coach=>"Peter Laviolette", 
      :goals=>"2", 
      :shots=>"8", 
      :tackles=>"34"
    }

    expect(@team.select_team_games("18")[0]).to eq(expected)
  end

  it '#games_won_by' do
    expected = {
      :game_id=>"2016030233", 
      :team_id=>"18", 
      :hoa=>"home", 
      :result=>"WIN", 
      :head_coach=>"Peter Laviolette", 
      :goals=>"3", 
      :shots=>"8", 
      :tackles=>"34"
    }

    expect(@team.games_won_by("18")[0]).to eq(expected)
  end

  it '#wins_by_team' do
    expect(@team.wins_by_team("18")[0]).to eq(["1", 5.0])
  end

  it '#games_against' do
    expect(@team.games_against("18")[0]).to eq(["1", 10.0])
  end

  it '#win_ratio_against' do
    expect(@team.win_ratio_against("18")["19"]).to eq(0.4411764705882353)
  end
  
  it "#favorite_opponent" do
    expect(@team.favorite_opponent("18")).to eq "DC United"
  end

  xit "#rival" do
    expect(@team.rival("18")).to eq("Houston Dash").or(eq("LA Galaxy"))
  end
end