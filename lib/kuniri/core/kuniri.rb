#
# Copyright (C) 2015-2017 Rodrigo Siqueira  <siqueira@kuniri.org>
#
# This source code is licensed under the GNU lesser general public license,
# Version 3.  See the file COPYING for more details

require_relative '../error/configuration_file_error'
require_relative '../parser/parser'
require_relative '../util/logger_kuniri.rb'
require_relative 'configuration/language_available'
require_relative 'setting'

# Kuniri module connect all the elements and use it in the proper sequence.
module Kuniri

  # Kuniri class have the reference for all files and settings. Basically this
  # class launch the application.
  class Kuniri

    attr_reader :configurationInfo # !@attribute Hash with configuration

    # @param pPath Receives the path of configuration file. If any element
    #         is given, it tries to find in the current folder.
    def initialize
      @configurationInfo = {}
      @filesPathProject = []
      @parserFiles = []
      @parser = nil
    end

    def read_configuration_file(pPath = '.kuniri.yml')
      @settings = Setting.create
      @settings.initializate_settings
      @settings.read_configuration_file(pPath)
      @configurationInfo = @settings.configurationInfo
    end

    def set_configuration(pSource, pLanguage, pOutput, pLevel)
      @settings = Setting.create
      @settings.initializate_settings
      @configurationInfo = {language: pLanguage,
                            source: pSource,
                            output: pOutput,
                            pLevel: pLevel}

      @settings.set_configuration(@configurationInfo)
    end

    # Start Kuniri tasks based on configuration file. After read
    # configuration file, find all files in source directory.
    def run_analysis
      @filesPathProject = get_project_file(@configurationInfo[:source])
      unless @filesPathProject
        message = "Problem on source path: #{@configurationInfo[:source]}"
        Util::LoggerKuniri.error(message)
        return -1
      end
      @parser = Parser::Parser.new(@filesPathProject,
                                   @configurationInfo[:language])
      Util::LoggerKuniri.info('Start parse...')
      @parser.start_parser
    end

    def get_parser
      @parser
    end

    private

    @filesProject      # !@attribute Array with object reference of all files
    @parser            # !@attribute Execute the parser based on settings.
    @parserFiles       # !@attribute Final output from parser.

    # !@param pPath Relative path of the project.
    # !@param pLanguage Language extension for make the parser.
    def get_project_file(pPath = './', pLanguage = '**.rb')
      # Verify if path is a valid directory or file
      return nil unless File.file?(pPath) or File.directory?(pPath)

      # Handle single file
      if (File.file?(pPath))
        @filesProject = [pPath]
      # Handle multiple files
      else
        @filesProject = Dir[File.join(pPath, '**', pLanguage)]
      end

      return @filesProject
    end

  # Class
  end

# Kuniri
end
