require 'spec_helper'

describe AppointmentsHelper do

  describe "#now_rounded_to_next_hour" do

    context "when it is at the top of the hour" do
      let(:now) { Time.new 2014, 01, 01, 12, 00, 00 }

      before(:each) { Time.stub(:now).and_return(now) }

      it "should return the next hour on the same day" do
        expect(helper.now_rounded_to_next_hour).to eq(
          Time.new(2014, 01, 01, 13, 00, 00))
      end
    end

    context "when it is during an hour" do
      let(:now) { Time.new 2014, 01, 01, 12, 15, 00 }

      before(:each) { Time.stub(:now).and_return(now) }

      it "should return the next hour on the same day" do
        expect(helper.now_rounded_to_next_hour).to eq(
          Time.new(2014, 01, 01, 13, 00, 00))
      end
    end

    context "when it is after 11pm" do
      let(:now) { Time.new 2014, 01, 01, 23, 01, 00 }

      before(:each) { Time.stub(:now).and_return(now) }
      
      it "should return 12:00am on the next day" do
        expect(helper.now_rounded_to_next_hour).to eq(
          Time.new(2014, 01, 02, 00, 00, 00))
      end
    end

  end

end
