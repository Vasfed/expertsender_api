require 'spec_helper'

describe ExpertSenderApi::Email::Snippet do
  context :with_valid_attributes do
    let(:valid_attributes) { { name: 'TestSnippetName',
                               value: 'TestSnippetValue' } }

    subject do
      ExpertSenderApi::Email::Snippet.new valid_attributes
    end

    it 'has proper attributes' do
      expect(subject.name).to eq valid_attributes[:name]
      expect(subject.value).to eq valid_attributes[:value]
    end

    it 'generates proper markup' do
      builder = Nokogiri::XML::Builder.new do |xml|
        subject.insert_to(xml)
      end

      xml = Nokogiri::XML(builder.to_xml)

      expect(xml.xpath('//Name').text).to eq valid_attributes[:name]
      expect(xml.xpath('//Value').text).to eq valid_attributes[:value]
    end
  end
end


