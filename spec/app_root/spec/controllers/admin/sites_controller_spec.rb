require 'spec_helper'

describe Admin::SitesController do
  before(:each) { sign_in Factory(:user) }

  describe '#show' do
    before(:each) do
      @site = Factory(:site)
      params = {:id => @site.id}

      get :show, params
    end

    it 'sets the session[:site_id] to the requested site.id' do
      session[:site_id].should == @site.id
    end

    it 'redirects the user to /admin/pages' do
      response.should redirect_to admin_pages_path
    end
  end

  describe '#theme_collection' do
    it 'returns all of the themes' do
      theme = Factory(:theme)
      get :new
      controller.send(:theme_collection).should == [theme]
    end
  end

  describe '#new' do
    it 'renders the overlay layout' do
      get :new
      response.should render_template('layouts/overlay')
    end
  end

  describe '#create' do
    before(:each) do
      @params = {}
      @params[:site] = { :name => 'Site Name -1', :domain => 'localhost-2', :theme_id => 1 }
    end

    context 'when successful' do
      before(:each) { post :create, @params }

      it 'sets the flash success message' do
        flash[:success].should_not be_nil
      end

      it 'redirects the user to /admin/manage/sites/<site_id>' do
        response.should redirect_to admin_manage_site_path(assigns(:site))
      end
    end

    context 'when site creation fails' do
      before(:each) do
        @params[:site].delete :domain
        post :create, @params
      end

      it 'sets the flash failure message' do
        flash[:alert].should_not be_nil
      end

      it 'redirects the user to /admin/manage' do
        response.should redirect_to admin_manage_path
      end
    end
  end
end
