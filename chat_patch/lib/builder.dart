import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/code_generators.dart';

Builder resourceInfoBuilder(BuilderOptions options) =>
    LibraryBuilder(ResourceInfoGenerator_(),
        formatOutput: (String content) => content,
        generatedExtension: '.resource_p.info',
        header: '');

Builder routesBuilder(BuilderOptions options) => RoutesBuilder_();
