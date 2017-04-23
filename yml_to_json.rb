require 'yaml'
require 'json'
require 'rake'


Dir.glob('data/**/{[!template]}*.yml').each do | yml_filename |
  p yml_filename
  output_filename = yml_filename.sub(/(yml|yaml)$/, 'json')

  yml = File.open(yml_filename, 'r').read
  json = JSON.dump(YAML::load(yml))

  output_file = File.open(output_filename, 'w+')
  output_file.write(json)
  output_file.close
end
