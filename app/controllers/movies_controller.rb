class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      # @movies = Movie.all
      
      @all_ratings = Movie.all_ratings
      
      if !session.has_key?(:ratings)
        if params.has_key?(:ratings)
          session[:ratings] = params[:ratings]
        else 
          session[:ratings] = Hash[@all_ratings.collect {|key| [key, '1']}]
        end
      else
        if params.has_key?(:ratings) && session[:ratings] != params[:ratings]
          session[:ratings] = params[:ratings]
        end
      end
      
      
      if !session.has_key?(:sort_by)
        if params.has_key?(:sort_by)
          session[:sort_by] = params[:sort_by]
        else
          session[:sort_by] = "title"
        end
      else
        if params.has_key?(:sort_by) && session[:sort_by] != params[:sort_by]
          session[:sort_by] = params[:sort_by]
        end
      end
      
      if (!session.has_key?(:ratings)) || (!session.has_key?(:sort_by)) ||
         (params.has_key?(:sort_by) && session[:sort_by] != params[:sort_by]) ||
         (params.has_key?(:ratings) && session[:ratings] != params[:ratings])
         
        redirect_to movies_path(:ratings => session[:ratings], :sort_by => session[:sort_by]) and return
      end
      
      @ratings_to_show = session[:ratings].keys
      
      @ratings_to_show_hash = Hash[@ratings_to_show.collect {|key| [key, '1']}]
      
      @movies = Movie.with_ratings(@ratings_to_show)
      
      if params[:sort_by] != ''
        @movies = @movies.order(session[:sort_by])
      end
      
      if session.has_key?(:sort_by)
        if session[:sort_by] == 'title'
          @title = 'hilite bg-warning'
        else
          @title = ''
        end
        
        if session[:sort_by] == 'release_date'
          @rdate = 'hilite bg-warning'
        else
          @rdate = ''
        end
      else
        @title = ''
        @rdate = ''
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end