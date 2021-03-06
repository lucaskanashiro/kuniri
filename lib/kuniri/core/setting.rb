#
# Copyright (C) 2015-2017 Rodrigo Siqueira  <siqueira@kuniri.org>
#
# This source code is licensed under the GNU lesser general public license,
# Version 3.  See the file COPYING for more details

require 'yaml'
require_relative 'configuration/language_available'
require_relative '../error/configuration_file_error'
require_relative '../util/logger_kuniri'

module Kuniri

  # Class Setting that read and handling .kuniri file.
  class Setting

    private_class_method :new
    attr_reader :configurationInfo

    def initialize
      initializate_settings
    end

    def self.create
      @@settings = new unless @@settings
      return @@settings
    end

    # TODO: Remove parameter and initialize_object. Useless.
    def initializate_settings
      @configurationInfo = {}
    end

    # In this method it is checked the configuration file syntax.
    # @param pPath [String] Path to ".kuniri" file, it means, the
    #         configurations.
    # @return [Hash] Return a Hash with the configurations read in ".kuniri",
    #     otherwise, raise an exception.
    def read_configuration_file(pPath = '.kuniri.yml')

      if !(File.exist?(pPath))
        set_default_configuration
      else
        @configurationInfo = YAML.load(File.read(pPath))
        verify_syntax
      end

      return @configurationInfo
    end

    def set_configuration(configurationInfo)
      @configurationInfo = configurationInfo
    end

    private

      @@settings = nil

      def set_default_configuration
        @configurationInfo = {:language => "ruby",
                               :source => "./",
                               :output => "./"}
      end

      def verify_syntax
        unless @configurationInfo.is_a? Hash
          Util::LoggerKuniri.error('Configuration file has a syntax problem')
          raise Error::ConfigurationFileError
        end

        check_source
        check_output
        check_language
      end

      def check_source
        unless @configurationInfo.has_key?:source
          Util::LoggerKuniri.error('Problem with source parameter')
          raise Error::ConfigurationFileError
        else
          source = @configurationInfo[:source]
          result = (File.directory?source) || (File.exists?source)
          unless result
            Util::LoggerKuniri.error('Wrong path on source')
            raise Error::ConfigurationFileError
          end
        end
      end

      def check_output
        unless @configurationInfo.has_key?:output
          Util::LoggerKuniri.error('Problem with output field')
          raise Error::ConfigurationFileError
        end
      end

      def check_language
        unless @configurationInfo.has_key?:language
          Util::LoggerKuniri.error('Problem with language field')
          raise Error::ConfigurationFileError
        else
          result = Configuration::LanguageAvailable::LANGUAGES.include?(
                                                @configurationInfo[:language])
          unless result
            Util::LoggerKuniri.error('Problem with specified language')
            raise Error::ConfigurationFileError
          end
        end
      end

  # Class
  end

# Module
end
