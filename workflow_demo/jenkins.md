# Schema CI/CD - Jenkins

At this stage, you should have a Jenkins Multibranch Pipeline integrated with your GitHub repository for Schema CI/CD.  This demonstration will walk through a typical schema change request workflow using Liquibase  with SQLcl.

_**A brief note:**_ This demonstration creates an isolated development environment in a different schema on the same database.  This is to reduce the infrastructure required to run the demo.  Using a different database (incl. OCI Autonomous Database), a different PDB, a Sparse Clone, etc. are interchangeable solutions to the isolated schema approach.  

## Overall Demonstration Process

![Overall Process](images/CICD_Github_Jenkins.drawio.png)

### Step **1**: New Issue is Raised

A new issue is created in your GitHub repository to track the lifecycle of the change.  This is often a bug report, new feature, or enhancement request.

### Step **2**: Issue is Assigned and Branch Created

A DBA/Developer is assigned to the issue.  They create a new "feature" branch, as a copy of the main branch, to work on the issue.  The creation of the "feature" branch will trigger a new build in Jenkins.  

The Jenkins build will create a new schema using Liquibase and code from GitHub.  This allows for work on the issue to be in an isolated environment to develop and test any changes.

### Step **3**: Development Workflow

The DBA/Developer will work on the issue in the newly created isolated schema.  Depending on their preference, this can be done directly in the database or directly in the Liquibase code.  Once the developer is happy with the changes, they commit and push them to the remote "feature" branch.

The push will trigger a new build in Jenkins.  The build will integrate the new code into their schema using Liquibase.  Any additional tests, linting, etc. can be run during this build.  This process continues until the developer is satisfied with the changes.

### Step **4**: Review and Merge

When the developer has completed all of the work on the issue, they will open a Pull Request for approval to merge the changes into the main branch for releasing.  The Pull Request will trigger another build in Jenkins that will tear down their "feature" branch isolated environment (schema); it can also run any additional automated tests required.

If the tear down and additional automated tests succeed, the "Pull Requests" is approved and the changes are merged into the main branch for release.

## Demonstration Steps

### Step **1**: New Issue is Raised

1. Log into GitHub and click on the repository which has been integrated with Jenkins.
2. Create a New Issue
![Create Issue](images/step1-create-issue1.png)
    - Title: Add LAST_UPDATED Column to Inventory Table
    - Write: Add a new column to the inventory table to track the last time the inventory was updated.
    - Submit Issue
    ![Submit Issue](images/step1-create-issue2.png)

### Step **2**: Issue is Assigned and Branch Created

1. If not already on the New Issue, navigate to "Issues" and click on the issue you just created.
2. Assign the issue to yourself and click on "Create a Branch"
![Assign Issue](images/step1-create-issue3.png)
3. On the Pop-Up: Leave Defaults and "Create Branch"
![Create Branch](images/step1-create-issue4.png)

#### Feature Build Pipeline

On the Jenkins Controller, a new build will have been initiated by the creation of the branch.  This build will create the isolated development environment to work on the issue in.
1. Click on "Demonstration"
![Pipeline](images/step-2-Pipeline.png)
2. Click on the "Feature" branch (1-add-last...)
![Build](images/step-2-build.png)
3. Click on "Last Build #1..."
![Build](images/step-2-last-build.png)
4. Click Console Output
![Build](images/step-2-console-output.png)

The Console Output will show that Liquibase created the schema `INVENTORY1`, created the `INVENTORY1.INVENTORY` table, and loaded static data into the table.

### Step **3**: Development Workflow

In the OCI Console, Navigate to the Autonomous Database and click on `Database Actions > SQL`.

Add the new column and run:
```sql
ALTER TABLE INVENTORY1.INVENTORY ADD LAST_UPDATED TIMESTAMP;
```
![Alter](images/step-3-alter-table.png)

#### Export Schema Changes
In Cloud Shell, navigate to your repositories liquibase directory.  This directory contains the Liquibase ChangeSets which define the "Production" schema.  

Ensure you are in the git "feature" branch for your change:
```bash
$ git fetch
remote: Enumerating objects: 32, done.
remote: Counting objects: 100% (32/32), done.
remote: Compressing objects: 100% (30/30), done.
remote: Total 30 (delta 20), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (30/30), 6.76 KiB | 576.00 KiB/s, done.
From https://github.com/gotsysdba/oci-liquibase-jenkins-clone
 * [new branch]      1-add-last_updated-column-to-inventory-table -> origin/1-add-last_updated-column-to-inventory-table

$ git checkout 1-add-last_updated-column-to-inventory-table
Branch '1-add-last_updated-column-to-inventory-table' set up to track remote branch '1-add-last_updated-column-to-inventory-table' from 'origin'.
Switched to a new branch '1-add-last_updated-column-to-inventory-table'

$ git branch
* 1-add-last_updated-column-to-inventory-table
  main
```

Export the change made in the INVENTORY1 schema:

```bash
$ sql /nolog
SQL> set cloudconfig ../wallet/JENKINSDB_wallet.zip
SQL> connect INVENTORY1/<password>@JENKINSDB_HIGH
SQL> lb genschema -split
SQL> exit
```

After exporting, one file would have changed which will represent the change to the schema:

```bash
$ git status
On branch 1-add-last_updated-column-to-inventory-table
Your branch is up to date with 'origin/1-add-last_updated-column-to-inventory-table'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   table/inventory_table.xml

no changes added to commit (use "git add" and/or "git commit -a")
```