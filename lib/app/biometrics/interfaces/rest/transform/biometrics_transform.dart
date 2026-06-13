import '../../../domain/model/queries/identify_person.query.dart';
import '../../../domain/model/valueobjects/face_image_path.dart';
import '../resources/identify_person_form.resource.dart';

IdentifyPersonQuery toIdentifyPersonQuery(IdentifyPersonFormResource resource) {
  return IdentifyPersonQuery(imagePath: FaceImagePath(resource.imagePath));
}
