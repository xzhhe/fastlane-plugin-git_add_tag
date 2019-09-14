require 'fastlane/action'
require_relative '../helper/git_add_tag_helper'

module Fastlane
  module Actions
    class GitAddTagAction < Action
      def self.run(params)
        workspace = params[:workspace]
        prefix = params[:prefix]
        branch = params[:branch]
        commit = params[:commit]
        tag_message = params[:tag_message]

        # "git tag -a <tag_name> <commit> -m \"<tag 描述信息>\""; git push origin <tag_name>
        cmds = ["cd #{workspace}"]
        
        tag = tag_name(params)
        UI.user_error!("❌  tag get failed") unless tag

        add_tag = if commit
          "git tag -a #{tag} #{commit}"
        elsif branch
          "git tag -a #{tag} #{branch}"
        else
          "git tag -a #{tag}"
        end
        add_tag = "#{add_tag} -m \"#{tag_message}\"" if tag_message
        cmds << add_tag
        cmds << "git push origin #{tag}"

        output = Actions.sh(cmds.join(';'))
        if output.include?('fatal')
          UI.user_error!("❌ #{output}")
        end

        UI.message("git add tag #{tag} SUCCESS ✅")
      end

      def self.tag_name(params)
        workspace = params[:workspace]
        prefix = params[:prefix]
        tag_name = params[:tag_name]

        if tag_name
          if prefix
            return "#{prefix}#{tag_name}"
          else
            return tag_name
          end
        else
          cmds = ["cd #{workspace}", "git fetch --tags"]
          if prefix
            cmds << "git tag --list '#{prefix}*'"
          else
            cmds << "git tag"
          end

          cmd = cmds.join(';')
          tags_str = `#{cmd}`
          return nil unless tags_str

          tags = tags_str.split("\n")
          return nil if tags.empty?

          if prefix
            return "#{prefix}#{increate_tag(max_tag(tags, prefix))}"
          else
            return increate_tag(max_tag(tags, prefix))
          end
        end
      end

      def self.increate_tag(tag)
        versions = tag.split(".").map(&:to_i)
        versions[versions.count - 1] = pp versions[versions.count - 1] + 1
        versions.join('.')
      end

      def self.max_tag(tags, prefix)
        tags.map { |t|
          if t =~ /#{prefix}(.*)/
            Gem::Version.create($1)
          else
            nil
          end
        }.compact.sort { |v1, v2|
          v2 <=> v1
        }.map(&:to_s).first
      end
      
      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        ["xiongzenghui"]
      end

      def self.description
        "git add tag wrapper"
      end

      def self.details
        "git add tag wrapper"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :workspace,
            description: "where are you git repo dir ???",
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :prefix,
            description: "tag name prefix, like: master_1.2.3 , v1.0.0",
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :tag_name,
            description: "you specify a tag name",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :branch,
            description: "add a tag on a branch",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :commit,
            description: "add a tag on a commit",
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :tag_message,
            description: "tag message",
            optional: false
          )
        ]
      end

      def self.category
        :source_control
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
