class ImportController < ApplicationController

  def typeform
    puts params
    head :ok
  end

end
