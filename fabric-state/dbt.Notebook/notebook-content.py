# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "environment": {
# META       "environmentId": "9155d952-f2b3-4bf2-8604-c1aaece7e245",
# META       "workspaceId": "00000000-0000-0000-0000-000000000000"
# META     }
# META   }
# META }

# PARAMETERS CELL ********************

client_id = ""
client_secret = ""
tenant_id = "55226c2c-0b83-4621-a5cd-e8e0e57ec920"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

mssparkutils.credentials.getToken("https://vault.azure.net")[2:]

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

mssparkutils.credentials.getToken("https://graph.microsoft.com/")[2:]

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# storage_bearer = mssparkutils.credentials.getToken("https://storage.azure.com/")
# storage_bearer[2:]

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

if client_id == "":
    client_id = mssparkutils.credentials.getSecret('https://jonasfabric.vault.azure.net','client-id')

if client_secret == "":
    client_secret = mssparkutils.credentials.getSecret('https://jonasfabric.vault.azure.net','client-secret')


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

tenant_id

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

!export test={tenant_id}

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

%env AZURE_TENANT_ID={tenant_id}
%env AZURE_CLIENT_ID={client_id}
%env AZURE_CLIENT_SECRET={client_secret}

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# MAGIC %%bash 
# MAGIC 
# MAGIC git clone https://github.com/jonascrevecoeur/playground-fabric-examples.git -b dev

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# MAGIC %%bash
# MAGIC 
# MAGIC # use defaultAzureCredential authentication
# MAGIC sed -i -e 's/CLI/auto/g' playground-fabric-examples/dbt/fabric_demo/profiles.yml
# MAGIC sed -i -e 's/Driver 17 for/Driver 18 for/g' playground-fabric-examples/dbt/fabric_demo/profiles.yml
# MAGIC cat playground-fabric-examples/dbt/fabric_demo/profiles.yml


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# MAGIC %%bash 
# MAGIC 
# MAGIC cd playground-fabric-examples/dbt/fabric_demo/
# MAGIC dbt run

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
