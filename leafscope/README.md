**LeafScope** is a Flutter app that identifies plants from a photo using the Pl@ntNet API.

What it does
•	Take a photo with the camera or pick one from the gallery.
•	Send the image to Pl@ntNet and get the top species name + confidence %.
•	Show the result with the photo, scientific name and confidence.
•	Save each scan (name, score, image path, time) in a local history using Hive.
•	Let the user reopen past scans from the History screen.
•	Show an About screen that briefly explains the app and credits Pl@ntNet.

How it’s built
•	Flutter UI with:
•	HomeScreen – buttons for Camera, Gallery, History, and About.
•	ResultScreen – calls the API, shows result or friendly error, writes to Hive.
•	HistoryScreen – reads all items from the history Hive box and lists them.
•	Image input: image_picker plugin, returns a local File.
•	API code in plantnet_api.dart:
•	MultipartRequest POST to
https://my-api.plantnet.org/v2/identify/all?api-key=YOUR_KEY.
•	Uploads the file under the images field and parses the first result.
•	Storage: hive / hive_flutter, box name history, each entry is a simple map.

How to run

*flutter pub get*
*flutter run*

# APK: build/app/outputs/flutter-apk/app-release.apk

The flow I followed for my MVP: -
Step 1 – Identify
I picked the plant identifier niche as suggested: simple utility, clear value, and many existing apps already making money. I used public store listings and keyword tools to confirm there’s demand around “plant identifier / plant identification app / plant scanner” and similar terms.
Step 2 – Check
The niche is clearly cloneable: most top apps have one main job (identify a plant from a photo), similar UIs, and subscription style monetization, so it fit the “simple, focused utility” criteria.
Step 3 – Verify (ASO)
I did a quick ASO pass and drafted store text for my clone “LeafScope: Plant Identifier” using those high intent keywords (“plant identifier”, “identify plants”, “plant scanner”, “free plant identification app”, etc.) so it can be plugged directly into a Play Store / App Store listing later.
Step 4 – Build the clone
I built a working MVP clone of a plant identifier:
•	Flutter app running on Android emulator (Android Studio), not web/desktop.
•	Camera + gallery input.
•	Sends the photo to the Pl@ntNet API, parses the JSON, and shows plant name + confidence.
•	Local history of scans stored with Hive, plus an About screen and friendly error handling.
Right now it’s a clean, focused MVP that copies the core value and main flow of existing plant ID apps and is ready to be iterated on or ported to iOS/SwiftUI for better monetization.