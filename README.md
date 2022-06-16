# oci-liquibase-jenkins
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=gotsysdba_oci-liquibase-jenkins&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=gotsysdba_oci-liquibase-jenkins)[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=gotsysdba_oci-liquibase-jenkins&metric=ncloc)](https://sonarcloud.io/summary/new_code?id=gotsysdba_oci-liquibase-jenkins)

Demonstration of using [Liquibase](https://www.liquibase.org) (via [SQLcl](https://www.oracle.com/uk/database/technologies/appdev/sqlcl.html)) and [Jenkins](https://www.jenkins.io) for CI/CD using [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com) Resources.

## Prerequisites

As this is a demonstration of Jenkins/GitHub integration for CI/CD, you must use your own GitHub account to run it.  Please fork or copy the repository into your own GitHub account before continuing.

## Assumptions

- An existing OCI tenancy
- An existing [GitHub](https://github.com) Account
- You have **forked** or **copied** this repository into your GitHub account

## Architecture Deployment

By default, Always Free resources will be used.  If you do not have any Always Free resources available and are using paid tenancy, this demonstration can still be run by changing the Terraform variable to `is_paid=true` (as documented in the [infra/README.md](infra/README.md)).

There are two main ways to deploy this Architecture:

- OCI Cloud Shell
- Terraform Client (Advanced)

View the [infra/README.md](infra/README.md) for more information.

## Jenkins/GitHub Integration

Once the infrastructure is deployed, Jenkins and GitHub will need to be configured to interact.  This is done using the [Github Branch Source Plugin](https://github.com/jenkinsci/github-branch-source-plugin)

### Create the GitHub App

1. In your Github Account, navigate to `Settings -> Developer settings -> GitHub Apps`
2. Select "New GitHub App" (Confirm Password)
3. Register new GitHub App, Unless other specified below, leave the defaults
    - **GitHub App name:** Jenkins - < Github Account Name >
    - **Homepage URL:** < Link to your GitHub Page; example: `https://github.com/gotsysdba` >
    - **Webhook URL:** < Link to your Jenkins Server; example: `https://jenkins.example.com/github-webhook/` >
    - **Repository permissions:**
        - Commit statuses - Read and Write
        - Contents: Read-only
        - Pull requests: Read-only
    - **Subscribe to events:** Select All
    - **Where can this GitHub App be installed?** Only on this account
4. Click "Create GitHub App"
5. Record the `App ID` to be used later
6. Scroll down to "Private keys" and Generate a private key (will be prompted to save; save it to a safe location)
7. Scroll back up the page and click "Install App"
    - Click "Install" next to your GitHub account name
    - Only select repositories; choose as required
    - Install

### Convert the Private Key

In order for Jenkins to use the private key, saved above, convert it:
`openssl pkcs8 -topk8 -inform PEM -outform PEM -in <key-in-your-downloads-folder.pem> -out converted-github-app.pem -nocrypt`

If `openssl` is not installed on your local machine, you can use [OCI Cloud Shell](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cloudshellintro.htm) to convert.

1. Open Cloud Shell from the OCI Console
2. Either drag and drop the file from your local machine into the Cloud Shell window, or use the "Upload" button from the Cloud Shell hamburger menu.
3. Run the above `openssl` command in the Cloud Shell

### Add Jenkins Credential

Login to Jenkins using the admin username and go to `Manage Jenkins > Manage Credentials`:

1. Under "Stores scoped to Jenkins", click "Jenkins"
2. Click "Global credentials (unrestricted)"
3. Click "Add Credentials" in the Left Hand Navigation bar
    - **Kind:**   GitHub App
    - **ID:**     GitHubAppDemo
    - **App ID:** < App ID > (Recorded above)
    - **Key:**    < Contents of converted-github-app.pem created above >
4. Click "Test Connection" which should be successful.
5. Click "OK"

### Add Database Credential

From the Jenkins Dashboard go to `Manage Jenkins > Manage Credentials`:

1. Under "Stores scoped to Jenkins", click "Jenkins"
2. Click "Global credentials (unrestricted)"
3. Click "Add Credentials" in the Left Hand Navigation bar
    - **Kind:**     Username with password
    - **Username:** ADMIN
    - **Password:** `<Password for ADB Admin Account>`
    - **ID:**       JENKINSDB_ADMIN
4. Click "OK"

### Add an Multibranch Pipeline

From the Jenkins Dashboard, click "New Item":

1. **Item Name:** Demonstration
2. Select: `Multibranch Pipeline > OK`
    - **Display Name:** Demonstration
    - **Branch Source:** GitHub
    - **Credentials:** GitHubAppDemo
    - **Repository HTTPS URL:** < Link to GitHub Repo; example: `https://github.com/gotsysdba/oci-liquibase-jenkins`>
3. Click "Validate" under the "Repository HTTPS URL" field
    - Response should be: "Credentials ok. Connected to `<GitHub Repo>`."
4. Scroll down and "Save"
5. A "Scan Repository Log" screen will appear with "Finished: SUCCESS"
6. Integration is Configured! Proceed to the Hands On [Demonstration](workflow_demo/jenkins.md)