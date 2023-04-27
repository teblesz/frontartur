import 'package:fluttartur/app/view/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageChangeButton extends StatelessWidget {
  const LanguageChangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Language>[
          Language("🇬🇧", "en"),
          Language("🇵🇱", "pl"),
        ]
            .map(
              (lang) => TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () =>
                    Provider.of<LocaleNotifier>(context, listen: false)
                        .setLocale(Locale(lang.languageCode)),
                child: Text(
                  lang.flag,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            )
            .toList());
  }
}

class Language {
  final String flag;
  final String languageCode;

  Language(this.flag, this.languageCode);
}
