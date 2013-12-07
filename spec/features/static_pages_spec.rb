require 'spec_helper'

describe 'Static pages' do

  let(:base_title) { "Apptrack" }

  describe 'Home page' do

    before { visit root_path }
    
    it "should have main navigation" do
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('Projects', href: projects_path)
      expect(page).to have_link('Members', href: users_path)
    end

    it "should have title 'Home'" do
      expect(page).to have_title("#{base_title} | Home")
    end
    
    it "should have h1 'apptrack'" do
      expect(page).to have_selector('h1', text: 'apptrack')
    end

    it "should have description" do
      expect(page).to have_content("apptrack provides a platform")
    end

    describe "if not signed in" do

      before { signout_path }

      it "should have sign up link" do
        expect(page).to have_link('Sign up now!', href: signup_path)
      end

      it "should have sign in link" do
        expect(page).to have_link("Sign in now!", href: signin_path)
      end

    end

    describe "if signed in" do

      let(:user) { User.create!(user_attributes) }

      before do 
        valid_signin(user) 
        visit root_path
      end

      it "should not have sign up link" do
        expect(page).not_to have_link('Sign up now!', href: signup_path)
      end

      it "should not have sign in link" do
        expect(page).not_to have_link('Sign in now!', href: signin_path)
      end

    end

  end

  describe 'Help page' do

    before { visit help_path }

    it "should have main navigation" do
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('Projects', href: projects_path)
      expect(page).to have_link('Members', href: users_path)
    end
    
    it "should have title 'Help'" do
      expect(page).to have_title("#{base_title} | Help")
    end

    it "should have h1 'Help'" do
      expect(page).to have_selector('h1', text: 'Help')
    end

  end

  describe 'About page' do

    before { visit about_path }

    it "should have main navigation" do
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('Projects', href: projects_path)
      expect(page).to have_link('Members', href: users_path)
    end

    it "should have title 'About us'" do
      expect(page).to have_title("#{base_title} | About us")
    end

    it "should have h1 'About us'" do
      expect(page).to have_selector('h1', text: 'About us')
    end

  end

  describe 'Contact page' do
    
    before { visit contact_path }

    it "should have main navigation" do
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('Projects', href: projects_path)
      expect(page).to have_link('Members', href: users_path)
    end
    
    it "should have title 'Contact'" do
      expect(page).to have_title("#{base_title} | Contact")
    end

    it "should have h1 'Contact'" do
      expect(page).to have_selector('h1', text: 'Contact')
    end

    it "should have contact form" do
      fill_in 'E-Mail', with: 'user@example.com'
      fill_in 'Subject', with: 'Request for information'
      fill_in 'Message', with: 'Could you please provide ...'
      click_button 'Send' 
    end

  end

end
