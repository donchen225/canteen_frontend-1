#!/bin/bash

firebase deploy --only functions
firebase deploy --only firestore:rules

for file in groups/*
do
    if [[ -f $file ]]; then
        gcloud functions call createGroup --data '{"data":'"$(cat $file)"'}'
    fi
done