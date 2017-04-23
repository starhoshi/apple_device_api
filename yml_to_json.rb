require 'yaml'
require 'json'
require 'pathname'

def write(filepath, data)
  output_file = File.open(filepath, 'w+')
  output_file.write(data)
  output_file.close
end

devices = Hash.new { |h, k| h[k] = [] }
Dir.glob('data/**/{[!template]}*.yml').each do |yml_filepath|
  p "input yml filepath:     #{yml_filepath}"

  output_filename = yml_filepath
                        .sub(/(yml|yaml)$/, 'json')
                        .sub(/data/, 'api/v1/devices')
  p "output json filepath:   #{output_filename}"

  output_dir = output_filename.sub(File.basename(output_filename), '')

  FileUtils.mkdir_p(output_dir) unless FileTest.exist?(output_dir)

  yml = File.read(yml_filepath)
  json = JSON.pretty_generate(YAML::load(yml))

  write(output_filename, json)

  hash = YAML.load(File.read(yml_filepath))
  hash['path'] = output_filename
  devices[Pathname.new(output_dir).split.last.to_s].push(hash)
end

devices.each do |key, value|
  devices[key] = value.sort_by{|val| val['release_date']}.reverse
end

write('api/v1/devices.json', JSON.pretty_generate(devices))
