require 'rest-client'

describe Ovirt::Service do
  let(:service) { build(:service) }

  context "#resource_post" do
    it "raises Ovirt::Error if HTTP 409 response code received" do
      error_detail = "API error"
      return_data  = <<-EOX.chomp
<action>
    <fault>
        <detail>#{error_detail}</detail>
    </fault>
</action>
EOX

      rest_client = double('rest_client').as_null_object
      expect(rest_client).to receive(:post) do |&block|
        allow(return_data).to receive(:code).and_return(409)
        block.call(return_data)
      end

      allow(service).to receive(:create_resource).and_return(rest_client)
      expect { service.resource_post('uri', 'data') }.to raise_error(Ovirt::Error, error_detail)
    end

    it "raises Ovirt::Error if HTTP 409 response code received" do
      error_detail = "Usage message"
      return_data  = <<-EOX.chomp
<usage_message>
  <message>#{error_detail}</message>
</usage_message>
EOX

      rest_client = double('rest_client').as_null_object
      expect(rest_client).to receive(:post) do |&block|
        allow(return_data).to receive(:code).and_return(409)
        block.call(return_data)
      end

      allow(service).to receive(:create_resource).and_return(rest_client)
      expect { service.resource_post('uri', 'data') }.to raise_error(Ovirt::UsageError, error_detail)
    end
  end

  describe "#ca_certificate" do
    let(:letsencrypt_org_certificate) do
