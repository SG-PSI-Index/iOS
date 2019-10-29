#!/bin/sh

#  generate_mocks.sh
#  PSIMap
#
#  Created by Kevin Lo on 29/10/2019.
#  Copyright © 2019 Zuhlke Engineering HK Limited. All rights reserved.

# Define output file. Change "${PROJECT_DIR}/${PROJECT_NAME}Tests" to your test's root source folder, if it's not the default name.
OUTPUT_FILE="${PROJECT_DIR}/${PROJECT_NAME}Tests/GeneratedMocks.swift"
echo "Generated Mocks File = ${OUTPUT_FILE}"

# Define input directory. Change "${PROJECT_DIR}/${PROJECT_NAME}" to your project's root source folder, if it's not the default name.
INPUT_DIR="${PROJECT_DIR}/${PROJECT_NAME}"
echo "Mocks Input Directory = ${INPUT_DIR}"

# Generate mock files
find "${INPUT_DIR}" -name "*Protocols.swift" | sed "s/$/ /" | xargs \
"${PODS_ROOT}/Cuckoo/run" generate --testable "${PROJECT_NAME}" --output "${OUTPUT_FILE}"

# After running once, locate `GeneratedMocks.swift` and drag it into your Xcode test target group.
