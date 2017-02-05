class ImportController < ApplicationController

  skip_before_action :verify_authenticity_token
  def typeform
    puts params
    head :ok
  end

end
