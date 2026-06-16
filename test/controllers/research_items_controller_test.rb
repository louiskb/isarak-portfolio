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

  test "signed-in full view returns success and shows the toggle controls" do
    get research_items_url(view: "full")
    assert_response :success
    assert_match "Back to paged view", response.body
    assert_match "Sort by most recent", response.body
  end

  test "visitor index shows published items only" do
    sign_out users(:isara)
    get research_items_url
    assert_response :success
    assert_match research_items(:one).title, response.body   # published
    assert_no_match(/#{research_items(:two).title}/, response.body) # draft
  end

  test "sort_by_recency re-ranks by date and redirects to the full view" do
    patch sort_by_recency_research_items_url
    assert_redirected_to research_items_url(view: "full")
  end

  test "sort_by_recency requires authentication" do
    sign_out users(:isara)
    patch sort_by_recency_research_items_url
    assert_redirected_to new_user_session_url
  end

  test "new research item is created at the top of the order" do
    ResearchItem.sort_by_recency! # give existing items real positions
    post research_items_url, params: { research_item: { title: "Top Item", category: "journal_article" } }
    created = ResearchItem.find_by(title: "Top Item")
    assert_equal created, ResearchItem.order(:position, :created_at).first
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
