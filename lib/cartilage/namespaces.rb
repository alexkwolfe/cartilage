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
        @namespaces ||= begin
          { 'Views' => namespace_from_dir(File.join(javascripts_path, 'views')) }
        end
      end

      def views
        views_dir = Pathname.new(File.join(javascripts_path, 'views'))
        views = Dir[File.join(views_dir, '**', '*.js.*')]
        views.collect do |file|
          path = Pathname.new(file).relative_path_from(views_dir).to_s
          {
            namespace: File.dirname(path).split(File::SEPARATOR).collect(&:capitalize).join('.'),
            class: File.basename(path).split('.').first.camelize
          }
        end
      end

      private

      def javascripts_path
        @javascripts_path ||= File.join(Rails.root, 'app', 'assets', 'javascripts')
      end

      def namespace_from_dir(path)
        children = { }
        if Dir.exists?(path)
          Dir.foreach(path) do |entry|
            next if (entry == '..' || entry == '.')
            full_path = File.join(path, entry)
            if File.directory?(full_path)
              children[entry.capitalize] = namespace_from_dir(full_path)
            end
          end
        end
        children
      end
    end

  end
end
