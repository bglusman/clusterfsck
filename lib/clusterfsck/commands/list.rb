require 'commander'

module ClusterFsck
  module Commands
    class List
      include ClusterFsck::S3Methods

      def run_command(args, options = {})
        @cluster_fsck_env = if args.length > 0
                        args.first
                      else
                        ClusterFsck.cluster_fsck_env
                      end

        $stdout.puts(all_files.join("\n"))
      end

    end
  end
end
