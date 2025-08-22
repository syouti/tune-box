require "test_helper"

class GuestAlbumsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get guest_albums_index_url
    assert_response :success
  end
end
