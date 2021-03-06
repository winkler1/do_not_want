require 'active_record'
require 'do_not_want'
require 'gems/fake_gem'

class Walrus
  def be_killed_by!(killer, reason)
    die!
    "killed by #{killer} because #{reason}"
  end

  def die!
  end

  do_not_want! :be_killed_by!, 'because dying sucks'
end

describe 'do not want' do
  let(:walrus) { Walrus.new }

  context "method calls" do
    it "raises an error for unwanted method calls" do
      walrus.should_not_receive(:die!)
      expect do
        walrus.be_killed_by!
      end.to raise_error(DoNotWant::NotSafe)
    end

    it "lets other methods through" do
      walrus.class.should == Walrus
    end
  end

  context "caller filtering" do
    it "ignores calls from gems" do
      walrus.should_receive(:die!)
      expect do
        kill_walrus_from_gem(walrus)
      end.not_to raise_error
    end

    it "passes arguments" do
      kill_walrus_from_gem(walrus).should == 'killed by kitty because kitty is angry'
    end
  end
end

