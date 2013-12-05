class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy, :download]

  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.all
    @content = Content.new
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  # POST /contents.json
  def create
    upload_file = content_params[:upload_file]
    content = {}
    if upload_file != nil
      content[:upload_file] = upload_file.read
      content[:upload_file_name] = upload_file.original_filename
    end
    content[:password] = content_params[:password]
    @content = Content.new(content)
    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Upload success' }
        format.json { render action: 'show', status: :created, location: @content }
      else
        @contents = Content.all
        format.html { render action: 'index' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to @content, notice: 'Content was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    password = params[:password]

    hash_password = BCrypt::Password.new(@content.password)
    if hash_password == password
      @content.destroy
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Delete success." }
        #format.html { redirect_to contents_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:alert] = "Delete fail."
          render action: 'show'
        }
      end
    end
  end

  def download
    send_data(@content.upload_file, filename: @content.upload_file_name, type: "text/plain")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_params
      params.require(:content).permit(:upload_file_name, :upload_file, :password)
    end
end
