import 'dart:async';
import 'dart:convert';
import 'package:analyzer/dart/element/element.dart';
import 'package:rest_api_server/src/builder/routes_generator.dart';
import 'package:source_gen/src/constants/reader.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:build/build.dart' hide Resource;
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';
import 'package:source_gen/source_gen.dart' hide LibraryBuilder;

class ResourceInfoGenerator_ extends ResourceInfoGenerator {
  @override
  Future<String> generateForAnnotatedElement(Element element,
      ConstantReader resourceMetaReader, BuildStep buildStep) async {
    final routes = await super
        .generateForAnnotatedElement(element, resourceMetaReader, buildStep);
    return routes
        .replaceAll('GET*', 'GET')
        .replaceAll('PUT*', 'PUT')
        .replaceAll('POST*', 'POST')
        .replaceAll('PATCH*', 'PATCH')
        .replaceAll('DELETE*', 'DELETE');
  }
}

class RoutesBuilder_ extends Builder {
  static final _resourceFiles = Glob('lib/**.resource_p.info');

  static AssetId _routerOutput(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      url.join('lib', 'routes.gp.dart'),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return const {
      r'$lib$': ['routes.gp.dart'],
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final output = _routerOutput(buildStep);
    final libraryBuilder = LibraryBuilder();
    libraryBuilder.directives.addAll([
      Directive.import('dart:convert'),
      Directive.import('package:shelf/shelf.dart'),
      Directive.import('package:rest_api_server/src/route.dart')
    ]);
    final routes = <Code>[];

    await for (final input in buildStep.findAssets(_resourceFiles)) {
      final jsonString = (await buildStep.readAsString(input))
          .splitMapJoin(RegExp('(?://.*)?\n'), onMatch: (_) => '');
      final resourceInfo = json.decode(jsonString);
      libraryBuilder.directives.add(
          Directive.import(resourceInfo['uri'], as: resourceInfo['prefix']));
      libraryBuilder.body.add(Code('${resourceInfo['controller']}'));
      routes
          .addAll((resourceInfo['routes'] as List).map((route) => Code(route)));
    }
    libraryBuilder.body.add(
        literalList(routes, refer('Route')).assignFinal('routes').statement);
    final content = libraryBuilder.build().accept(DartEmitter());
    buildStep.writeAsString(output, DartFormatter().format('$content'));
    return;
  }
}
