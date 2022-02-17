require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup 
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    # S'il n'y a pas  de       flash vide le test reussi
    # S'il y a bien un flash, le test réussi
    assert_not flash.empty?
    get root_path
    # Si on a encore un flash le test rate
    assert flash.empty?
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: @user.email, password: "invalid"} }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
