require 'spec_helper'

describe "Authentication" do

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { User.create(user_attributes) }
      let(:nonproprietor) do
        User.create(user_attributes(email: "non@proprietor.com"))
      end

      describe "in the Users controller" do
        before { visit edit_user_path(user) }

        it "visiting the edit page should redirect to the sign in page" do
          expect(current_path).to eq signin_path
        end

        describe "submitting to the update action", type: :request do
          before { patch user_path(user) }

          it "should redirect to the sign in page" do
            expect(response).to redirect_to signin_path
          end

        end
      end

      describe "try to visit protected page" do

        describe "edit user" do
          before do
            visit edit_user_path(user)
            fill_in_credentials(user)
          end

          it "should forward to edit user after sign in" do
            expect(current_path).to eq edit_user_path(user)
          end
        end

        describe "visit the user index page" do
          
          it "should redirect to sign in page" do
            visit users_path
            expect(current_path).to eq signin_path
          end

          it "should forward to user index page after signin" do
            visit users_path
            fill_in_credentials(user)
            expect(current_path).to eq users_path
          end
        end

        describe "create project" do
          before do
            visit new_project_path
            fill_in_credentials(user)
          end

          it "should forward to new project after sign in" do
            expect(current_path).to eq new_project_path
          end
        end

        describe "create track" do
          let(:project) { user.projects.create(project_attributes) } 

          before do
            visit new_project_track_path(project)
            fill_in_credentials(user)
          end

          it "should forward to new track after sign in" do
            expect(current_path).to eq new_project_track_path(project)
          end
        end

        describe "create comment" do
          let(:project) { Project.create(project_attributes) }
          let(:track)   { project.tracks.create(track_attributes) } 

          before do
            visit new_track_comment_path(track)
            fill_in_credentials(user)
          end

          it "should forward to new comment after sign in" do
            expect(current_path).to eq new_track_comment_path(track)
          end
        end

        describe "edit project" do
          let(:project) { user.projects.create(project_attributes) }

          describe "by project owner" do
            before do
              visit edit_project_path(project)
              fill_in_credentials(user)
            end
            
            it "should forward to edit project after sign in" do
              expect(current_path).to eq edit_project_path(project)
            end
          end

          describe "by user not owning the project" do
            before do
              visit edit_project_path(project)
              fill_in_credentials(nonproprietor)
            end

            it "should not forward to edit project after sign in" do
              expect(current_path).to eq root_path
            end
          end
        end

        describe "edit track" do
          let(:project) { user.projects.create(project_attributes) }
          let(:track)   { project.tracks.create(track_attributes(user: user)) }

          describe "by track owner" do
            before do
              visit edit_project_track_path(project, track)
              fill_in_credentials(user)
            end
            
            it "should forward to edit track after sign in" do
              expect(current_path).to eq edit_project_track_path(project, track)
            end
          end

          describe "by user not owning the track" do
            before do
              visit edit_project_track_path(project, track)
              fill_in_credentials(nonproprietor)
            end

            it "should not forward to edit track after sign in" do
              expect(current_path).to eq root_path
            end
          end
        end

        describe "edit comment" do
          let(:project) { user.projects.create(project_attributes) }
          let(:track)   { project.tracks.create(track_attributes(user: user)) }
          let(:comment) do 
            track.comments.create(comment_attributes(user: user)) 
          end

          describe "by comment owner" do
            before do
              visit edit_track_comment_path(track, comment)
              fill_in_credentials(user)
            end
            
            it "should forward to edit comment after sign in" do
              expect(current_path).to eq edit_track_comment_path(track, comment)
            end
          end

          describe "by user not owning the comment" do
            before do
              visit edit_track_comment_path(track, comment)
              fill_in_credentials(nonproprietor)
            end

            it "should not forward to edit comment after sign in" do
              expect(current_path).to eq root_path
            end
          end
        end

        describe "delete project" do
          let(:project) { user.projects.create(project_attributes) }

          it "should not have a 'Delete' link" do
            visit project_path(project)
            expect(page).not_to have_link('Delete')
          end

          describe "by project owner" do

            it "should have a 'Delete' link after signin" do
              valid_signin(user)
              visit project_path(project)
              expect(page).to have_link('Delete')
            end

          end

          describe "by user not owning the project" do
          
            it "should not have a 'Delete' link after signin" do
              valid_signin(nonproprietor)
              visit project_path(project)
              expect(page).not_to have_link('Delete')
            end

          end
        end

        describe "delete track" do
          let(:project) { user.projects.create(project_attributes) }
          let(:track)   { project.tracks.create(track_attributes(user: user)) }

          it "should not have a 'Delete' link" do
            visit project_track_path(project, track)
            expect(page).not_to have_link('Delete')
          end

          describe "by track owner" do

            it "should have a 'Delete' link after signin" do
              valid_signin(user)
              visit project_track_path(project, track)
              expect(page).to have_link('Delete')
            end

          end

          describe "by user not owning the track" do
          
            it "should not have a 'Delete' link after signin" do
              valid_signin(nonproprietor)
              visit project_track_path(project, track)
              expect(page).not_to have_link('Delete')
            end

          end
        end

        describe "delete comment" do
