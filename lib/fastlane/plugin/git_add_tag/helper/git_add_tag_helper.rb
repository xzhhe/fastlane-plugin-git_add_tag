require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GitAddTagHelper
      # class methods that you define here become available in your action
      # as `Helper::GitAddTagHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the git_add_tag plugin helper!")
      end
    end
  end
end
