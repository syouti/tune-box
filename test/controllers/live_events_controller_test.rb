require "test_helper"

class LiveEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get live_events_index_url
    assert_response :success
  end

  test "should get show" do
    get live_events_show_url
    assert_response :success
  end

  test "should get new" do
    get live_events_new_url
    assert_response :success
  end

  test "should get create" do
    get live_events_create_url
    assert_response :success
  end
end
