class ImportsController < ApplicationController
  def index
  end

  def import
    if params[:file].nil? || params[:file].original_filename.empty?
      @message = 'You must specify a file name'
      render 'index'
    else
      myfile  = params[:file].read
      case params[:file_type].to_i
      when 1
        import_result = Importer.from_text(myfile)
      when 2
        import_result = Importer.from_csv(myfile)
      when 3
        import_result = Importer.from_xml(myfile)
      when 4
        import_result = Importer.from_json(myfile)
      end

      @books = Book.find(import_result[:books]) unless import_result[:books].nil?
      @authors = Author.find(import_result[:authors]) unless import_result[:books].nil?

      render 'show'
    end
  end
end