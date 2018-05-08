require 'spec_helper'

describe ExpertSenderApi::Email::Content do
  context :with_valid_attributes do
    let(:valid_attributes) { { from_name: 'From Name Test',
                               from_email: 'test@httplab.ru',
                               reply_to_name: 'Reply To Name Test',
                               reply_to_email: 'Reply To Email Test',
                               subject: 'Subject test',
                               html: 'Html Test Content',
                               plain: 'Plain Test Content' } }

    subject do
      ExpertSenderApi::Email::Content.new valid_attributes
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

      expect(xml.xpath('//FromName').text).to eq valid_attributes[:from_name]
      expect(xml.xpath('//FromEmail').text).to eq valid_attributes[:from_email]
      expect(xml.xpath('//ReplyToName').text).to eq valid_attributes[:reply_to_name]
      expect(xml.xpath('//ReplyToEmail').text).to eq valid_attributes[:reply_to_email]
      expect(xml.xpath('//Subject').text).to eq valid_attributes[:subject]
      expect(xml.xpath('//Html').text).to eq valid_attributes[:html]
      expect(xml.xpath('//Plain').text).to eq valid_attributes[:plain]
    end
  end
end


