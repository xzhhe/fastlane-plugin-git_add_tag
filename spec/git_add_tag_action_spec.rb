describe Fastlane::Actions::GitAddTagAction do
  describe '#run' do
    it 'prints a message' do
      Fastlane::Actions::GitAddTagAction.run(
        workspace: '/Users/xiongzenghui/Desktop/haha',
        # tag_name: '1.0.0',
        prefix: 'v',
      )

      # pp Gem::Version.new("0.1.0").bump
      # pp Gem::Version.new("0.1.0") > Gem::Version.new("0.2.0")
      # pp Gem::Version.new("0.1.0") >= Gem::Version.new("0.2.0")
      # pp Gem::Version.new("0.1.0") < Gem::Version.new("0.2.0")
      # pp Gem::Version.new("0.1.0") <= Gem::Version.new("0.2.0")
      # pp Gem::Version.new("0.1.0") <=> Gem::Version.new("0.2.0")
    end
  end
end
