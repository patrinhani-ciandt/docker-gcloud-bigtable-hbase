# Google Cloud SDK + HBase for Google Big Table

## Pre req.
* Set up a [service account](https://cloud.google.com/storGoogle Cloud JSON key to the directory agePutda/authentication#service_accounts), and download a JSON key file for the account:

    1- In the [Developers Console](https://console.developers.google.com), open your project by clicking on the project name.

    2- In the left sidebar, click APIs & auth, then Credentials.

    3- Under OAuth, click Create new Client ID.

    4- Select Service account, then click Create Client ID.

    5- Read the confirmation dialog, then click Okay, got it. A key is downloaded automatically in JSON format. Keep the JSON key in a safe place.

## Initializing the container

    $ docker run -t -i --name=bigtable-dev patrinhani/gcloud-bigtable-hbase bash

## Configuring your Google Cloud Account into the container

Run the commands bellow on your container

    $ gcloud auth login
    $ gcloud config set project [PROJECT_ID]

## Configuring the NHbase client for your Google Cloud Account

1- Put a key.json file containing your Google Cloud JSON key to the directory "/hbase/conf".

2- Run the commands bellow on your container

    $ cd /hbase/conf
    $ chmod +x create-hbase-site
    $ ./create-hbase-site

## Running the HBase shell

    $ hbase shell

## Be fun !
