require 'json'

module JsonParser
  def self.parse_from_file(source)
    json_string = File.read(source)
    parsed_json = JSON.parse(json_string)
    return parsed_json

  rescue JSON::ParserError => e
    return nil
  end
end
