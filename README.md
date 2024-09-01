# mobile

Remember to run 

```dart run build_runner watch --delete-conflicting-outputs```

while coding to update models when you change data structures. 

When using xcode open ```ios/Podfile.lock``` and search for ```cloud_firestore``` and note the version of ```Firebase/Firestore```. Open ```ios/Podfile``` and edit this line inside of ```target 'Runner' do``` if the tag it's different from the version:

```pod 'FirebaseFirestore' ...```

remove ```ios/Podfile.lock``` and rebuild by running  ```pod install``` in the ```ios``` directory, then go back to the flutter project and run ```flutter clean flutter pub get```