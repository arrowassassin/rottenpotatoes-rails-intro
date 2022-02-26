class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  def index
    
    if params[:redirect].nil? && params[:sort].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?)

      redirect_to movies_path(:redirect => 1 , :sort => session[:sort], :ratings => session[:ratings].each_with_object({}) {|x, y| y[x] = "True"})
    
    end

    @movies = Movie.all
    @ratings = Movie.get_unique_ratings
    @ratings_checks = @ratings
    @sort_movies = nil
    
 
    

    @page = params[:page]

    if params[:ratings] != nil
      
	    @ratings_checks = params[:ratings].keys
	    @movies = @movies.where(rating: @ratings_checks)
	    
    elsif @page == nil
    	@ratings_checks = []
    	    
    	    
    else
	    @movies = @movies.where(rating: @ratings_checks)
    end
    
    if session[:checkedin] == nil
      @ratings_checks = params[:ratings].keys
	    session[:checkedin] = 1
    end
    
    # @ratings = Movie.get_unique_ratings
    
    if params[:sort] != nil
	    @sort_movies = params[:sort]
    end
    
    if @sort_movies != nil
	    @movies = @movies.order("#{@sort_movies} ASC")
    end
    
    session[:sort] = @sort_movies
    session[:ratings] = @ratings_checks
  
    flash.keep
    
  end
  def new
    # default: render 'new' template
  end
  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
  def edit
    @movie = Movie.find params[:id]
  end
  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end