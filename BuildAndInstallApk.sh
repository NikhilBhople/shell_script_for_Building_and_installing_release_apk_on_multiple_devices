FOLDER_PATH="/home/nikhilbhople/build"
ANDROID_SDK_LOCATION="/home/nikhilbhople/Android/Sdk"
PACKAGE_NAME="nikhil.bhople.apps"
APP_NAME = “test-app”

# STEP 1: Pull or clone app repo
if [ -d "$FOLDER_PATH/${APP_NAME}" ]
then
echo "--Pulling $APP_NAME git repo--"
cd ${FOLDER_PATH}/${APP_NAME}
git pull
wait
else
echo "--Creating build folder--"
mkdir build
cd build
git clone
https://nikhilbhople@bitbucket.org/mygitrepo/${APP_NAME}.git   wait
cd ${APP_NAME}
fi


# STEP 2: Creating local.properties
echo "--creating local.properties--"
echo "sdk.dir=$ANDROID_SDK_LOCATION" > local.properties


#STEP 3 and 4: Permission for gradlew and building release apk
cd ${FOLDER_PATH}/${APP_NAME}
chmod +x gradlew
./gradlew assembleRelease
wait


#STEP 5: Move to build location
echo "--apk location $APP_NAME/app/build/outputs/apk/release --"
cd app/build/outputs/apk/release


# STEP 6: Installing APK to multiple devices
echo "--installing apk--"


# adb install app-release.apk  # for installing in single device
for SERIAL in $(adb devices
grep -v List
cut -f 1);
do adb -s $SERIAL install -r app-release.apk
done
echo "--installation complete--"
