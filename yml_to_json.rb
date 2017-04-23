require 'yaml'
require 'json'
require 'rake'
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

  unless output_filename =~ /simulator/
    hash = YAML.load(File.read(yml_filepath))
    hash['path'] = output_filename
    devices[Pathname.new(output_dir).split.last.to_s].push(hash)
  end
end

# sorted by release_date
devices.each do |key, value|
  devices[key] = value.sort_by{|val| val['release_date']}.reverse
end

# use path, name, release_date, image
devices.each do |key, value|
  device = []
  value.each do |item|
    device.push({'path': item['path'], 'name': item['name'], 'release_date': item['release_date'], 'image': item['image']})
  end
  devices[key] = device
end

write('api/v1/devices.json', JSON.pretty_generate(devices))
