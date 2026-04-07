require "test_helper"

class ResearchItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:isara)
    @research_item = research_items(:one)
  end

  test "should get index" do
    get research_items_url
    assert_response :success
  end

  test "should get new" do
    get new_research_item_url
    assert_response :success
  end

  test "should create research_item" do
    assert_difference("ResearchItem.count") do
      post research_items_url, params: { research_item: { title: "New Item", slug: "new-item", category: "journal_article" } }
    end

    assert_redirected_to research_item_url(ResearchItem.last)
  end

  test "should show research_item" do
    get research_item_url(@research_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_research_item_url(@research_item)
    assert_response :success
  end

  test "should update research_item" do
    patch research_item_url(@research_item), params: { research_item: { title: "Updated Title" } }
    assert_redirected_to research_item_url(@research_item)
  end

  test "should destroy research_item" do
    assert_difference("ResearchItem.count", -1) do
      delete research_item_url(@research_item)
    end

    assert_redirected_to research_items_url
  end
end
