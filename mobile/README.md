# Flutter Project

Flutter part of the project. Check out the [Figma prototype & Personas](https://www.figma.com/file/NbkYvV62yff4ysNIDYyIYa/Flutter-Project-App-Prototype?node-id=0%3A1&t=n2tABiv5SbXgIRJn-1).

UI can be improved. Material Design 3 is not available yet in Flutter. At the end of the day this is just an university exam :)

## Dependencies

To check if you have the latest version of a Flutter package, visit `https://pub.dev/packages/<package_name>` and write it in the `pubspec.yaml` file.

- [Google Fonts](https://pub.dev/packages/google_fonts), used to add Google Fonts in our app.
- [Provider](https://pub.dev/packages/provider), we are using the *ChangeNotifier-based providers*: these are widgets that hold data and make it available to their descendants through a `ChangeNotifier`. The `ChangeNotifier` is a class that implements the `Listenable` interface and allows its listeners to be notified when the data it holds has changed. This is useful for cases where the data needs to be updated in real-time and other parts of the app need to be notified of these updates. Used for the `ThemeData` of the `MaterialApp`, but also to change the views based on the user's privileges at startup and during the app usage.
- [Introduction Screen](https://pub.dev/packages/introduction_screen), used to implement the **Onboarding page**.
- [Flutter SVG](https://pub.dev/packages/flutter_svg), used to add an SVG renderer in Flutter for the application icons.
- [Sqflite](https://pub.dev/packages/sqflite), used to interact with a local SQLite Database.
- [Bcrypt](https://pub.dev/packages/bcrypt), used to store hashed passwords in the database. We are using `bcrypt` with the **Cost Factor** to `10`.
- [Flutter Webview](https://pub.dev/packages/webview_flutter), used to show the **Registration page** website in the app.
- [Path Provider](https://pub.dev/packages/path_provider), used to access the most common directories of the local storage.
- [Animations](https://pub.dev/packages/animations), used to add the Shared X Axis animation when switching pages in the main screen.
- [Simple Shadow](https://pub.dev/packages/simple_shadow), used to add the drop shadow to images with a transparent background. It could be used to add shadows to every Widget.
- [Bezier Chart](https://pub.dev/packages/bezier_chart), used to add the Bezier Chart in the home page, it has a graphical bug when switching page and it's 2 years-old.

### Authors

- [Bogetti Filippo](https://bogeee.github.io/)
- [Stefano Fontana](#Authors)

### License

See [LICENSE](./LICENSE.md).

### Acknowledgements

- Working with Android Studio and VS Code
- Working with Windows and GNU/Linux
- Testing with Chromium Debug Tools and Android devices