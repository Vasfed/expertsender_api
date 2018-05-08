require 'spec_helper'

describe ExpertSenderApi::Subscriber::Tag do
  context :with_valid_attributes do
    let(:properties) { [ExpertSenderApi::Subscriber::Property.new(id: 123,
                                                                  value: 'test',
                                                                  type: 'string'),
                        ExpertSenderApi::Subscriber::Property.new(id: 456,
                                                                  value: 'test1',
                                                                  type: 'string')] }
    let(:valid_attributes) { { list_id: 52,
                               email: 'test@httplab.ru',
                               mode: ExpertSenderApi::Subscriber::Tag::MODE_ADD_AND_IGNORE,
                               id: 777,
                               firstname: 'Test1',
                               lastname: 'Test2',
                               name: 'Test3',
                               tracking_code: '123',
                               vendor: 'Vendor',
                               ip: '127.0.0.1',
                               properties: properties } }

    subject do
      ExpertSenderApi::Subscriber::Tag.new valid_attributes
    end

    it 'has proper attributes' do
      valid_attributes.each do |key, value|
        expect(subject.send(key)).to eq value
      end
    end

    it 'generates proper markup' do
      builder = Nokogiri::XML::Builder.new do |xml|
        subject.insert_to(xml)
      end

      xml = Nokogiri::XML(builder.to_xml)

      expect(xml.xpath('//Subscriber/ListId').text.to_i).to eq valid_attributes[:list_id]
      expect(xml.xpath('//Subscriber/Email').text).to eq valid_attributes[:email]
      expect(xml.xpath('//Subscriber/Mode').text).to eq valid_attributes[:mode]
      expect(xml.xpath('//Subscriber/Id').text.to_i).to eq valid_attributes[:id]
      expect(xml.xpath('//Subscriber/Firstname').text).to eq valid_attributes[:firstname]
      expect(xml.xpath('//Subscriber/Lastname').text).to eq valid_attributes[:lastname]
      expect(xml.xpath('//Subscriber/Name').text).to eq valid_attributes[:name]
      expect(xml.xpath('//Subscriber/TrackingCode').text).to eq valid_attributes[:tracking_code]
      expect(xml.xpath('//Subscriber/Vendor').text).to eq valid_attributes[:vendor]
      expect(xml.xpath('//Subscriber/Ip').text).to eq valid_attributes[:ip]

      properties.each_with_index do |property, i|
        xml_prop = xml.xpath('//Subscriber/Properties/Property')[i]
        expect(xml_prop.xpath('Id').text.to_i).to eq property.id
        expect(xml_prop.xpath('Value').attribute('xsi:type').value).to eq "xs:#{property.type}"
        expect(xml_prop.xpath('Value').text).to eq property.value
      end
    end
  end
end

