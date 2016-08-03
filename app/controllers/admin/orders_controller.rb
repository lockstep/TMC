module Admin
  class OrdersController < Admin::ApplicationController
  end
end

module Administrate
  class Search
    def initialize(resolver, term)
      @resolver = resolver
      @term = term
    end

    def run
      if @term.blank?
        resource_class.all
      else
        resource_class.where(id: @term)
      end
    end

    private

    delegate :resource_class, to: :resolver
    attr_reader :resolver, :term
  end
end
