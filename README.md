# Flutter Project

IUM Project 2022/23 &copy; Filippo Bogetti & Stefano Fontana

## Dependencies

To check if you have the latest version of a Flutter package, visit `https://pub.dev/packages/<package_name>` and write it in the `pubspec.yaml` file.

- [Google Fonts](https://pub.dev/packages/google_fonts), used to add Google Fonts in our app.
- [Provider](https://pub.dev/packages/provider), we are using the *ChangeNotifier-based providers*: these are widgets that hold data and make it available to their descendants through a `ChangeNotifier`. The `ChangeNotifier` is a class that implements the `Listenable` interface and allows its listeners to be notified when the data it holds has changed. This is useful for cases where the data needs to be updated in real-time and other parts of the app need to be notified of these updates. Used for the `ThemeData` of the `MaterialApp`, but also to change the views based on the user's privileges at startup and during the app usage.

### Authors

- [Bogetti Filippo](https://bogeee.github.io/)
- [Stefano Fontana](#Authors)

### License

See [LICENSE](./LICENSE.md).

### Acknowledgements

- Working with Android Studio and VS Code
- Working with Windows and GNU/Linux
- Testing with Chromium Debug Tools and Android devices