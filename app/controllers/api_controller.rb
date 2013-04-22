class ApiController < ApplicationController
  respond_to :json

  def error(text)
    { ok: false, error: text }
  end

  def ok(id = nil)
    { ok: true, id: id }.reject { |_, v| !v }
  end
end
