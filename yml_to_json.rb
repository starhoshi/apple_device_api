require 'yaml'
require 'json'

Dir.glob('data/**/{[!template]}*.yml').each do | yml_filepath |
  p "input yml flepath:   #{yml_filepath}"

  output_filename = yml_filepath
                        .sub(/(yml|yaml)$/, 'json')
                        .sub(/data/, 'api/v1/devices')
  p "output json flepath: #{output_filename}"

   output_dir = output_filename.sub(File.basename(output_filename), '')

  FileUtils.mkdir_p(output_dir) unless FileTest.exist?(output_dir)

  yml = File.open(yml_filepath, 'r').read
  json = JSON.dump(YAML::load(yml))

  output_file = File.open(output_filename, 'w+')
  output_file.write(json)
  output_file.close
end
