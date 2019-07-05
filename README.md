# Building and installing release .apk on multiple devices using the shell script
Creating an app directly from its source code and installing it on a device can often seem like a daunting task. Take a look at how we clone, build and install our Android applications with a few easy steps in the shell script!

Prerequisite:
1. Latest Android SDK
2. Latest Java SDK

Simply you just need installed android studio and OpenJDK on your system and you are good to go.
Following are the simple steps
1. Cloning or pulling our latest repository 
2. Building debug or release apk using gradlew
2. And installing it on single or multiple devices using adb

Now by using a shell script, we are doing it step by step
# Step 1: Clone your repository and if the repository is already existed then pull it.
FOLDER_PATH="/home/buzzybrains/Build"
APP_NAME = "test-app"
if [ -d "$FOLDER_PATH/${APP_NAME}" ]
   then
       echo "— Pulling $APP_NAME git repo — "
       cd ${FOLDER_PATH}/${APP_NAME}
       git pull
       wait
   else 
       echo "— Creating build folder — "
       mkdir Build
       cd Build
       git clone 
https://nikhilbhople@bitbucket.org/mygitrepo/${APP_NAME}.git       wait
       cd ${APP_NAME}
fi

The above code is straightforward if a folder exists then pull the repo else create a folder and clone the repo. Now “wait” is used to wait for previous instruction to complete.

# Step 2: Creating and adding “local.propertices” file to your project folder. Which include your android sdk location, it is used by gradlew for building apk
ANDROID_SDK_LOCATION="/home/nikhilbhople/Android/Sdk"
echo "--creating local.properties--"
echo "sdk.dir=$ANDROID_SDK_LOCATION" > local.properties

# Step 3: Now for building apk, Gradle provides two commands-
./gradlew assembleDebug => for building debug apk
./gradlew assembleRelease => for building release apk
For building release apk, we need “keystore.jks” file and have to set its configuration in build.gradle(app level).
Follow the below steps
3.1: You can create keystore.jks file by using Android studio
3.2: Store a file in your app folder of the project
3.3: Now create keystore.properties file in the root folder of your project and paste the following details

storePassword=yourKeystorePassword
keyPassword=yourKeyAliasPassword
keyAlias=yourKeyAlias
storeFile=keystore.jks

where
storePassword => represent your keystore password
keypassword => represent your key alias 
passwordkeyAlias => represent your key alias name
storeFile => represent your keystore file name

3.4: Now make the following changes in your build.gradle(app level)
apply plugin: 'com.android.application'
def keystorePropertiesFile = rootProject.file("keystore.properties")
def keystoreProperties = new Properties()
keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
android {
// Encapsulates signing configurations.
signingConfigs {
 config {
    keyAlias keystoreProperties['keyAlias']
    keyPassword keystoreProperties['keyPassword']
    storeFile file(keystoreProperties['storeFile'])
    storePassword keystoreProperties['storePassword']
  }
 buildTypes {
  release {
     minifyEnabled false
     proguardFiles getDefaultProguardFile('proguard-android.txt'),     'proguard-rules.pro'
     signingConfig signingConfigs.config
   }
  }
 }
}

You can get more details here
https://developer.android.com/studio/publish/app-signing

# Step 4: Now we can build the project using ./gradlew command
chmod +x gradlew
./gradlew assembleRelease
wait
above step, you may get an error like JavaSdk/Android SDK path not found, then you suppose to give correct path. Other errors are related to your
compilation.

# Step 5: Now your release apk is ready and it’s location “app/build/outputs/apk/release”. So move
cd app/build/outputs/apk/release

# Step 6: Now we are installing apk using adb install command
adb install will install to only one device if you connect two or more devices then it will throw an error.
So for installing two or more devices, the following command is useful
adb devices which gives us list of device

echo "--installing apk--"
# adb install app-release.apk  # for installing in single device
 for SERIAL in $(adb devices 
 grep -v List 
 cut -f 1);
    do adb -s $SERIAL install -r app-release.apk
done
echo "--installation complete--"

where, -s => represent the serial no 
-r => represent apk is existed then replace it
