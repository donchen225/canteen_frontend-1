
# Declare environent to setup
ENVIRONMENT="development"

echo "Setting up Firebase $ENVIRONMENT environment..."

# Switch to firebase project to set up
firebase use $ENVIRONMENT

# Set up Cloud Functions secrets
## Load algolia config
gsutil cp gs://canteen-secrets-${ENVIRONMENT}/algolia-keys.json .

ALGOLIA_APP_ID=$(cat algolia-keys.json | jq -r ".ALGOLIA_APP_ID")
ALGOLIA_ADMIN_API_KEY=$(cat algolia-keys.json | jq -r ".ALGOLIA_ADMIN_API_KEY")
SEARCH_ONLY_API_KEY=$(cat algolia-keys.json | jq -r ".SEARCH_ONLY_API_KEY")

firebase functions:config:set algolia.appid="$ALGOLIA_APP_ID" algolia.apikey="$ALGOLIA_ADMIN_API_KEY" algolia.searchonlyapikey="$SEARCH_ONLY_API_KEY"

# Generate algolia api keys

# curl https://us-central1-get-canteen.cloudfunctions.net/setAlgoliaSearchAttributes

# # Set up firestore entries
# ## Create groups in firestore
# for file in groups/*
# do
#     if [[ -f $file ]]; then
#         gcloud functions call createGroup --data '{"data":'"$(cat $file)"'}'
#     fi
# done