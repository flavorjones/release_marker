require 'release_marker'

require 'tmpdir'

module TmpDirHelpers
  def in_a_tmp_dir
    Dir.mktmpdir { |dir| Dir.chdir(dir) { yield } }
  end
end
RSpec.configure { include TmpDirHelpers }
