require 'spec_helper'
require 'scraper/scraper'
require 'scraper/carrot'

describe Scraper::Importer do
  let(:valid_record) do
    [
      {
        'id' => 1,
        'latitude' => 12,
        'longitude' => 52,
        'vehicle_types' => '1,2,3',
        'vehicles' => 12,
      },
    ]
  end

  let(:invalid_record) do
    [
      {
        'id' => 1,
        'longitude' => 52,
        'vehicle_types' => '1,2,3',
        'vehicles' => 12,
      },
    ]
  end

  let(:validation) { described_class.new(single_scraper).valid_records? }
  let(:single_scraper) { double('single_scraper', provider: 'Spec Cars', stations: record) }

  context 'with valid record' do
    let(:record) { valid_record }

    it 'recognizes as valid' do
      expect(validation).to eq true
    end
  end

  context 'with invalid record' do
    let(:record) { invalid_record }

    it 'recognizes as valid' do
      expect(validation).to eq false
    end
  end
end
