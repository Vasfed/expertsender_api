require 'spec_helper'

describe ExpertSenderApi::Email::Receiver do
  context :with_valid_attributes do
    let(:valid_attributes) { { id: '777',
                               email: 'test@test.com',
                               list_id: '53' } }

    subject do
      ExpertSenderApi::Email::Receiver.new valid_attributes
    end

    it 'has proper attributes' do
      expect(subject.id).to eq valid_attributes[:id]
      expect(subject.email).to eq valid_attributes[:email]
      expect(subject.list_id).to eq valid_attributes[:list_id]
    end

    it 'generates proper markup' do
      builder = Nokogiri::XML::Builder.new do |xml|
        subject.insert_to(xml)
      end

      xml = Nokogiri::XML(builder.to_xml)

      expect(xml.xpath('//Receiver/Id').text).to eq valid_attributes[:id]
      expect(xml.xpath('//Receiver/Email').text).to eq valid_attributes[:email]
      expect(xml.xpath('//Receiver/ListId').text).to eq valid_attributes[:list_id]
    end
  end
end


