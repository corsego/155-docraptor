DocRaptor.configure do |config|
  config.username = "YOUR_API_KEY_HERE"
  # config.debugging = true
end

class InvoicePdfJob < ApplicationJob
  queue_as :default

  def perform(invoice)
    docraptor = DocRaptor::DocApi.new

    document_content = ApplicationController.render(
      template: "invoices/show",
      layout: "layouts/pdf",
      assigns: { invoice: invoice }
    )

    begin
      response = docraptor.create_doc(
        test: true, # test documents are free but watermarked
        document_type: "pdf",
        document_content: document_content,
        # document_content: "<html><body>Hello World!</body></html>",
        # document_url: "https://docraptor.com/examples/invoice.html",
        # javascript: true,
        # prince_options: {
        #   media: "print", # @media 'screen' or 'print' CSS
        #   baseurl: "https://yoursite.com", # the base URL for any relative URLs
        # }
      )

      # hosted_document_url = docraptor.create_hosted_doc(
      #   test: true, # test documents are free but watermarked
      #   document_type: "pdf",
      #   document_content: document_content,
      # )
      # invoice.update(docraptor_document_url: hosted_document_url.download_url)

      # ActiveStorage
      invoice.pdf_document.attach(io: StringIO.new(response), filename: "invoice#{invoice.id}.pdf", content_type: "application/pdf")
      # ActionMailer
      InvoiceMailer.created(invoice).deliver_later if invoice.pdf_document.attached?

      # store it locally
      File.write("docraptor-hello.pdf", response, mode: "wb")
      puts "Successfully created docraptor-hello.pdf!"
    rescue DocRaptor::ApiError => error
      puts "#{error.class}: #{error.message}"
      puts error.code
      puts error.response_body
      puts error.backtrace[0..3].join("\n")
    end    
    # Do something later
  end
end
