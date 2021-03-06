#
# Copyright (C) 2015-2017 Rodrigo Siqueira  <siqueira@kuniri.org>
#
# This source code is licensed under the GNU lesser general public license,
# Version 3.  See the file COPYING for more details

require_relative '../error/language_error'
require_relative 'xml_output_format'

module Parser

  # Simple factory to create output objects.
  class OutputFactory

    public

      # Handling the output tyoe.
      # @param pType [String] Type of object
      # @return Return an object of output.
      def get_output(pType)
        pType.downcase!

        if pType == "xml"
          return XMLOutputFormat.new
        end
        if pType == "yml"
          raise Error::ParserError
        end
      end

  # Class
  end

# Module
end
