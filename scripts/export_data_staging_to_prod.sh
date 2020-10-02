#!/bin/bash

HASH_KEY=
SALT_SEPARATOR=

# Export Firebase Authentication data
firebase use staging
firebase auth:export firebase_auth_accounts.json

# Import Firebase Authentication data
firebase use production
firebase auth:import firebase_auth_accounts.json    \
    --hash-algo=SCRYPT         \
    --hash-key="$HASH_KEY"                     \
    --salt-separator="$SALT_SEPARATOR"    \
    --rounds=8                    \
    --mem-cost=14

# Export Firestore data
# Collections: discover, groups, matches, notifications, recommendations, requests, users
gcloud config set project get-canteen-staging
gcloud firestore export gs://canteen-data-dump-staging --collection-ids=discover,groups,members,security,posts,likes,comments,matches,messages,notifications,child_notifications,recommendations,requests,users,settings,tokens --async

gsutil -m rsync -r gs://canteen-data-dump-staging gs://canteen-data-dump-prod

gcloud config set project get-canteen-prod
# REPLACE directory (labeled with timestamp) with specific firestore export directory
FIRESTORE_EXPORT_DIRECTORY=''
gcloud firestore import gs://canteen-data-dump-prod/${FIRESTORE_EXPORT_DIRECTORY}

# Copy group images and user images
gsutil -m rsync -r gs://get-canteen-staging.appspot.com gs://get-canteen-prod.appspot.com

# Run copy_images_firebase_storage.ipynb