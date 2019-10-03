[ref-schema]:https://docs.google.com/spreadsheets/d/1Go78fdkdRuJw2Mq8LHp0nVaCGvpEHoAnF4BRY5AFIkc/edit#gid=2005872786 

# Pre-requisites ...

1. Ensure at least version of `5.2.594-g53531417` of Cortex Studio is installed.
2. Ensure at least `v0.12.20` of the Cortex CLI is installed
3. Ensure `jq` is installed.
4. Ensure `csvkit` is installed. If its not, you can run `make setup_first_time` to create a new conda env with the proper requirements, and `$(make activate)` to enter the env. Otherwise, if you want to use your current python environment, run `pip install -r requirements.txt`
5. Configure the Cortex CLI to point to the appropriate tenant.


# Steps to Load Schema and Sample Profiles

1. Download the following sheets from the [CICE Reference Schema][ref-schema] as csv's: CustomerSchema, CustomerSamples, Taxonomy. This can be done by clicking `File > Download > Comma-seperated Values`
2. Run `make cice` if the files downlaoded in the previous step are located in `~/Downloads`, otherwise, run `make cice FILE_DIR=<dir-holding-csvs>`. This step will import the csv's, convert the csv schemas into a JSON schema, save the schema, convert the sample profiles into the appropriate profile building events, and publish the events.
3. Open Cortex Studio, log into the appropriate tenant, enable beta featured (`Help > Beta Features Enabled`)


