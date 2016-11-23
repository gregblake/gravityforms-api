require 'json'

module Gravityforms
  module Api
    class Form
      attr_reader :id, :title, :entries, :fields, :response

      def initialize(attributes)
        @response = attributes
        @id = attributes["id"]
        @title = attributes["title"]
        @entries = attributes["entries"]
        @fields = (attributes.key?("fields") ? attributes["fields"] : "")
      end

      def self.find(id)
        request = Gravityforms::Api::Request.new("forms/#{id}", "GET")
        response = request.get
        attributes = JSON.parse(response.body)
        new(attributes)
      end

      def self.all
        request = Gravityforms::Api::Request.new("forms", "GET")
        response = request.get
        forms = JSON.parse(response.body)
        forms["response"].map { |attributes| new(attributes[1]) }
      end

      def self.entries(id)
        request = Gravityforms::Api::Request.new("forms/#{id}/entries", "GET")
        response = request.get
        attributes = JSON.parse(response.body)
        new(attributes)
      end

      def self.submit(id, payload)
        request = Gravityforms::Api::Request.new("forms/#{id}/submissions", "POST")
        response = request.post(payload)
        response.body
      end
    end
  end
end