class ApiController < ApplicationController
  respond_to :json

  def error(text)
    { ok: false, error: text }
  end

  def ok
    { ok: true }
  end
end
