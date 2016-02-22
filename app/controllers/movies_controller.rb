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
    @all_ratings = ['G','PG','PG-13','R']
    prev_param = false
    sort_param = false
      
    if params[:ratings] != nil then
      @ratings = params[:ratings].keys
      @movies = Movie.where(rating: @ratings)
      session[:ratings] = params[:ratings]
    elsif session[:ratings] == nil
      @ratings = @all_ratings
    else
      params[:ratings] = session[:ratings]
      @ratings = params[:ratings].keys
      prev_param = true
    end
    
    if params[:sort] == nil and session[:sort] != ''
      params[:sort] = session[:sort]
      sort_param = true
    end
    
    sort = params[:sort]
        
    if sort != nil
      session[:sort] = sort
    end
    
    if sort == 'title' then
       @movies = Movie.all.sort_by { |movie| movie.title }
    elsif sort == 'release_date' then
       @movies = Movie.all.sort_by { |movie| movie.release_date }
    end
    
    if session[:sort] != '' and session[:ratings] !=nil
      if prev_param == true and sort_param == true
        redirect_to url_for(sort: params[:sort], ratings: params[:ratings])
      elsif sort_param == true and params[:ratings] == nil
        redirect_to url_for(sort: params[:sort])
      elsif prev_param == true and params[:rating] == nil
        redirect_to url_for(ratings: params[:ratings])
      elsif (prev_param == true or sort_param == true) and (params[:sort] != nil and params[:ratings] != nil)
        redirect_to url_for(sort: params[:sort], ratings: params[:ratings])
      end
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
