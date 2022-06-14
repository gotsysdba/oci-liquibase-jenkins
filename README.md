# oci-liquibase-jenkins

Demonstration of using [Liquibase](https://www.liquibase.org) (via [SQLcl](https://www.oracle.com/uk/database/technologies/appdev/sqlcl.html)) and [Jenkins](https://www.jenkins.io) for CI/CD using [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com) Resources.

## Prerequisites

As this is a demonstration of Jenkins/GitHub integration for CI/CD, you must use your own GitHub account to run it.  Please fork or copy the repository into your own GitHub account before continuing.

## Assumptions

- An existing OCI tenancy; currently Paid is only supported.  Always Free will be supported later.
- An existing [GitHub](https://github.com) Account
- You have **forked** or **copied** this repository into your GitHub account

## Architecture Deployment

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

### Add Jenkins Credential

Login to Jenkins using the admin username and go to `Manage Jenkins > Manage Credentials`:

1. Under "Stores scoped to Jenkins", click "Jenkins"
2. Click "Global credentials (unrestricted)"
3. Click "Add Credentials"
    - **Kind:**   GitHub App
    - **ID:**     GitHubAppDemo
    - **App ID:** < App ID > (Recorded above)
    - **Key:**    < Contents of converted-github-app.pem created above >

Test Connection is successful.

### Add Database Credential

Login to Jenkins using the admin username and go to `Manage Jenkins > Manage Credentials`:

1. Under "Stores scoped to Jenkins", click "Jenkins"
2. Click "Global credentials (unrestricted)"
3. Click "Add Credentials"
    - **Kind:**     Username with password
    - **Username:** ADMIN
    - **Password:** `<Password for ADB Admin Account>`
    - **ID:**       JENKINSDB_ADMIN

### Add an Multibranch Pipeline

From the Jenkins Dashboard, click "New Item":

1. **Item Name:** Demonstration
2. Select: `Multibranch Pipeline > OK`
    - **Display Name:** Demonstration
    - **Branch Source:** GitHub
    - **Credentials:** GitHubAppDemo
    - **Repository HTTPS URL:** < Link to GitHub Repo; example: `https://github.com/gotsysdba/oci-liquibase-jenkins`>
3. Scroll down and "Save"
