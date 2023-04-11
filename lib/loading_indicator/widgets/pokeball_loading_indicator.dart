import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PokeballLoadingIndicator extends StatelessWidget {
  const PokeballLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 120,
          width: 120,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: LottieBuilder.asset('assets/pokeball-loading.json'),
          ),
        ),
      ),
    );
  }
}
