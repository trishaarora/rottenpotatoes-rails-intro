class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    if params[:ratings] != nil then
      @ratings = params[:ratings].keys
      @movies = Movie.where(rating: @ratings)
      flash[:notice] = "#{@ratings} was successfully created."
    else
      @ratings = @all_ratings
      flash[:notice] = "#{@ratings} is default."
    end
    
    sort = params[:sort]
    if sort == 'title' then
       @movies = Movie.all.sort_by { |movie| movie.title }
    elsif sort == 'release_date' then
       @movies = Movie.all.sort_by { |movie| movie.release_date }
    end
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

end