=begin
          let(:project) { user.projects.create(project_attributes) }
          let(:track)   { project.tracks.create(track_attributes) }
          let(:comment) do
            track.comments.create(comment_attributes(user: user))
          end

          it "should have a comment" do
            expect(track.comments.size).to eq 1
            visit project_track_path(project, track)
            expect(page).to have_text comment.title
          end

          it "should not have a 'Delete Comment' link" do
            visit project_track_path(project, track)
            expect(page).not_to have_link('Delete Comment')
          end

          describe "by comment owner" do

            it "should have a 'Delete Comment' link after signin" do
              valid_signin(user)
              visit project_track_path(project, track)
              expect(page).to have_link('Delete Comment')
            end

          end

          describe "by user not owning the comment" do
          
            it "should not have a 'Delete' link after signin" do
              valid_signin(nonproprietor)
              visit project_track_path(project, track)
              expect(page).not_to have_link('Delete Comment')
            end

          end
=end
        end
      end
    end

    describe "as user not owning the object" do
      let(:user) { User.create(user_attributes) }
      let(:nonproprietor) do 
        User.create(user_attributes(email: "non@proprietor.com"))
      end
      let(:project) { user.projects.create(project_attributes) }
      let(:track)   { project.tracks.create(track_attributes(user: user)) }
      let(:comment) { track.comments.create(comment_attributes(user: user)) }

      before { sign_in(nonproprietor, no_capybara: true) }

      describe "submitting a DELETE request to the Project#destroy action",
               type: :request do
        before { delete project_path(project) }
        specify { expect(response).to redirect_to(root_path) }
      end
      
      describe "submitting a DELETE request to the Track#destroy action",
               type: :request do
        before { delete project_track_path(project, track) }
        specify { expect(response).to redirect_to(root_path) }
      end
      
      describe "submitting a DELETE request to the Comment#destroy action",
               type: :request do
        before { delete track_comment_path(track, comment) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as wrong user" do
      let(:user) { User.create(user_attributes) }
      let(:wrong_user) do
        User.create(user_attributes(email: "wrong@example.com"))
      end
      before { sign_in(user, no_capybara: true) }

      describe "submitting a GET request to the Users#edit action", 
               type: :request do
        before { get edit_user_path(wrong_user) }

        specify { 
          expect(response.body).not_to match("Apptrack | Edit #{user.name}") 
        }
        specify { expect(response).to redirect_to(root_path) }
      end

      describe "submitting a PATCH request to the Users#update action",
               type: :request do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end

    end

    describe "as non-admin user" do
      let(:user) { User.create(user_attributes) }
      let(:other) { User.create(user_attributes(email: "other@example.com")) }

      before { sign_in(other, no_capybara: true) }

      describe "should not delete user as non-admin user", type: :request do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as admin user" do
      let(:admin) { User.create(user_attributes(admin: true)) }

      before { sign_in(admin, no_capybara: true) }

      describe "should not delete own account", type: :request do
        before { delete user_path(admin) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
