
# Declare environent to setup
ENVIRONMENT="development"

echo "Setting up Firebase $ENVIRONMENT environment..."

# Switch to firebase project to set up
firebase use $ENVIRONMENT

# Create groups in firestore
for file in groups/*
do
    if [[ -f $file ]]; then
        gcloud functions call createGroup --data '{"data":'"$(cat $file)"'}'
    fi
done