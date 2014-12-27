require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

    #Define setup function
    def setup
        #Use test user as setup function data
        @user = users(:tom)
        #End defining setup function
    end

    #Test login with invalid information so 
    test "login with invalid information" do
        # Show login form
        get login_path
        # Creating new session
        assert_template 'sessions/new'
        # Input invalid user data
        post login_path, session: { email: "", password: "" }
        # Starts new session  
        assert_template 'sessions/new'
        # Show error flash that login creds were bad
        assert_not flash.empty?
        # Creates new session
        get root_path
        # Make sure flash doesn't follow to dashboard
        assert flash.empty?
    end
# Hypothesis: When a user logs in, They will be redireced to the profile page,
#      The template shown will be the user profile template, the login path is
#      not visible the log out path is visible, and the user path is for
#      the current user.

# Second hypothesis: When a gooed in user logs out, they will no longer be logged in,
#        They will be redirected to the root url, the login link will be visible but
#        the log out will not be visible, and the path will not be the current user's
#        profile path. 

    test "login with valid followed by the logout" do 
        # Loads login page 
        get login_path 
        # Input correct user data
        post login_path, session: { email: @user.email, password: 'password' } 
        # Make sure 
        assert is_logged_in?
        # Redirecting to user dashboard.
        assert_redirected_to @user 
        # Visit rediret page.
        follow_redirect! 
        # Input user data into user dashboard template
        assert_template 'users/show' 
        # Removes login link
        assert_select "a[href=?]", login_path, count: 0
        # Makes login link show
        assert_select "a[href=?]", logout_path
        # Shows user profile links. 
        assert_select "a[href=?]", user_path(@user)
        # 
        delete logout_path
        # 
        assert_not is_logged_in?
        # 
        assert_redirected_to root_url
        # Simulate a suer clicking logout in a second window.
        delete logout_path
        # 
        follow_redirect!
        #
        assert_select "a[href=?]", login_path
        # 
        assert_select "a[href=?]", logout_path, count:0
        # 
        assert_select "a[href=?]", user_path(@user), count:0
    end

    test "login with remembering" do
        log_in_as(@user, remember_me: '1')
        assert_not_nil cookies['remember_token']
    end

    test "login without remembering" do
        log_in_as(@user, remember_me: '0')
        assert_nil cookies['remember_token']
    end

end



 