<<-EOC
-----BEGIN CERTIFICATE-----
MIIFYDCCA0igAwIBAgIQCgFCgAAAAUUjyES1AAAAAjANBgkqhkiG9w0BAQsFADBK
MQswCQYDVQQGEwJVUzESMBAGA1UEChMJSWRlblRydXN0MScwJQYDVQQDEx5JZGVu
VHJ1c3QgQ29tbWVyY2lhbCBSb290IENBIDEwHhcNMTQwMTE2MTgxMjIzWhcNMzQw
MTE2MTgxMjIzWjBKMQswCQYDVQQGEwJVUzESMBAGA1UEChMJSWRlblRydXN0MScw
JQYDVQQDEx5JZGVuVHJ1c3QgQ29tbWVyY2lhbCBSb290IENBIDEwggIiMA0GCSqG
SIb3DQEBAQUAA4ICDwAwggIKAoICAQCnUBneP5k91DNG8W9RYYKyqU+PZ4ldhNlT
3Qwo2dfw/66VQ3KZ+bVdfIrBQuExUHTRgQ18zZshq0PirK1ehm7zCYofWjK9ouuU
+ehcCuz/mNKvcbO0U59Oh++SvL3sTzIwiEsXXlfEU8L2ApeN2WIrvyQfYo3fw7gp
S0l4PJNgiCL8mdo2yMKi1CxUAGc1bnO/AljwpN3lsKImesrgNqUZFvX9t++uP0D1
bVoE/c40yiTcdCMbXTMTEl3EASX2MN0CXZ/g1Ue9tOsbobtJSdifWwLziuQkkORi
T0/Br4sOdBeo0XKIanoBScy0RnnGF7HamB4HWfp1IYVl3ZBWzvurpWCdxJ35UrCL
vYf5jysjCiN2O/cz4ckA82n5S6LgTrx+kzmEB/dEcH7+B1rlsazRGMzyNeVJSQjK
Vsk9+w8YfYs7wRPCTY/JTw436R+hDmrfYi7LNQZReSzIJTj0+kuniVyc0uMNOYZK
dHzVWYfCP04MXFL0PfdSgvHqo6z9STQaKPNBiDoT7uje/5kdX7rL6B7yuVBgwDHT
c+XvvqDtMwt0viAgxGds8AgDelWAf0ZOlqf0Hj7h9tgJ4TNkK2PXMl6f+cB7D3hv
l7yTmvmcEpB4eoCHFddydJxVdHixuuFucAS6T6C6aMN7/zHwcz09lCqxC0EOoP5N
iGVreTO01wIDAQABo0IwQDAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB
/zAdBgNVHQ4EFgQU7UQZwNPwBovupHu+QucmVMiONnYwDQYJKoZIhvcNAQELBQAD
ggIBAA2ukDL2pkt8RHYZYR4nKM1eVO8lvOMIkPkp165oCOGUAFjvLi5+U1KMtlwH
6oi6mYtQlNeCgN9hCQCTrQ0U5s7B8jeUeLBfnLOic7iPBZM4zY0+sLj7wM+x8uwt
LRvM7Kqas6pgghstO8OEPVeKlh6cdbjTMM1gCIOQ045U8U1mwF10A0Cj7oV+wh93
nAbowacYXVKV7cndJZ5t+qntozo00Fl72u1Q8zW/7esUTTHHYPTa8Yec4kjixsU3
+wYQ+nVZZjFHKdp2mhzpgq7vmrlR94gjmmmVYjzlVYA211QC//G5Xc7UI2/YRYRK
W2XviQzdFKcgyxilJbQN+QHwotL0AMh0jqEqSI5l2xPE4iUXfeu+h1sXIFRRk0pT
AwvsXcoz7WL9RccvW9xYoIA55vrX/hMUpu09lEpCdNTDd1lzzY9GvlU47/rokTLq
l1gEIt44w8y8bckzOmoKaT+gyOpyj4xjhiO9bTyWnpXgSUyqorkqG5w2gXjtw+hG
4iZZRHUe2XWJUc0QhJ1hYMtd+ZciTY6Y5uN/9lu7rs3KSoFrXgvzUeF0K+l+J6fZ
mUlO+KWA2yUPHGNiiskzZ2s8EIPGrd6ozRaOjfAHN3Gf8qv8QfXBi+wAN10J5U6A
7/qxXDgGpRtK4dw4LTzcqx+QGtVKnO7RcGzM7vRX+Bi6hG6H
-----END CERTIFICATE-----
EOC
    end
    let(:rest_client_resource_double) { double("RestClient::Resource") }
    let(:service)                     { build(:service, :server => "test.example.com") }

    before { allow(RestClient::Resource).to receive(:new).and_return(rest_client_resource_double) }

    it 'with a valid certificate' do
      expect(rest_client_resource_double).to receive(:get).once.and_return(letsencrypt_org_certificate)

      2.times { expect(service.ca_certificate).to eq(letsencrypt_org_certificate) }
    end

    it "with invalid certificate" do
      expect(rest_client_resource_double).to receive(:get).and_return("ABCDEFG", "  ", nil)

      3.times { expect(service.ca_certificate).to eq(nil) }
    end

    it "server doesn't respond" do
      expect(rest_client_resource_double).to receive(:get).and_raise(RestClient::ResourceNotFound)

      expect(service.ca_certificate).to eq(nil)
    end
  end

  it "#resource_get on exception" do
    allow(service).to receive(:create_resource).and_raise(Exception, "BLAH")
    expect { service.resource_get('api') }.to raise_error(Exception, "BLAH")
  end

  context "#get_resources_by_uri_path" do
    it "fetches data_center" do
      return_message = <<-EOX.chomp
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<data_center href="/api/datacenters/00000001-0001-0001-0001-0000000000f1" id="00000001-0001-0001-0001-0000000000f1">
    <name>Default</name>
    <description>The default Data Center</description>
    <link href="/api/datacenters/00000001-0001-0001-0001-0000000000f1/storagedomains" rel="storagedomains"/>
    <link href="/api/datacenters/00000001-0001-0001-0001-0000000000f1/clusters" rel="clusters"/>
    <link href="/api/datacenters/00000001-0001-0001-0001-0000000000f1/networks" rel="networks"/>
    <link href="/api/datacenters/00000001-0001-0001-0001-0000000000f1/permissions" rel="permissions"/>
    <link href="/api/datacenters/00000001-0001-0001-0001-0000000000f1/quotas" rel="quotas"/>
    <link href="/api/datacenters/00000001-0001-0001-0001-0000000000f1/qoss" rel="qoss"/>
    <link href="/api/datacenters/00000001-0001-0001-0001-0000000000f1/iscsibonds" rel="iscsibonds"/>
    <local>false</local>
    <storage_format>v3</storage_format>
    <version major="3" minor="6"/>
    <supported_versions>
        <version major="3" minor="6"/>
    </supported_versions>
    <status>
        <state>up</state>
    </status>
    <mac_pool href="/api/macpools/0000000d-000d-000d-000d-00000000037a" id="0000000d-000d-000d-000d-00000000037a"/>
    <quota_mode>disabled</quota_mode>
