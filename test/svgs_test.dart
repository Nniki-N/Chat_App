import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/resources/resources.dart';

void main() {
  test('svgs assets test', () {
    expect(File(Svgs.arrowLeft).existsSync(), true);
    expect(File(Svgs.arrowRight).existsSync(), true);
    expect(File(Svgs.cameraSwitch).existsSync(), true);
    expect(File(Svgs.camera).existsSync(), true);
    expect(File(Svgs.checkMark).existsSync(), true);
    expect(File(Svgs.cross).existsSync(), true);
    expect(File(Svgs.defaultUserImage).existsSync(), true);
    expect(File(Svgs.edit).existsSync(), true);
    expect(File(Svgs.image).existsSync(), true);
    expect(File(Svgs.logoBackground).existsSync(), true);
    expect(File(Svgs.logoForeground).existsSync(), true);
    expect(File(Svgs.logo).existsSync(), true);
    expect(File(Svgs.magnifier).existsSync(), true);
    expect(File(Svgs.microphone).existsSync(), true);
    expect(File(Svgs.noInternetConnection).existsSync(), true);
    expect(File(Svgs.people).existsSync(), true);
    expect(File(Svgs.person).existsSync(), true);
    expect(File(Svgs.phone).existsSync(), true);
    expect(File(Svgs.play).existsSync(), true);
    expect(File(Svgs.send).existsSync(), true);
    expect(File(Svgs.settings).existsSync(), true);
    expect(File(Svgs.stop).existsSync(), true);
    expect(File(Svgs.videoPhone).existsSync(), true);
  });
}
