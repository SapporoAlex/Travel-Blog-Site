class ArticlesController < ApplicationController
  http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]
  def index
    if params[:query].present?
      @articles = Article.where('title LIKE ? OR body LIKE ? OR author LIKE ?', 
                                 "%#{params[:query]}%", 
                                 "%#{params[:query]}%", 
                                 "%#{params[:query]}%")
    else
      @articles = Article.all
    end
  end
  

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
   
    redirect_to root_path
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status, :author, :image)
    end
end