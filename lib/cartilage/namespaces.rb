module Cartilage
  module Namespaces
    extend ActiveSupport::Concern

    module ClassMethods
      #
      # Determine the application namespaces based on the directory structure of the
      # project. Each subdirectory in root/assets/javascripts/views will become a namespace
      # in Cartilage.Application.Views.
      #
      def namespaces
        @namespaces ||= {
          'Views' => namespace_from_dir(File.join(javascripts_path, 'views'))
        }
      end

      #
      # List the view classes and their namespaces, for the purpose of handing references of each
      # namespace to its respective views.
      #
      def views
        @views ||= begin
          views_dir = Pathname.new(File.join(javascripts_path, 'views'))
          views     = Dir[File.join(views_dir, '**', '*.js.*')]
          views.collect do |file|
            path = Pathname.new(file).relative_path_from(views_dir).to_s
            {
              namespace: path_to_namespace(File.dirname(path)),
              class:     File.basename(path).split('.').first.camelize
            }
          end
        end
      end

      private

      #
      # Get the path to the Rails app's javascripts directory.
      #
      def javascripts_path
        @javascripts_path ||= File.join(Rails.root, 'app', 'assets', 'javascripts')
      end

      #
      # Get the nested Hash representing the directories under the specified path.
      #
      def namespace_from_dir(path, root=nil)
        relative_path = root && Pathname.new(path).relative_path_from(Pathname.new(root)).to_s
        children = {}
        children['fqn'] = path_to_namespace(relative_path) if relative_path
        if Dir.exists?(path)
          root ||= path
          Dir.foreach(path) do |entry|
            next if (entry == '..' || entry == '.')
            full_path = File.join(path, entry)
            if File.directory?(full_path)
              children[entry.capitalize] = namespace_from_dir(full_path, root)
            end
          end
        end
        children
      end

      def path_to_namespace(path)
        path.split(File::SEPARATOR).collect(&:capitalize).join('.')
      end
    end

  end
end
