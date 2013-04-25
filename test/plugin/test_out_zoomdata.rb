require 'helper'

class ZoomdataOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def stub_zoomdata(source='testsource',url="https://user:pass@localhost:#{ZOOMDATA_TEST_LISTEN_PORT}/zoomdata-web/service/upload?source=")
    stub_request(:post, url+source).with do |req|
      @post_json = JSON.parse(req.body)
    end
  end

  ZOOMDATA_TEST_LISTEN_PORT = 443

  CONFIG_NO_SOURCE = %[
    endpoint_url https://localhost:#{ZOOMDATA_TEST_LISTEN_PORT}/zoomdata-web/service/upload
    ssl          true
    username     user
    password     pass
  ]

  CONFIG_WITH_SOURCE = %[
    endpoint_url https://localhost:#{ZOOMDATA_TEST_LISTEN_PORT}/zoomdata-web/service/upload
    ssl          true
    sourcename   testsource
    username     user
    password     pass
  ]

  def sample_json
    {'test' => 100}
  end

  def create_driver(conf = CONFIG_NO_SOURCE, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::ZoomdataOutput, tag).configure(conf)
  end

  def test_configure
    d = create_driver(CONFIG_NO_SOURCE)
    assert_equal("https://localhost:#{ZOOMDATA_TEST_LISTEN_PORT}/zoomdata-web/service/upload", d.instance.endpoint_url)
    assert_equal(true, d.instance.ssl)
    assert_equal(false, d.instance.verify_ssl)
    assert_equal("user", d.instance.username)
    assert_equal("pass", d.instance.password)
    assert_nil(d.instance.sourcename)

    d = create_driver(CONFIG_WITH_SOURCE)
    assert_equal("https://localhost:#{ZOOMDATA_TEST_LISTEN_PORT}/zoomdata-web/service/upload", d.instance.endpoint_url)
    assert_equal(true, d.instance.ssl)
    assert_equal(false, d.instance.verify_ssl)
    assert_equal("user", d.instance.username)
    assert_equal("pass", d.instance.password)
    assert_equal("testsource", d.instance.sourcename)

  end

  # exist source config
  def test_emit_with_source
    stub_zoomdata
    d = create_driver(CONFIG_WITH_SOURCE)
    d.emit(sample_json)
    d.run
    assert_requested(:post, "https://user:pass@localhost:#{ZOOMDATA_TEST_LISTEN_PORT}/zoomdata-web/service/upload?source=testsource",
                     :body => sample_json, :headers => {'Content-Type' => 'application/json'})
  end

  # no source config
  def test_emit_no_source
    stub_zoomdata('test')
    d = create_driver(CONFIG_NO_SOURCE)
    d.emit(sample_json)
    d.run
    assert_requested(:post, "https://user:pass@localhost:#{ZOOMDATA_TEST_LISTEN_PORT}/zoomdata-web/service/upload?source=test",
                     :body => sample_json, :headers => {'Content-Type' => 'application/json'})

  end

  def test_emit_2

  end
end
