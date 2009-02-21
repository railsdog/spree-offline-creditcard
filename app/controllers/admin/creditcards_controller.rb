class Admin::CreditcardsController < Admin::BaseController
  before_filter :load_data

  resource_controller
  belongs_to :order
  ssl_required

  # override the r_c defauult since he have the special presenter logic and we need to capture before storing cc info.
  def create
    build_object
    creditcard = @creditcard_presenter.creditcard
    creditcard.address = @creditcard_presenter.address
    creditcard.order = @order
    
    # TODO - refactor the spree code so that creditcard name can be read from the address
    creditcard.first_name = creditcard.address.firstname
    creditcard.last_name = creditcard.address.lastname

    unless @creditcard_presenter.valid? and creditcard.save
      render :action => "new" and return
    end

    flash[:notice] = t("credit_card_added.")
    redirect_to collection_url
  end   
  
  def edit               
    load_object
    @creditcard_presenter = CreditcardPresenter.new(:creditcard => @creditcard, :address => @creditcard.address)
  end  
  
  def update
    @creditcard_presenter = CreditcardPresenter.new(params[:creditcard_presenter])   
    @creditcard.address.destroy
    @creditcard.address = @creditcard_presenter.address
    @creditcard.address.save
    
    flash[:notice] = t("credit_card_updated")
    redirect_to object_url
  end  

  def country_changed
    render :partial => "shared/states", :locals => {:presenter_type => "creditcard"}
  end
  
  private
  def build_object
    return @object if @object
    @creditcard_presenter = CreditcardPresenter.new(params[:creditcard_presenter])
    # special hack to use the ship_address when applicable
    @creditcard_presenter.address = parent_object.ship_address unless params[:creditcard_presenter]
    @object = @creditcard_presenter
  end
    
  def load_data 
    load_object    
    @selected_country_id = params[:creditcard_presenter][:address_country_id].to_i if params.has_key?('creditcard_presenter')
    @selected_country_id ||= Spree::Config[:default_country_id]
    @states = State.find_all_by_country_id(@selected_country_id, :order => 'name')  
    @countries = Country.find(:all)
  end

end