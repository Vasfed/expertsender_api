require 'spec_helper'

describe ExpertSenderApi::Subscriber::Property do
  context :with_valid_attributes do
    let(:valid_attributes) { { id: 123,
                               type: 'string',
                               value: 'Test Property Value' } }

    subject do
      ExpertSenderApi::Subscriber::Property.new valid_attributes
    end

    it 'has proper attributes' do
      expect(subject.id).to eq valid_attributes[:id]
      expect(subject.type).to eq valid_attributes[:type]
      expect(subject.value).to eq valid_attributes[:value]
    end

    it 'generates proper markup' do
      builder = Nokogiri::XML::Builder.new do |xml|
        subject.insert_to(xml)
      end

      xml = Nokogiri::XML(builder.to_xml)

      expect(xml.xpath('//Property/Id').text.to_i).to eq valid_attributes[:id]
      expect(xml.xpath('//Property/Value').attribute('xsi:type').value).to eq "xs:#{valid_attributes[:type]}"
      expect(xml.xpath('//Property/Value').text).to eq valid_attributes[:value]
    end
  end
end
