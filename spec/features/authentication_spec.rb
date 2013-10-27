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

          describe "by project owner" do
            before { visit project_path(project) }

            it "should delete project after sign in" do
              click_link "Delete"
              fill_in_credentials(user)
              expect(current_path).to eq user_path(user)
              expect(page).not_to have_text(project.title)
            end

          end

          describe "by user not owning the project" do

          end
        end

        describe "delete track" do
        end

        describe "delete comment" do
        end
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
  end
end
