require "test_helper"

class FavoriteAlbumsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get favorite_albums_index_url
    assert_response :success
  end

  test "should get create" do
    get favorite_albums_create_url
    assert_response :success
  end

  test "should get destroy" do
    get favorite_albums_destroy_url
    assert_response :success
  end
end