</data_center>
EOX
      expect(service).to receive(:resource_get).and_return(return_message)

      data_center = service.get_resources_by_uri_path("/api/datacenters/00000001-0001-0001-0001-0000000000f1")
      expect(data_center[0].name).to eq "Default"
    end

    it "returns 404" do
      expect(service).to receive(:resource_get).and_raise(Ovirt::MissingResourceError)
      expect { service.get_resources_by_uri_path("/api/vms/1234") }.to raise_error(Ovirt::MissingResourceError)
    end
  end

  context "#ssh_public_key" do
    let(:base_uri) { "https://nobody.com" }
    let(:old_path) { "/engine.ssh.key.txt" }
    let(:new_path) { "/ovirt-engine/services/pki-resource?resource=engine-certificate&format=OPENSSH-PUBKEY" }
    let(:ssh_key) { "ssh-rsa " + ("A" * 372) + " ovirt-engine\n" }

    before do
      allow(service).to receive(:base_uri).and_return(base_uri)
    end

    it "returns valid key for engine older than 3.5" do
      old_resource = double("RestClient::Resource")
      expect(old_resource).to receive(:get).and_return(ssh_key)
      expect(RestClient::Resource).to receive(:new).with("#{base_uri}#{old_path}", anything).and_return(old_resource)

      new_resource = double("RestClient::Resource")
      expect(new_resource).to receive(:get).and_raise(RestClient::ResourceNotFound)
      expect(RestClient::Resource).to receive(:new).with("#{base_uri}#{new_path}", anything).and_return(new_resource)

      expect(service.engine_ssh_public_key).to eql(ssh_key)
    end

    it "returns valid key for engine 3.5 or newer" do
      new_resource = double("RestClient::Resource")
      expect(new_resource).to receive(:get).and_return(ssh_key)
      expect(RestClient::Resource).to receive(:new).with("#{base_uri}#{new_path}", anything).and_return(new_resource)

      expect(service.engine_ssh_public_key).to eql(ssh_key)
    end

    it "returns nil if there is no engine" do
      old_resource = double("RestClient::Resource")
      expect(old_resource).to receive(:get).and_raise(RestClient::ResourceNotFound)
      expect(RestClient::Resource).to receive(:new).with("#{base_uri}#{old_path}", anything).and_return(old_resource)

      new_resource = double("RestClient::Resource")
      expect(new_resource).to receive(:get).and_raise(RestClient::ResourceNotFound)
      expect(RestClient::Resource).to receive(:new).with("#{base_uri}#{new_path}", anything).and_return(new_resource)

      expect(service.engine_ssh_public_key).to be nil
    end

    it "returns nil when using a wrong REST client method" do
      old_resource = double("RestClient::Resource")
      expect(old_resource).to receive(:get).and_raise(NoMethodError)
      expect(RestClient::Resource).to receive(:new).with("#{base_uri}#{old_path}", anything).and_return(old_resource)

      new_resource = double("RestClient::Resource")
      expect(new_resource).to receive(:get).and_raise(NoMethodError)
      expect(RestClient::Resource).to receive(:new).with("#{base_uri}#{new_path}", anything).and_return(new_resource)

      expect(service.engine_ssh_public_key).to be nil
    end
  end

  context ".ovirt?" do
    it "true when key non-empty" do
      fake_key = "ssh-rsa " + ("A" * 372) + " ovirt-engine\n"
      expect_any_instance_of(described_class).to receive(:engine_ssh_public_key).and_return(fake_key)
      expect(described_class.ovirt?(:server => "127.0.0.1")).to be true
    end

    it "false when key empty" do
      fake_key = "\n"
      expect_any_instance_of(described_class).to receive(:engine_ssh_public_key).and_return(fake_key)
      expect(described_class.ovirt?(:server => "127.0.0.1")).to be false
    end

    it "false when key nil" do
      fake_key = nil
      expect_any_instance_of(described_class).to receive(:engine_ssh_public_key).and_return(fake_key)
      expect(described_class.ovirt?(:server => "127.0.0.1")).to be false
    end
  end

  context "#base_uri" do
    let(:defaults) { {:username => nil, :password => nil} }
    subject { described_class.new(defaults.merge(@options)).send(:base_uri) }

    it "ipv4" do
      @options = {:server => "127.0.0.1"}
      expect(subject).to eq("https://127.0.0.1:443")
    end

    it "ipv6" do
      @options = {:server => "::1"}
      expect(subject).to eq("https://[::1]:443")
    end

    it "hostname" do
      @options = {:server => "nobody.com"}
      expect(subject).to eq("https://nobody.com:443")
    end

    it "port 4443" do
      @options = {:server => "nobody.com", :port => 4443}
      expect(subject).to eq("https://nobody.com:4443")
    end

    it "blank port" do
      @options = {:server => "nobody.com", :port => ""}
      expect(subject).to eq("https://nobody.com")
    end

    it "nil port uses defaults" do
      @options = {:server => "nobody.com", :port => nil}
      expect(subject).to eq("https://nobody.com:443")
    end
  end

  context "#api_uri" do
    let(:base_uri) { "https://nobody.com" }
    let(:api_path) { "/ovirt-engine/api" }

    before do
      expect(service).to receive(:base_uri).and_return(base_uri)
      expect(service).to receive(:api_path).and_return(api_path)
    end   

    it "removes slash" do
      expect(service.api_uri("/vms/123")).to eq("#{base_uri}#{api_path}/vms/123")
    end

    it "removes /api" do
      expect(service.api_uri("/api/vms/123")).to eq("#{base_uri}#{api_path}/vms/123")
    end

    it "removes /ovirt-engine/api" do
      expect(service.api_uri("/ovirt-engine/api/vms/123")).to eq("#{base_uri}#{api_path}/vms/123")
    end

  end

  context "#probe_api_path" do
    let(:rest_client_resource_double) { double("RestClient::Resource") }

    before do
      allow(RestClient::Resource).to receive(:new).and_return(rest_client_resource_double)
    end

    def rest_exception(code = nil, headers = {})
      response = double('response').as_null_object
      expect(response).to receive(:code).and_return(code)
      allow(response).to receive(:headers).and_return(headers)
      RestClient::Exception.new(response)
    end

    it "returns false for nil response" do
      allow(rest_client_resource_double).to receive(:get).and_raise(RestClient::Exception.new)
      expect(service.probe_api_path('http://some', 'path')).to eq(false)
    end

    it "returns false for 401 and empty headers" do
      allow(rest_client_resource_double).to receive(:get).and_raise(rest_exception(401))
      expect(service.probe_api_path('http://some', 'path')).to eq(false)
    end

    it "returns false for other code" do
      allow(rest_client_resource_double).to receive(:get).and_raise(rest_exception(404))
      expect(service.probe_api_path('http://some', 'path')).to eq(false)
    end

    it "returns false if no exception thrown" do
      allow(rest_client_resource_double).to receive(:get)
      expect(service.probe_api_path('http://some', 'path')).to eq(false)
    end

    it "returns true for 401 and correct headers" do
      allow(rest_client_resource_double).to receive(:get).and_raise(
        rest_exception(401, :www_authenticate => "Basic realm=RESTAPI"))
      expect(service.probe_api_path('http://some', 'path')).to eq(true)
    end
  end

  context "#version" do
    it "with :full_version" do
      allow(service).to receive(:product_info).and_return(:full_version => "3.4.5-0.3.el6ev", :version => {:major => "3", :minor => "4", :build => "0", :revision => "0"})
      expect(service.version).to eq(:major => "3", :minor => "4", :revision => "5", :build => "0")
    end

    it "without :full_version" do
      allow(service).to receive(:product_info).and_return(:version => {:major => "3", :minor => "4", :build => "0", :revision => "0"})
      expect(service.version).to eq(:major => "3", :minor => "4", :revision => "0", :build => "0")
    end
  end
end
