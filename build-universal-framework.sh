#!/bin/sh -x

# NB: Xcode 10 - ${CONFIGURATION} seems to be missing, so I've added ${CONFIGURATION:-Release}

IOS_FRAMEWORK_PATH="$1"
SIM_FRAMEWORK_PATH="$2"

FRAMEWORK=$(basename $IOS_FRAMEWORK_PATH)
FRAMEWORK_NAME=${FRAMEWORK%.*}

UNIVERSAL_OUTPUT_FOLDER="${3:-./output}"

# make the output directory and delete the framework directory
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}/${FRAMEWORK_NAME}.framework"

# Step 2. Copy the framework structure to the universal folder
cp -R "${IOS_FRAMEWORK_PATH}" "${UNIVERSAL_OUTPUT_FOLDER}/"

# Step 3. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUT_FOLDER}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" "${SIM_FRAMEWORK_PATH}/${FRAMEWORK_NAME}" "${IOS_FRAMEWORK_PATH}/${FRAMEWORK_NAME}"

# Step 3b. Copy the simultor swiftdoc and swiftmodules in to the framework structure
cp "${SIM_FRAMEWORK_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/i386."*   "${UNIVERSAL_OUTPUT_FOLDER}/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/" 2>/dev/null || :
cp "${SIM_FRAMEWORK_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/x86_64."* "${UNIVERSAL_OUTPUT_FOLDER}/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/" 2>/dev/null || :

# Step 4. Copy strings bundle if exists
#STRINGS_INPUT_FOLDER="${PROJECT_NAME}Strings.bundle"
#if [ -d "${STRINGS_INPUT_FOLDER}" ]; then
#STRINGS_OUTPUT_FOLDER="${UNIVERSAL_OUTPUT_FOLDER}/${PROJECT_NAME}Strings.bundle"
#rm -rf "${STRINGS_OUTPUT_FOLDER}"
#cp -R "${STRINGS_INPUT_FOLDER}" "${STRINGS_OUTPUT_FOLDER}"
#fi
