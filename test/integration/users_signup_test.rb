require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
    #Validates login works with valid data input
    test "valid signup information" do
        #load sign up page 
        get signup_path
        # adding one to user.count object
        assert_difference 'User.count', 1 do
            #Submits data to user database 
            post_via_redirect users_path, user: { 
                # Subits name field to database
                name:                   "Example User",
                # Subits email field to database 
                email:                  "user@example.com", 
                # Submits password data to database
                password:               "password", 
                # Submits password confirmation to database
                password_confirmation:  "password" 
            }
 
        end
        # Loads user dashboard.
        assert_template 'users/show'
        # Checks if user is logged in. 
        assert is_logged_in?
    end
    
    # Tests to make sure invalid data isn't being accepted into database.
    test "invalid signup information" do
        # Load the signup page
        get signup_path
        # Make sure that the user count doesnt change
      assert_no_difference 'User.count' do
          #submit invalid user details to the signup path
          post users_path, user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar"}
      end
      #make sure the sign up page gets reloaded
      assert_template 'users/new'
  end
end
