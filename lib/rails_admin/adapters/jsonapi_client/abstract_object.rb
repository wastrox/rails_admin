module RailsAdmin
  module Adapters
    module JsonapiClient
      class AbstractObject
        # undef almost all of this class's methods so it will pass almost
        # everything through to its delegate using method_missing (below).
        instance_methods.each { |m| undef_method m unless m.to_s =~ /(^__|^send$|^object_id$)/ }
        #                                                  ^^^^^
        # the unnecessary "to_s" above is a workaround for meta_where, see
        # https://github.com/sferik/rails_admin/issues/374

        attr_accessor :object

        def initialize(object)
          self.object = object
        end

        def set_attributes(attributes)
          return unless attributes

          object.changes = {}
          attributes.each_pair do |attr, value|
            next if object[attr] == value
            object.changes[attr] = [object[attr], attr]
            object[attr] = value
          end
        end

        def save(_options = {validate: true})
          object.save
        end

        def method_missing(name, *args, &block)
          object.send(name, *args, &block)
        end
      end
    end
  end
end
