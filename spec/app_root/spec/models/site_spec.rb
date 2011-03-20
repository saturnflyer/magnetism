require 'spec_helper'

describe Site do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:domain) }
  it { should validate_numericality_of(:theme_id) }

  it { should allow_value(true).for(:production) }
  it { should allow_value(false).for(:production) }

  it { should have_many(:pages) }
  it { should have_many(:assets) }

  it { should belong_to(:homepage) }
  it { should belong_to(:theme) }

  context 'when a site exists' do
    before(:each) { Factory(:site) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:domain) }
  end

  describe '#key' do
    it 'returns an md5 sum of the site id' do
      site = Factory(:site)
      site.key.should == Digest::MD5.new(site.id).to_s
    end
  end

  context 'when a site is created' do
    before(:each) do
      @site = Factory(:site)
    end

    it 'makes a "Homepage" page' do
      @site.homepage.should_not be_nil
      @site.homepage.new_record?.should == false
    end
  end
end
