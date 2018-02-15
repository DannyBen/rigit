require 'rigit'

# require 'configatron/core'
# config = Configatron::RootStore.new
# config.configure_from_hash YAML.load_file('source/config.yml')
# prompt = Prompt.new config.params, intro: config.intro
# result = prompt.get_input
# p result




config = Rigit::Config.load('example/source/config.yml')

p config