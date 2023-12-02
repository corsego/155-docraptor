class InvoiceMailer < ApplicationMailer
  def created(invoice)
    @invoice = invoice
    @greeting = "Hi"

    attachments["invoice.pdf"] = @invoice.pdf_document.download if @invoice.pdf_document.attached?
    mail to: invoice.email, subject: "Invoice #{@invoice.id}"
  end
end
