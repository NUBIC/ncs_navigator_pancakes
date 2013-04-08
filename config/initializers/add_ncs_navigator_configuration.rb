require 'pancakes/ncs_navigator_configuration'

Pancakes::Application.send(:include, Pancakes::NcsNavigatorConfiguration)
Pancakes::Application.configure_from_ncs_navigator
