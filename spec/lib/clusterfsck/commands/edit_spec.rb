require 'spec_helper'
require 'commander'
require 'clusterfsck/cli'

module ClusterFsck::Commands
  describe Edit do
    let(:key) { "test-key" }
    let(:mock_writer) { mock("writer", set: true) }

    let(:dummy_val) do
      {
          key => {
            'test' => true
          }
      }
    end

    let(:dummy_yaml) { YAML.dump(dummy_val) }
    let(:mock_s3_obj) do
      mock(:s3_object, {
          read: dummy_yaml,
          versions: mock('versions', count: 3),
          :exists? => true
      })
    end

    before do
      ClusterFsck::Reader.any_instance.stub(:s3_object).and_return(mock_s3_obj)
    end

    describe "with a key" do
      let(:args) { [key] }

      it "should open the yaml version of the key in an editor" do
        subject.should_receive(:ask_editor).with(dummy_yaml).and_return(dummy_yaml)
        subject.stub(:writer).and_return(mock_writer)
        mock_writer.should_receive(:set).with(dummy_val, mock_s3_obj.versions.count).once

        subject.run_command(args)
      end

      it "should error when it is locally overriden" do
        subject.reader.stub(:has_local_override?).and_return(true)
        ->() { subject.run_command(args) }.should raise_error(ArgumentError)
      end

    end
  end
end
