
# Declare environent to setup
ENVIRONMENT="staging"

if [ $ENVIRONMENT == "production" ]
then
    GCLOUD_PROJECT="get-canteen-prod"
elif [ $ENVIRONMENT == "staging" ]
then
    GCLOUD_PROJECT="get-canteen-staging"
else
    GCLOUD_PROJECT="get-canteen"
fi

echo "Setting up Firebase $ENVIRONMENT environment..."

# Switch to firebase project to set up
echo "Switching to Firebase $ENVIRONMENT project"
firebase use $ENVIRONMENT

echo "Switching to $GCLOUD_PROJECT Google Cloud project"
gcloud config set project $GCLOUD_PROJECT

# Set up Cloud Functions secrets
## Load algolia config
ALGOLIA_CONFIG_FILE="gs://canteen-secrets-${ENVIRONMENT}/algolia-keys.json"

echo "Copying config file $ALGOLIA_CONFIG_FILE..."
gsutil cp $ALGOLIA_CONFIG_FILE .

ALGOLIA_APP_ID=$(cat algolia-keys.json | jq -r ".ALGOLIA_APP_ID")
ALGOLIA_ADMIN_API_KEY=$(cat algolia-keys.json | jq -r ".ALGOLIA_ADMIN_API_KEY")
SEARCH_ONLY_API_KEY=$(cat algolia-keys.json | jq -r ".SEARCH_ONLY_API_KEY")

echo "Setting Cloud Functions environment variables..."
firebase functions:config:set algolia.appid="$ALGOLIA_APP_ID" algolia.apikey="$ALGOLIA_ADMIN_API_KEY" algolia.searchonlyapikey="$SEARCH_ONLY_API_KEY"

echo "Deploying all Firebase resources..."
firebase deploy

echo "Generating Algolia API keys..."
gcloud functions call generateAlgoliaSearchApiKeys

echo "Setting algolia search attributes..."
gcloud functions call setAlgoliaSearchAttributes

# Set up firestore entries
## Create groups in firestore
echo "Creating initial groups..."
for file in groups/$ENVIRONMENT/*
do
    if [[ -f $file ]]; then
        gcloud functions call createGroup --data '{"data":'"$(cat $file)"'}'
    fi
done

echo "Generating most popular users..."
#gcloud functions call generateMostPopularUsers