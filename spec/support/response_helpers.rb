module Support
  module ResponseHelpers
    def response_json
      JSON.parse(response.body)
    end
  end
end
