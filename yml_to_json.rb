require 'yaml'
require 'json'

devices = []
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

  output_file = File.open(output_filename, 'w+')
  output_file.write(json)
  output_file.close

  devices.push(YAML.load(File.read(yml_filepath)))
end

p devices

hogeArray = devices.sort_by{|val| val['release_date']}.reverse

hogeArray.each do |hogeHash|
  p "release_date:#{hogeHash['release_date']}"
end


=begin

{
  "ipad": [
      {
        "image": "http...",
        "released_at": "2017-..",
        "name": "iPad",
        "path": "api/v1/devices/ipad/ipad_1.json"
      },
      { ... }
  ],
  "iphone": [
  ]
}

=end
