class PdfReportsController < ApplicationController
  before_action :set_report, only: :show

  def index
    @reports = Reports
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'report',
               page_size: 'A4',
               template: 'pdf_reports/show.html.erb',
               layout: 'pdf.html',
               orientation: 'portrait',
               lowquality: true,
               zoom: 1,
               dpi: 75,
               header: {
                 html: { template: 'pdf_reports/header.pdf.erb' },
               },
               footer: {
                 html: { template: 'pdf_reports/footer.pdf.erb'}
               }
      end
    end
  end

  private

  Reports = { 1 => {title: 'All Books', template: 'all_books'},
              2 => {title: 'Books Grouped by Author', template: 'books_author' } }.freeze
  
  def as_html
    render template: Reports[@report_id][1][1]
  end

  def set_report
    @report = Reports[params[:id].to_i]
    @report_id = params[:id]
    @authors = Book.all.map { |book| book.authors.map(&:name).to_sentence }.uniq.sort
  end
end
