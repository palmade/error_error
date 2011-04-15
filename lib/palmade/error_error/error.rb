module Palmade
  module ErrorError
    class Error < StandardError
      attr_reader :attachments
      attr_reader :error

      class ErrorReply < Array
        def initialize(error, *args)
          @error = error
          self.concat(args)
        end

        def success?
          @error ? false : self
        end
        alias :ok? :success?

        def fail?
          @error
        end
        alias :error? :fail?

        def value
          self[0]
        end

        def error_code
          self[0]
        end

        def exception
          self[1]
        end

        def message
          exception.message
        end

        def ok!
          if ok?
            self
          else
            raise!
          end
        end

        def raise!
          raise exception
        end
      end

      module ClassMethods
        def capture_errors(*error_klasses, &block)
          unless error_klasses.empty?
            begin
              r = yield
              if r.is_a?(ErrorReply)
                r
              else
                ErrorReply.new(false, *(r.is_a?(Array) ? r : [ r ]))
              end
            rescue *error_klasses => e
              ErrorReply.new(true, e.error_code, e)
            end
          else
            yield
          end
        end
      end

      module InstanceMethods
        def capture_errors(*error_klasses, &block)
          self.class.capture_errors(*error_klasses, &block)
        end
      end

      def self.include_methods(klass)
        unless klass.respond_to?(:capture_errors)
          klass.extend(ClassMethods)
        end

        unless klass.include?(InstanceMethods)
          klass.send(:include, InstanceMethods)
        end
      end

      def self.define_error(klass, error_klass_name, message_scope = nil)
        # let's include our methods in the klass
        include_methods(klass)

        klass.class_eval("class #{error_klass_name} < #{self.name}; end", __FILE__, __LINE__ + 1)
        error_klass = klass.const_get(error_klass_name)
        error_klass.set_message_scope(message_scope)
      end

      def self.message_scope; @message_scope ||= nil; end
      def self.set_message_scope(ms); @message_scope = ms; end

      def initialize(error, *attachments)
        super(nil)

        @error = error
        @attachments = attachments
      end

      def message
        m = translate
        unless m.nil?
          if attachments.empty?
            m
          else
            m % attachments
          end
        else
          error_code
        end
      end

      def error_code
        (error.to_s.split('.').last || :error).to_sym
      end

      def translate
        if defined?(::I18n)
          if self.class.message_scope.nil?
            m = I18n.translate(error, :scope => 'errors')
          else
            m = I18n.translate(error, :scope => "errors.#{self.class.message_scope}")
          end
        else
          error_code.to_s
        end
      end
    end
  end
end
