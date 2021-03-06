require 'spec_helper'
require 'commander'
require 'clusterfsck/cli'

module ClusterFsck::Commands
  describe Create do

    let(:cluster_fsck_env) { "test" }
    let(:args) { ["test-key"] }
    let(:mock_s3_object) do
      mock("s3_obj",
        :"exists?" => false,
        :write => true
      )
    end

    before do
      ClusterFsck::Commands::Edit.any_instance.stub(:run_command).and_return(true)
      subject.stub(:s3_object).and_return(mock_s3_object)
    end

    it "should create the file" do
      mock_s3_object.should_receive(:write).with("")
      subject.run_command(args)
    end

    it "should open the editor with the file" do
      ClusterFsck::Commands::Edit.any_instance.should_receive(:run_command).with(args).and_return(true)
      subject.run_command(args)
    end

    it "should error and not write if the file already exists" do
      mock_s3_object.stub(:exists?).and_return(true)
      mock_s3_object.should_not_receive(:write)
      ->() { subject.run_command(args) }.should raise_error(ClusterFsck::S3Methods::ConflictError)
    end

  end


end
