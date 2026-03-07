import 'package:flutter/material.dart';
import 'package:manti/features/manti/domain/entities/manti_item.dart';

/// Full curated list of selectable icons in display order.
const mantiIconOptions = <({String name, IconData icon})>[
  // Vehículos
  (name: 'car', icon: Icons.directions_car_rounded),
  (name: 'motorcycle', icon: Icons.two_wheeler_rounded),
  (name: 'truck', icon: Icons.local_shipping_rounded),
  (name: 'bike', icon: Icons.directions_bike_rounded),
  (name: 'flight', icon: Icons.flight_rounded),
  (name: 'boat', icon: Icons.sailing_rounded),
  (name: 'ev', icon: Icons.electric_car_rounded),
  (name: 'suv', icon: Icons.airport_shuttle_rounded),
  (name: 'scooter', icon: Icons.electric_scooter_rounded),
  (name: 'atv', icon: Icons.agriculture_rounded),
  (name: 'train', icon: Icons.train_rounded),
  (name: 'rv', icon: Icons.rv_hookup_rounded),
  // Tech
  (name: 'tech', icon: Icons.devices_other_rounded),
  (name: 'phone', icon: Icons.smartphone_rounded),
  (name: 'computer', icon: Icons.computer_rounded),
  (name: 'laptop', icon: Icons.laptop_rounded),
  (name: 'tablet', icon: Icons.tablet_rounded),
  (name: 'camera', icon: Icons.camera_alt_rounded),
  (name: 'headphones', icon: Icons.headphones_rounded),
  (name: 'tv', icon: Icons.tv_rounded),
  (name: 'router', icon: Icons.router_rounded),
  (name: 'watch', icon: Icons.watch_rounded),
  (name: 'printer', icon: Icons.print_rounded),
  (name: 'speaker', icon: Icons.speaker_rounded),
  (name: 'gamepad', icon: Icons.sports_esports_rounded),
  (name: 'drone', icon: Icons.paragliding_rounded),
  // Hogar
  (name: 'home', icon: Icons.home_rounded),
  (name: 'kitchen', icon: Icons.kitchen_rounded),
  (name: 'garden', icon: Icons.yard_rounded),
  (name: 'ac', icon: Icons.ac_unit_rounded),
  (name: 'electrical', icon: Icons.electrical_services_rounded),
  (name: 'plumbing', icon: Icons.plumbing_rounded),
  (name: 'sofa', icon: Icons.weekend_rounded),
  (name: 'bed', icon: Icons.bed_rounded),
  (name: 'washer', icon: Icons.local_laundry_service_rounded),
  (name: 'blender', icon: Icons.blender_rounded),
  (name: 'microwave', icon: Icons.microwave_rounded),
  (name: 'coffee_maker', icon: Icons.coffee_maker_rounded),
  (name: 'door', icon: Icons.door_front_door_rounded),
  (name: 'window', icon: Icons.window_rounded),
  (name: 'pool', icon: Icons.pool_rounded),
  (name: 'fireplace', icon: Icons.fireplace_rounded),
  (name: 'garage', icon: Icons.garage_rounded),
  // Herramientas
  (name: 'tool', icon: Icons.build_rounded),
  (name: 'handyman', icon: Icons.handyman_rounded),
  (name: 'carpenter', icon: Icons.carpenter_rounded),
  (name: 'hardware', icon: Icons.hardware_rounded),
  (name: 'construction', icon: Icons.construction_rounded),
  (name: 'brush', icon: Icons.brush_rounded),
  (name: 'format_paint', icon: Icons.format_paint_rounded),
  (name: 'bolt', icon: Icons.bolt_rounded),
  // Salud y bienestar
  (name: 'medical', icon: Icons.local_hospital_rounded),
  (name: 'fitness', icon: Icons.fitness_center_rounded),
  (name: 'spa', icon: Icons.spa_rounded),
  (name: 'monitor_heart', icon: Icons.monitor_heart_rounded),
  (name: 'medication', icon: Icons.medication_rounded),
  (name: 'self_improvement', icon: Icons.self_improvement_rounded),
  // Naturaleza y animales
  (name: 'pet', icon: Icons.pets_rounded),
  (name: 'park', icon: Icons.park_rounded),
  (name: 'grass', icon: Icons.grass_rounded),
  (name: 'water', icon: Icons.water_drop_rounded),
  (name: 'eco', icon: Icons.eco_rounded),
  // Ocio y deporte
  (name: 'sports', icon: Icons.sports_rounded),
  (name: 'bicycle', icon: Icons.pedal_bike_rounded),
  (name: 'hiking', icon: Icons.hiking_rounded),
  (name: 'surfing', icon: Icons.surfing_rounded),
  (name: 'kayak', icon: Icons.kayaking_rounded),
  (name: 'music', icon: Icons.music_note_rounded),
  (name: 'photo', icon: Icons.photo_camera_rounded),
  // Trabajo y estudio
  (name: 'school', icon: Icons.school_rounded),
  (name: 'work', icon: Icons.work_rounded),
  (name: 'science', icon: Icons.science_rounded),
  (name: 'store', icon: Icons.store_rounded),
  (name: 'inventory', icon: Icons.inventory_2_rounded),
  // Otros
  (name: 'star', icon: Icons.star_rounded),
  (name: 'favorite', icon: Icons.favorite_rounded),
  (name: 'lock', icon: Icons.lock_rounded),
  (name: 'key', icon: Icons.key_rounded),
  (name: 'other', icon: Icons.category_rounded),
];

/// Resolves a stored icon name string → IconData.
IconData iconForName(String? name) {
  return mantiIconOptions
      .firstWhere(
        (e) => e.name == name,
        orElse: () => (name: '', icon: Icons.category_rounded),
      )
      .icon;
}

/// Returns the default icon name for a category (used on first creation).
String defaultIconName(MantiCategory category) {
  switch (category) {
    case MantiCategory.tech:
      return 'tech';
    case MantiCategory.vehicle:
      return 'car';
    case MantiCategory.tool:
      return 'tool';
    case MantiCategory.home:
      return 'home';
    case MantiCategory.other:
      return 'other';
  }
}

// Kept for backwards compatibility with widgets that use category-based icon.
IconData categoryIcon(MantiCategory category) =>
    iconForName(defaultIconName(category));
