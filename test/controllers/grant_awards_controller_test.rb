require "test_helper"

class GrantAwardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @grant_award = grant_awards(:one)
  end

  test "should get index" do
    get grant_awards_url
    assert_response :success
  end

  test "should get new" do
    get new_grant_award_url
    assert_response :success
  end

  test "should create grant_award" do
    assert_difference("GrantAward.count") do
      post grant_awards_url, params: { grant_award: { awarding_body: @grant_award.awarding_body, category: @grant_award.category, description: @grant_award.description, slug: @grant_award.slug, title: @grant_award.title, year: @grant_award.year } }
    end

    assert_redirected_to grant_award_url(GrantAward.last)
  end

  test "should show grant_award" do
    get grant_award_url(@grant_award)
    assert_response :success
  end

  test "should get edit" do
    get edit_grant_award_url(@grant_award)
    assert_response :success
  end

  test "should update grant_award" do
    patch grant_award_url(@grant_award), params: { grant_award: { awarding_body: @grant_award.awarding_body, category: @grant_award.category, description: @grant_award.description, slug: @grant_award.slug, title: @grant_award.title, year: @grant_award.year } }
    assert_redirected_to grant_award_url(@grant_award)
  end

  test "should destroy grant_award" do
    assert_difference("GrantAward.count", -1) do
      delete grant_award_url(@grant_award)
    end

    assert_redirected_to grant_awards_url
  end
end
