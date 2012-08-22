require "test/unit"
require "../lib/ns/client"
require "net/http"
require "mocha"

class NsTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @http_response_mock = mock('Net::HTTP::Get')
    @http_response_mock = mock('Net:HTTP:Response')
    @http_mock = mock('Net:HTTP')
    Net::HTTP::Get.stubs(:new => @http_response_mock)
    Net::HTTP.stubs(:new => @http_mock)
    @http_response_mock.expects(:basic_auth).with('key','password')
    @http_mock.stubs(:request => @http_response_mock)
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_get_stations
    @http_response_mock.stubs(:code => '200', :message => "OK", :content_type => "text/xml",
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

    assert_equal("'t Harde", stations[2]["Namen"]["Kort"] )
  end

  def test_get_travel_advice
    @http_response_mock.stubs(:code => '200', :message => "OK", :content_type => "text/xml",
                              :body => %{
<?xml version="1.0" encoding="UTF-8" ?>
  <ReisMogelijkheden>
    <ReisMogelijkheid>
      <AantalOverstappen>1</AantalOverstappen>
      <GeplandeReisTijd>1:30</GeplandeReisTijd>
      <ActueleReisTijd>1:30</ActueleReisTijd>
      <Optimaal>false</Optimaal>
      <GeplandeVertrekTijd>2012-02-27T12:51:00+0100</GeplandeVertrekTijd>
      <ActueleVertrekTijd>2012-02-27T12:51:00+0100</ActueleVertrekTijd>
      <GeplandeAankomstTijd>2012-02-27T14:21:00+0100</GeplandeAankomstTijd>
      <ActueleAankomstTijd>2012-02-27T14:21:00+0100</ActueleAankomstTijd>
      <Status>NIET-OPTIMAAL</Status>
      <ReisDeel reisSoort="TRAIN">
        <Vervoerder>NS</Vervoerder>
        <VervoerType>Intercity</VervoerType>
        <RitNummer>1743</RitNummer>
        <Status>VOLGENS-PLAN</Status>
        <ReisStop>
          <Naam>Utrecht Centraal</Naam>
          <Tijd>2012-02-27T12:51:00+0100</Tijd>
          <Spoor wijziging="false">11</Spoor>
        </ReisStop>
        <ReisStop>
          <Naam>Amersfoort</Naam>
          <Tijd>2012-02-27T13:08:00+0100</Tijd>
        </ReisStop>
        <ReisStop>
          <Naam>Apeldoorn</Naam>
          <Tijd>2012-02-27T13:32:00+0100</Tijd>
          <Spoor wijziging="false">4</Spoor>
        </ReisStop>
      </ReisDeel>
      <ReisDeel reisSoort="TRAIN">
        <Vervoerder>NS</Vervoerder>
        <VervoerType>Sprinter</VervoerType>
        <RitNummer>7043</RitNummer>
        <Status>VOLGENS-PLAN</Status>
        <ReisStop>
          <Naam>Apeldoorn</Naam>
          <Tijd>2012-02-27T13:38:00+0100</Tijd>
          <Spoor wijziging="false">3</Spoor>
        </ReisStop>
        <ReisStop>
          <Naam>Apeldoorn Osseveld</Naam>
          <Tijd>2012-02-27T13:42:00+0100</Tijd>
        </ReisStop>
        <ReisStop>
          <Naam>Twello</Naam>
          <Tijd>2012-02-27T13:47:00+0100</Tijd>
        </ReisStop>
        <ReisStop>
          <Naam>Deventer</Naam>
          <Tijd>2012-02-27T13:55:00+0100</Tijd>
        </ReisStop>
        <ReisStop>
          <Naam>Deventer Colmschate</Naam>
          <Tijd>2012-02-27T14:00:00+0100</Tijd>
        </ReisStop>
        <ReisStop>
          <Naam>Holten</Naam>
          <Tijd>2012-02-27T14:08:00+0100</Tijd>
        </ReisStop>
        <ReisStop>
          <Naam>Rijssen</Naam>
          <Tijd>2012-02-27T14:15:00+0100</Tijd>
        </ReisStop>
        <ReisStop>
          <Naam>Wierden</Naam>
          <Tijd>2012-02-27T14:21:00+0100</Tijd>
          <Spoor wijziging="false">1</Spoor>
        </ReisStop>
      </ReisDeel>
    </ReisMogelijkheid>
  <ReisMogelijkheid>
  <Melding>
    <Id>2012_gn_asn_25feb_4mrt</Id>
    <Ernstig>false</Ernstig>
    <Text>Let op, werk aan het spoor Assen - Groningen</Text>
  </Melding>
  <AantalOverstappen>1</AantalOverstappen>
  <GeplandeReisTijd>1:18</GeplandeReisTijd>
  <ActueleReisTijd>1:18</ActueleReisTijd>
  <Optimaal>false</Optimaal>
  <GeplandeVertrekTijd>2012-03-02T13:17:00+0100</GeplandeVertrekTijd>
  <ActueleVertrekTijd>2012-03-02T13:17:00+0100</ActueleVertrekTijd>
  <GeplandeAankomstTijd>2012-03-02T14:35:00+0100</GeplandeAankomstTijd>
  <ActueleAankomstTijd>2012-03-02T14:35:00+0100</ActueleAankomstTijd>
  <Status>VOLGENS-PLAN</Status>
  <ReisDeel reisSoort="TRAIN">
    <Vervoerder>NS</Vervoerder>
    <VervoerType>Intercity</VervoerType>
    <RitNummer>541</RitNummer>
    <Status>VOLGENS-PLAN</Status>
    <ReisStop>
      <Naam>Zwolle</Naam>
      <Tijd>2012-03-02T13:17:00+0100</Tijd>
      <Spoor wijziging="false">3</Spoor>
    </ReisStop>
    <ReisStop>
      <Naam>Assen</Naam>
      <Tijd>2012-03-02T13:57:00+0100</Tijd>
      <Spoor wijziging="false">2</Spoor>
    </ReisStop>
  </ReisDeel>
  <ReisDeel reisSoort="TRAIN">
    <Vervoerder>NS</Vervoerder>
    <VervoerType>Snelbus i.p.v. Trein</VervoerType>
    <RitNummer>0</RitNummer>
    <Status>VOLGENS-PLAN</Status>
    <Reisdetails>
      <Reisdetail>Fiets meenemen niet mogelijk</Reisdetail>
    </Reisdetails>
    <GeplandeStoringId>2012_gn_asn_25feb_4mrt</GeplandeStoringId>
    <ReisStop>
      <Naam>Assen</Naam>
      <Tijd>2012-03-02T14:05:00+0100</Tijd>
      <Spoor wijziging="false" />
    </ReisStop>
    <ReisStop>
      <Naam>Groningen</Naam>
      <Tijd>2012-03-02T14:35:00+0100</Tijd>
      <Spoor wijziging="false" />
    </ReisStop>
  </ReisDeel>
  </ReisMogelijkheid>
<ReisMogelijkheid>
  <Melding>
    <Id />
    <Ernstig>true</Ernstig>
    <Text>Dit reisadvies vervalt</Text>
  </Melding>
  <AantalOverstappen>0</AantalOverstappen>
  <GeplandeReisTijd>0:32</GeplandeReisTijd>
  <ActueleReisTijd>0:32</ActueleReisTijd>
  <Optimaal>false</Optimaal>
  <GeplandeVertrekTijd>2012-03-02T12:56:00+0100</GeplandeVertrekTijd>
  <ActueleVertrekTijd>2012-03-02T12:56:00+0100</ActueleVertrekTijd>
  <GeplandeAankomstTijd>2012-03-02T13:28:00+0100</GeplandeAankomstTijd>
  <ActueleAankomstTijd>2012-03-02T13:28:00+0100</ActueleAankomstTijd>
  <Status>NIET-MOGELIJK</Status>
  <ReisDeel reisSoort="TRAIN">
    <Vervoerder>NS</Vervoerder>
    <VervoerType>Intercity</VervoerType>
    <RitNummer>848</RitNummer>
    <Status>GEANNULEERD</Status>
    <OngeplandeStoringId>prio-24008</OngeplandeStoringId>
    <ReisStop>
      <Naam>Maastricht</Naam>
      <Tijd>2012-03-02T12:56:00+0100</Tijd>
      <Spoor wijziging="false">3</Spoor>
    </ReisStop>
    <ReisStop>
      <Naam>Sittard</Naam>
      <Tijd>2012-03-02T13:13:00+0100</Tijd>
    </ReisStop>
    <ReisStop>
      <Naam>Roermond</Naam>
      <Tijd>2012-03-02T13:28:00+0100</Tijd>
      <Spoor wijziging="false">2</Spoor>
    </ReisStop>
  </ReisDeel>
</ReisMogelijkheid>
</ReisMogelijkheden>
    })

    ns_client = Ns::Client.new('key', 'password')
    advice = ns_client.get_travel_advice("Den Bosch", "Eindhoven")

    assert_equal("NIET-MOGELIJK", advice[2]["Status"] )
  end

end