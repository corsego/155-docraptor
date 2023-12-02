class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.order(created_at: :desc)
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        InvoicePdfJob.perform_now(@invoice)
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:email, :product, :price, :quantity)
  end
end
