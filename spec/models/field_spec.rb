require 'spec_helper'

describe Field do
  it { should belong_to(:template) }
  it { should belong_to(:field_type) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:template_id) }
  it { should validate_presence_of(:field_type_id) }

  context 'when a field exists' do
    before(:each) { Factory(:field) }
    it { should validate_uniqueness_of(:name).scoped_to(:template_id) }
  end

  describe '#auto_position' do
    let(:template) do
      field = Factory(:field)
      field.template
    end

    it 'sets the position attribute to the total number of fields for that template' do
      field = Factory(:field, :template => template)
      field.position.should == template.fields.count
    end
  end
end