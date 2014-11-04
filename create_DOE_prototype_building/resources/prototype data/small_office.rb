
# open the class to add methods to size all HVAC equipment
class OpenStudio::Model::Model
 
  def define_space_type_map

    space_type_map = {
      'WholeBuilding - Sm Office' => ['Perimeter_ZN_1', 'Perimeter_ZN_2', 'Perimeter_ZN_3', 'Perimeter_ZN_4', 'Core_ZN'] #TODO what to do about the attic?
    }

    return space_type_map

  end

  def define_hvac_system_map

    system_to_space_map = [
      {
          'type' => 'PSZ-AC',
          'space_names' =>
          [
              'Perimeter_ZN_1'
          ]
      },
      {
          'type' => 'PSZ-AC',
          'space_names' =>
          [
              'Perimeter_ZN_2'
          ]
      },
      {
          'type' => 'PSZ-AC',
          'space_names' =>
          [
              'Perimeter_ZN_3'
          ]
      },
      {
          'type' => 'PSZ-AC',
          'space_names' =>
          [
              'Perimeter_ZN_4'
          ]
      },
      {
          'type' => 'PSZ-AC',
          'space_names' =>
          [
              'Core_ZN'
          ]
      }
  ]

    return system_to_space_map

  end
     
  def add_hvac(building_type, building_vintage, climate_zone, prototype_input, hvac_standards)
   
    puts("Started Adding HVAC")
    
    system_to_space_map = define_hvac_system_map()
    
    system_to_space_map.each do |system|

      #find all zones associated with these spaces
      thermal_zones = []
      system['space_names'].each do |space_name|
        space = self.getSpaceByName(space_name)
        if space.empty?
          puts("No space called #{space_name} was found in the model")
          return false
        end
        space = space.get
        zone = space.thermalZone
        if zone.empty?
          puts("No thermal zone created for space called #{space_name} was found in the model")
          return false
        end
        thermal_zones << zone.get
      end

      case system['type']
      when "PSZ-AC"
        self.add_psz_ac(prototype_input, hvac_standards, thermal_zones)
      end

    end

    puts("Finished adding HVAC")
    
    return true
    
  end #add hvac

end