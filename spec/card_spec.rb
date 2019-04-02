require 'spec_helper'
require_relative '../lib/card'

RSpec.describe Card do
  before do
    @card = Card.new(:hearts, :ten, 10)
  end

  it 'has a suit' do
    expect(@card.suit).to be :hearts
  end

  it 'has a name' do
    expect(@card.name).to be :ten
  end

  it 'has a value' do
    expect(@card.value).to be 10
  end
end
