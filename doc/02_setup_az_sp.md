## 2. Set Up Azure

This procedure should be done only once, even if you delete the cluster and destroy the infrastructure resources.

### Create and Azure account

Browse the Azure portal website and create a new account:

 * http://azure.microsoft.com/

### Configure AZ Cli

Use `az login` to log into your Azure account. A new browser window will open where you can finish the login procedure before returning to the terminal.
If using a remote terminal or an environment without a browser, an special code and URL will be shown to open in another computer's browser to finish the login procedure.

```
$ az login

Note, we have launched a browser for you to login. For old experience with device code, use "az login --use-device-code"
You have logged in. Now let us find all the subscriptions to which you have access...
[
  {
    "cloudName": "AzureCloud",
    "id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "isDefault": true,
    "name": "Your-subscription-name",
    "state": "Enabled",
    "tenantId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "user": {
      "name": "your.email@your.domain.example.com",
      "type": "user"
    }
  }
]
```

Now you'r `az` command line instructions will use your account credentials.

You can check any time what account you are logged in and this information with:

```
$ az account show
```

### Create a Service Principal with the command line

A Service Principal is like a new user that we create to grant permissions to only do what we need it to do. That way we are not using our user with owner role. 

AKS needs a service principal to be able to create virtual machines for the Kubernetes cluster infrastructure.

//TODO: Create the Service Principal using Terraform, see https://medium.com/@kari.marttila/creating-azure-kubernetes-service-aks-the-right-way-9b18c665a6fa

To create a new Service Principal named ServPrincipalAKS, use the following command, replacing 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX' with your account id shown in the previous command's outputs.

```
$ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" --name ServPrincipalAKS

Creating a role assignment under the scope of "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  Retrying role assignment creation: 1/36
  Retrying role assignment creation: 2/36
{
  "appId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "displayName": "azure-cli-XXXX-XX-XX-XX-XX-XX",
  "name": "http://azure-cli-XXXX-XX-XX-XX-XX-XX",
  "password": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "tenant": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
}
```

We will store the client_id (appId) and client_secret (password) for the Service Principal in two environment variables, so Terraform can read them without having to pass them in each call or write them to a file.

```
TF_VAR_client_id="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
TF_VAR_client_secret="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```

The password (client secret) can't be retrieved later, but if you forget this credential, [reset it here](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#reset-credentials).

To retrieve the rest of the data from existing service principals created from the command line, use:

```
az ad sp list --display-name ServPrincipalAKS
```

If you didn't use a name for the service principal, its name will have the prefix "azure-cli-", and you can look for it with:

```
az ad sp list --display-name azure-cli-
```



**Alternative: Create a Service Principal using Azure Portal** 

If you prefer to use the web interface, follow [these instructions](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal). Don't forget to [assign the application](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#assign-the-application-to-a-role) a [contributor role](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)

### Store security parameters in environment variables

* ARM_CLIENT_ID: Service principal id
* ARM_CLIENT_SECRET: Service principal password
* ARM_TENANT_ID: Obtain it from the account info on login
* ARM_SUBSCRIPTION_ID = Obtain it from the account info on login




//TODO:

* Create Service Principal with TF
* Create public IP address
* Create monitoring and logging
* Store secrets in key vault
* Stablish variable types as string