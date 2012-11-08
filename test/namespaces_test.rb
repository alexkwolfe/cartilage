require 'test_helper'
require 'fileutils'
require 'mocha'

class NamespacesTest < ActiveSupport::TestCase
  include Cartilage::Namespaces::ClassMethods

  test 'namespaces' do
    Dir.mktmpdir do |dir|

      Rails.stubs(:root).returns(dir)

      sub_dir = File.join(Rails.root, 'app', 'assets', 'javascripts', 'views')

      FileUtils.mkdir_p(File.join(sub_dir, 'bip', 'bap', 'zip'))
      FileUtils.mkdir_p(File.join(sub_dir, 'bip', 'zap'))
      FileUtils.mkdir_p(File.join(sub_dir, 'foo', 'bar'))

      expected = {
        'Bip' => {
          'fqn' => 'Bip',
          'Bap'   => {
            'fqn' => 'Bip.Bap',
            'Zip'   => {
              'fqn' => 'Bip.Bap.Zip'
            }
          },
          'Zap'   => {
            'fqn' => 'Bip.Zap'
          }
        },
        'Foo' => {
          'fqn' => 'Foo',
          'Bar'   => {
            'fqn' => 'Foo.Bar'
          }
        }
      }

      assert_equal expected, namespaces['Views']
    end
  end

  test 'views' do
    Dir.mktmpdir do |dir|

      Rails.stubs(:root).returns(dir)

      sub_dir = File.join(Rails.root, 'app', 'assets', 'javascripts', 'views')

      FileUtils.mkdir_p(File.join(sub_dir, 'bip', 'bap', 'zip'))
      FileUtils.touch(File.join(sub_dir, 'bip', 'bap', 'zip', 'show_view.js.coffee'))
      FileUtils.touch(File.join(sub_dir, 'bip', 'bap', 'list_view.js.coffee'))

      expected = [
        { class: 'ListView', namespace: 'Bip.Bap' },
        { class: 'ShowView', namespace: 'Bip.Bap.Zip' }
      ]

      assert_equal expected, views
    end
  end

end
