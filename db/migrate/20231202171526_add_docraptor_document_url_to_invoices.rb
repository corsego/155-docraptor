class AddDocraptorDocumentUrlToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :docraptor_document_url, :text
  end
end
