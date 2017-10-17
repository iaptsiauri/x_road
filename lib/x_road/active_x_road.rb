module XRoad
  class ActiveXRoad
    def self.create_header(user_id)
      client = config.client
      service = config.service
      id = UUIDTools::UUID.random_create.to_s
      id.delete! '-'
      {
        'xrd:client' => {
          '@id:objectType': 'SUBSYSTEM',
          content!: {
            'id:xRoadInstance': config.instance,
            'id:memberClass': client.member_class,
            'id:memberCode': client.member_code,
            'id:subsystemCode': client.subsystem_code
          }
        },
        "xrd:service" => {
          '@id:objectType': 'SERVICE',
          content!: {
            'id:xRoadInstance': config.instance,
            'id:memberClass': service.member_class,
            'id:memberCode': service.member_code,
            'id:subsystemCode': service.subsystem_code,
            'id:serviceCode': service.service_code,
            'id:serviceVersion': service.version
          }
        },
        'xrd:id': id,
        'xrd:userId': user_id,
        'xrd:protocolVersion': config.protocol_version
      }
    end

    def self.request(action, namespace, header, body)
      client = create_client(namespace)
      response = client.call(
        action,
        :soap_header => header,
        :message => body
      )
      response.body
    end

    def self.create_client(ns)
      conf = config
      Savon.client do
        endpoint conf.host
        ssl_cert_file conf.client_cert
        ssl_cert_key_file conf.client_key
        pretty_print_xml true
        ssl_verify_mode conf.ssl_verify
        log true
        log_level conf.log_level
        convert_attributes_to proc { [] }
        namespace_identifier "prod"
        namespace ns
        namespaces(
          "xmlns:xrd" => "http://x-road.eu/xsd/xroad.xsd",
          "xmlns:id" => "http://x-road.eu/xsd/identifiers",
          "xmlns:prod" => ns
        )
      end
    end

    def self.config
      XRoad.configuration
    end
  end
end
