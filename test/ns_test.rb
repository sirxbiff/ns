require "test/unit"
require "../lib/ns/client"
require "net/http"
require "mocha"

class NsTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup


    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_get_stations
    http_get_mock = mock('Net::HTTP::Get')
    http_response_mock = mock('Net:HTTP:Response')
    http_mock = mock('Net:HTTP')
    Net::HTTP::Get.stubs(:new => http_get_mock)
    Net::HTTP.stubs(:new => http_mock)
    http_get_mock.expects(:basic_auth).with('key','password')
    http_mock.stubs(:request => http_response_mock)
    http_response_mock.stubs(:code => '200', :message => "OK", :content_type => "text/xml",
                             :body => %{
      <Stations>
        <Station>
          <Code>HT</Code>
          <Type>knooppuntIntercitystation</Type>
          <Namen>
            <Kort>H'bosch</Kort>
            <Middel>'s-Hertogenbosch</Middel>
          <Lang>'s-Hertogenbosch</Lang>
          </Namen>
          <Land>NL</Land>
          <UICCode>8400319</UICCode>
          <Lat>51.690556</Lat>
          <Lon>5.293611</Lon>
          <Synoniemen>
            <Synoniem>Hertogenbosch ('s)</Synoniem>
            <Synoniem>Den Bosch</Synoniem>
          </Synoniemen>
        </Station>
          <Station>
          <Code>HTO</Code>
          <Type>stoptreinstation</Type>
          <Namen>
          <Kort>H'bosch O</Kort>
            <Middel>Hertogenbosch O</Middel>
            <Lang>'s-Hertogenbosch Oost</Lang>
          </Namen>
          <Land>NL</Land>
          <UICCode>8400320</UICCode>
          <Lat>51.700554</Lat>
          <Lon>5.318333</Lon>
          <Synoniemen>
          <Synoniem>Hertogenbosch Oost ('s)</Synoniem>
            <Synoniem>Den Bosch Oost</Synoniem>
          </Synoniemen>
        </Station>
        <Station>
          <Code>HDE</Code>
          <Type>stoptreinstation</Type>
          <Namen>
            <Kort>'t Harde</Kort>
            <Middel>'t Harde</Middel>
          <Lang>'t Harde</Lang>
          </Namen>
          <Land>NL</Land>
          <UICCode>8400388</UICCode>
          <Lat>52.40917</Lat>
          <Lon>5.893611</Lon>
          <Synoniemen>
            <Synoniem>Harde ('t)</Synoniem>
          </Synoniemen>
          </Station>
      </Stations>
    })

    ns_client = Ns::Client.new('key', 'password')
    stations = ns_client.get_stations

    assert_not_nil(stations[2])
    assert_equal("'t Harde", stations[2]["Namen"]["Kort"] )
  end
end