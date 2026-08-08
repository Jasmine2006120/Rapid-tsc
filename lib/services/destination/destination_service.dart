import '../../models/destination/destination_model.dart';

class DestinationService {
  static const List<DestinationModel> destinations = [
    DestinationModel(
      name: 'City Hospital',
      latitude: 30.3810,
      longitude: 76.7950,
    ),
    DestinationModel(
      name: 'Emergency Care Centre',
      latitude: 30.3752,
      longitude: 76.7821,
    ),
    DestinationModel(
      name: 'Government Hospital',
      latitude: 30.3785,
      longitude: 76.7920,
    ),
    DestinationModel(
      name: 'Fire Incident Site',
      latitude: 30.3700,
      longitude: 76.7880,
    ),
    DestinationModel(
      name: 'Police Response Location',
      latitude: 30.3860,
      longitude: 76.8000,
    ),
  ];

  static DestinationModel? findByName(String name) {
    for (final destination in destinations) {
      if (destination.name == name) {
        return destination;
      }
    }

    return null;
  }
}