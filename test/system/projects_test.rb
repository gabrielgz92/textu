require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase

  test "when logged out, visiting the projects index should redirect the user" do
    visit projects_url
    assert page.current_path === new_user_session_path
    assert page.has_content? 'Log in'
    assert page.has_content? 'Sign up'
  end

  test "visiting the index when logged in" do
    user = User.first
    login_as(user, :scope => :user)
    visit projects_url
    assert page.has_content? "My Projects"
    assert page.has_selector?('.add-project-card', count: 1)
    assert page.has_selector?('.project-card', count: 1)
  end

end
