require 'spec_helper'
require 'rspec/mocks'

describe MoviesController do

  describe 'add director' do
    before :each do
      @m=mock(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub!(:find).with("1").and_return(@m)
    end
    it 'should call update_attributes and redirect' do
      @m.stub!(:update_attributes!).and_return(true)
      put :update, {:id => "1", :movie => @m}
      response.should redirect_to(movie_path(@m))
    end
  end

  describe 'searching for movies by director(happy path)' do
  	before :each do
  		@fake_results = [mock('movie1'),mock('movie2')]
      m=double(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub!(:find_by_id).with("1").and_return(m)
  	end
    it 'should generate routing for Similar Movies' do
      { :post => similar_movie_path(1) }.
      should route_to(:controller => "movies", :action => "similar", :id => "1")
    end
    it 'should call the controller method that finds similar movies' do
      @controller = MoviesController.new()
      @controller.should_receive(:similar)
      get :similar, :id => "1"
    end
    it "should call model method" do
      Movie.should_receive(:similar_directors).with('director').and_return(@fake_results)
      get :similar, :id => "1"
    end
    it "should render similar template" do
      Movie.should_receive(:similar_directors).with('director').and_return(@fake_results)
      get :similar, :id => "1"
      response.should render_template('similar')
      assigns(:movies).should == @fake_results
    end
  end

  describe 'searching for movies by director(sad path)' do
    before :each do
      m=double(Movie, :title => "Star Wars", :id => "1", :director => nil)
      Movie.stub!(:find_by_id).with("1").and_return(m)
    end
    
    it 'should generate routing for Similar Movies' do
      { :post => similar_movie_path(1) }.
      should route_to(:controller => "movies", :action => "similar", :id => "1")
    end
    it 'should select the Index template for rendering and generate a flash' do
      get :similar, :id => "1"
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_blank
    end
  end

  describe 'create and destroy' do
    it 'should create a new movie' do
      MoviesController.stub(:create).and_return(mock('Movie'))
      post :create, {:id => "1"}
    end
    it 'should destroy a movie' do
      m = mock(Movie, :id => "10", :title => "blah", :director => nil)
      Movie.stub!(:find).with("10").and_return(m)
      m.should_receive(:destroy)
      delete :destroy, {:id => "10"}
    end
  end

end