require "xmlsimple"

module Ns
  class Client

    def initialize(api_key = '', api_password = '', opts = {})
      @url  = 'http://webservices.ns.nl'
      @port = '80'
      set_api_cridentials(api_key, api_password)
      set_options(opts)
      create_http_client
    end

    def get_departures(station, opts = {}, &block)
      options = {}.update(opts)
      url = "/ns-api-avt?station=#{station.upcase}"
      get_response(url)
    end

    def get_prices(from, to, opts = {}, &block)
      options = {
        through: false,
        date: false
      }.update(opts)

      url = "/ns-api-prijzen-v2?"
      url << "from=#{from}"
      url << "&to=#{to}"
      url << "&via=#{options[:via]}" if options[:via].present?
      url << "&date=#{options[:date]}" if options[:date].present?
      URI.escape!(url)

      get_response(url)
    end

    def get_travel_advice(from, to, opts = {})
      options = {
        through: '',
        previous_advices: 5,
        next_advices: 5,
        date_time: false,
        departure: true,
        hsl: true,
        year_card: false
      }.update(opts)

      url = "/ns-api-treinplanner?"
      url << "fromStation=#{from.upcase}"
      url << "&toStation=#{to.upcase}"
      url << "&viaStation=#{options[:through].upcase}" if options[:through] != ''
      url << "&previousAdvices=#{options[:previous_advices]}"
      url << "&nextAdvices=#{options[:next_advices]}"
      url << "&dateTime=#{options[:date_time]}" if options[:date_time]
      url << "&departure=#{options[:departure]}"
      url << "&hslAllowed=#{options[:hsl]}"
      url << "&yearCard=#{options[:year_card]}"

      get_response(url)
      # url
    end

    def get_stations
      answer = get_response('/ns-api-stations')
      p answer["Station"]
    end

    def get_maintenances(station, actual, unplanned)

    end

    private

    def set_api_cridentials(api_key, api_password)
      @api_key      = api_key
      @api_password = api_password
    end

    def set_options(options)
      @options = {

      }.update(options)
    end

    def create_http_client
      uri = URI.parse("#{@url}:#{@port}")
      @client = Net::HTTP.new(uri.host, uri.port)
    end

    def get_response(path)
      request = Net::HTTP::Get.new(path)
      request.basic_auth(@api_key, @api_password)
      response = @client.request(request)
      XmlSimple.xml_in(response.body, {'ForceArray' => false})
    end
  end
end