require "test_helper"

class TeachingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:isara)
    @teaching = teachings(:one)
  end

  test "should get index" do
    get teachings_url
    assert_response :success
  end

  test "should get new" do
    get new_teaching_url
    assert_response :success
  end

  test "should create teaching" do
    assert_difference("Teaching.count") do
      post teachings_url, params: { teaching: { title: "New Teaching", slug: "new-teaching", institution: "UNE", year: "2025" } }
    end

    assert_redirected_to teaching_url(Teaching.last)
  end

  test "should show teaching" do
    get teaching_url(@teaching)
    assert_response :success
  end

  test "should get edit" do
    get edit_teaching_url(@teaching)
    assert_response :success
  end

  test "should update teaching" do
    patch teaching_url(@teaching), params: { teaching: { title: "Updated Title" } }
    assert_redirected_to teaching_url(@teaching)
  end

  test "should destroy teaching" do
    assert_difference("Teaching.count", -1) do
      delete teaching_url(@teaching)
    end

    assert_redirected_to teachings_url
  end
end
