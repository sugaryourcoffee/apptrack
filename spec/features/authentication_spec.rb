require 'spec_helper'

describe "Authentication" do

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { User.create(user_attributes) }

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
