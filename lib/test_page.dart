import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/container_provider.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var _containerColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContainerProvider(),
      child: TestBody(),
    );
  }
}

class TestBody extends StatelessWidget {
  const TestBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<ContainerProvider>(
          builder: (context, provider, child) {
            return Container(
              width: 50,
              height: 50,
              color: provider.color,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final provider =
              Provider.of<ContainerProvider>(context, listen: false);
          provider.onTap();
        },
      ),
    );
  }
}
